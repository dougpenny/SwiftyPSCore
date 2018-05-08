//
//    EndpointTests.swift
//
//    Copyright (c) 2018 Cooper Edmunds & Doug Penny – North Raleigh Christian Academy
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

import XCTest
@testable import SwiftyPowerSchool

class EndpointTests: XCTestCase {
    static var allTests = [
            ("testSchoolsCount", testSchoolsCount)
        ]

    var client: SwiftyPowerSchool!
    var params: TestingParameters!

    override func setUp() {
        super.setUp()
        print("EndpointTests setup called--")
        if let paramFilePath = Bundle(for: type(of: self)).path(forResource: "testing_parameters", ofType: "json") {
            let decoder = JSONDecoder()
            do {
                let paramData = try Data(contentsOf: URL(fileURLWithPath: paramFilePath))
                self.params = try decoder.decode(TestingParameters.self, from: paramData)
                self.client = SwiftyPowerSchool(self.params.baseURL,
                                                clientID: self.params.clientID,
                                                clientSecret: self.params.clientSecret)
            } catch let parseError {
                XCTFail("Failed to decode JSON parameters file.\nError: \(parseError.localizedDescription)")
            }
        } else {
            print("File not found!")
        }
    }

    func testRetrieveAllStudents() {
        if let testStudents = self.params.testStudents {
            let studentsExpectation = self.expectation(description: "get all students")

            client.studentsInDistrict { students, error in
                if let students = students {
                    XCTAssertEqual(testStudents[0].dcid, students[0].dcid)
                    XCTAssertEqual(testStudents[0].studentNumber, students[0].studentNumber)
                    XCTAssertEqual(testStudents[0].studentUsername, students[0].studentUsername)
                    XCTAssertEqual(testStudents[0].name?.firstName, students[0].name?.firstName)
                    XCTAssertEqual(testStudents[0].name?.middleName, students[0].name?.middleName)
                    XCTAssertEqual(testStudents[0].name?.lastName, students[0].name?.lastName)
                    XCTAssertEqual(testStudents[1].dcid, students[1].dcid)
                    XCTAssertEqual(testStudents[1].studentNumber, students[1].studentNumber)
                    XCTAssertEqual(testStudents[1].studentUsername, students[1].studentUsername)
                    XCTAssertEqual(testStudents[1].name?.firstName, students[1].name?.firstName)
                    XCTAssertEqual(testStudents[1].name?.middleName, students[1].name?.middleName)
                    XCTAssertEqual(testStudents[1].name?.lastName, students[1].name?.lastName)
                    XCTAssertEqual(testStudents[2].dcid, students[2].dcid)
                    XCTAssertEqual(testStudents[2].studentNumber, students[2].studentNumber)
                    XCTAssertEqual(testStudents[2].studentUsername, students[2].studentUsername)
                    XCTAssertEqual(testStudents[2].name?.firstName, students[2].name?.firstName)
                    XCTAssertEqual(testStudents[2].name?.middleName, students[2].name?.middleName)
                    XCTAssertEqual(testStudents[2].name?.lastName, students[2].name?.lastName)
                    XCTAssertEqual(testStudents[3].dcid, students[3].dcid)
                    XCTAssertEqual(testStudents[3].studentNumber, students[3].studentNumber)
                    XCTAssertEqual(testStudents[3].studentUsername, students[3].studentUsername)
                    XCTAssertEqual(testStudents[3].name?.firstName, students[3].name?.firstName)
                    XCTAssertEqual(testStudents[3].name?.middleName, students[3].name?.middleName)
                    XCTAssertEqual(testStudents[3].name?.lastName, students[3].name?.lastName)
                    XCTAssertEqual(testStudents[4].dcid, students[4].dcid)
                    XCTAssertEqual(testStudents[4].studentNumber, students[4].studentNumber)
                    XCTAssertEqual(testStudents[4].studentUsername, students[4].studentUsername)
                    XCTAssertEqual(testStudents[4].name?.firstName, students[4].name?.firstName)
                    XCTAssertEqual(testStudents[4].name?.middleName, students[4].name?.middleName)
                    XCTAssertEqual(testStudents[4].name?.lastName, students[4].name?.lastName)
                    studentsExpectation.fulfill()
                } else {
                    XCTFail(error?.localizedDescription ?? "An error occured retreiving the students.")
                }
            }

            self.waitForExpectations(timeout: 1) { error in
                if let error = error {
                    XCTFail(error.localizedDescription)
                }
            }
        } else {
            XCTFail("No test students found.")
        }
    }

    func testSchoolsCount() {
        let schoolsCountExpectation = self.expectation(description: "get schools count")

        client.schoolsCount { schoolsCount, error in
            if let schoolsCount = schoolsCount {
                if let testCount = self.params.schoolsCount {
                    XCTAssertEqual(testCount, schoolsCount)
                    schoolsCountExpectation.fulfill()
                } else {
                    XCTFail(error?.localizedDescription ?? "A schools count test item was not defined.")
                }
            } else {
                XCTFail(error?.localizedDescription ?? "An error occured retreiving the schools count.")
            }
        }

        self.waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
}
