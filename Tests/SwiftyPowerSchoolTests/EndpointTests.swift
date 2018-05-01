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
        ("testSchoolsCount", testSchoolsCount),
        ("testTeacherSections", testTeacherSections)
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

    func testHomeroomRosterForTeacher() {
        if let testTeacher = self.params.testTeacher {
            let teacherHomeroomRosterExpectation = self.expectation(description: "get homeroom roster")

            client.homeroomRosterForTeacher(testTeacher.teacherID) { homeroomRoster, error in
                if let homeroomRoster = homeroomRoster {
                    if let testHomeroomRoster = testTeacher.homeroomRoster {
                        XCTAssertEqual(testHomeroomRoster[0].gradeLevel, homeroomRoster[0].gradeLevel)
                        XCTAssertEqual(testHomeroomRoster[0].lastFirst, homeroomRoster[0].lastFirst)
                        XCTAssertEqual(testHomeroomRoster[1].studentNumber, homeroomRoster[1].studentNumber)
                        XCTAssertEqual(testHomeroomRoster[1].gender, homeroomRoster[1].gender)
                        teacherHomeroomRosterExpectation.fulfill()
                    } else {
                        XCTFail(error?.localizedDescription ?? "There was no test homeroom roster defined.")
                    }
                } else {
                    XCTFail(error?.localizedDescription ?? "An error occured retreiving the teacher's homeroom roster.")
                }
            }

            self.waitForExpectations(timeout: 1) { error in
                if let error = error {
                    XCTFail(error.localizedDescription)
                }
            }
        } else {
            XCTFail("No teacher ID found")
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

    func testTeacherSections() {
        if let testTeacher = self.params.testTeacher {
            let teacherSectionsExpectation = self.expectation(description: "get teacher sections")

            client.sectionsForTeacher(testTeacher.teacherID) { teacherSections, error in
                if let teacherSections = teacherSections {
                    if let testTeacherSections = testTeacher.teacherSections {
                        XCTAssertEqual(testTeacherSections[0].courseNumber, teacherSections[0].courseNumber)
                        XCTAssertEqual(testTeacherSections[0].courseName, teacherSections[0].courseName)
                        XCTAssertEqual(testTeacherSections[0].expression, teacherSections[0].expression)
                        XCTAssertEqual(testTeacherSections[0].room, teacherSections[0].room)
                        teacherSectionsExpectation.fulfill()
                    } else {
                        XCTFail(error?.localizedDescription ?? "There were no test sections defined.")
                    }
                } else {
                    XCTFail(error?.localizedDescription ?? "An error occured retreiving the teacher's sections.")
                }
            }

            self.waitForExpectations(timeout: 1) { error in
                if let error = error {
                    XCTFail(error.localizedDescription)
                }
            }
        } else {
            XCTFail("No teacher ID found")
        }
    }
}
