//
//    PowerQueryTests.swift
//
//    Copyright (c) 2020 Cooper Edmunds & Doug Penny – North Raleigh Christian Academy
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
@testable import SwiftyPSCore


class PowerQueryTests: XCTestCase {
    static var allTests = [
            ("testEnrollmentsForSections", testEnrollmentsForSections),
        ]

    var client: SwiftyPSCore!
    var params: TestingParameters!

    override func setUp() {
        super.setUp()
        print("EndpointTests setup called--")
        /**
         This is a temporary workaround becuase Swift packages do not currently support resources. This will be
         resolved in Swift 5.3: https://github.com/apple/swift-evolution/blob/master/proposals/0271-package-manager-resources.md
         
         The following 4 lines can be replaced with the following single line of code:
         if let paramFilePath = Bundle(for: type(of: self)).path(forResource: "testing_parameters", ofType: "json")
         */
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let paramFileURL = thisDirectory.appendingPathComponent("testing_parameters.json")
        if paramFileURL != URL(fileURLWithPath: "") {
            let decoder = JSONDecoder()
            do {
                let paramData = try Data(contentsOf: paramFileURL)
                self.params = try decoder.decode(TestingParameters.self, from: paramData)
                self.client = SwiftyPSCore(self.params.baseURL,
                                                clientID: self.params.clientID,
                                                clientSecret: self.params.clientSecret)
            } catch let parseError {
                XCTFail("Failed to decode JSON parameters file.\nError: \(parseError.localizedDescription)")
            }
        } else {
            print("File not found!")
        }
    }
    
    func testEnrollmentsForSections() {
        if let testSection = self.params.testSection {
            let enrollmentsForSectionsExpectation = self.expectation(description: "get section enrollments")

            client.enrollmentsForSections([testSection.sectionDCID]) { enrollments, error in
                if let enrollments = enrollments {
                    if let testEnrollments = testSection.enrollments {
                        XCTAssertEqual(testEnrollments[0].dcid, enrollments[0].dcid)
                        XCTAssertEqual(testEnrollments[0].gradeLevel, enrollments[0].gradeLevel)
                        XCTAssertEqual(testEnrollments[0].lastFirst, enrollments[0].lastFirst)
                        XCTAssertEqual(testEnrollments[1].studentNumber, enrollments[1].studentNumber)
                        XCTAssertEqual(testEnrollments[1].gender, enrollments[1].gender)
                        XCTAssertEqual(testEnrollments[1].id, enrollments[1].id)
                        enrollmentsForSectionsExpectation.fulfill()
                    } else {
                        XCTFail(error?.localizedDescription ?? "There were no test section enrollments defined.")
                    }
                } else {
                    XCTFail(error?.localizedDescription ?? "An error occured retreiving the section enrollments.")
                }
            }

            self.waitForExpectations(timeout: 5) { error in
                if let error = error {
                    XCTFail(error.localizedDescription)
                }
            }
        } else {
            XCTFail("No test section found.")
        }
    }
}
