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
            ("testEnrollmentsForSections", testEnrollmentsForSections),
            ("testHomeroomRosterForTeacher", testHomeroomRosterForTeacher),
            ("testResourceCount", testResourceCount),
            ("testSectionsForCourseNumber", testSectionsForCourseNumber),
            ("testSectionsForSchool", testSectionsForSchool),
            ("testTeacherSections", testTeacherSections),
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
            
            self.waitForExpectations(timeout: 1) { error in
                if let error = error {
                    XCTFail(error.localizedDescription)
                }
            }
        } else {
            XCTFail("No test section found.")
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
            XCTFail("No test teacher found.")
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

    func testResourceCount() {
        let resourceCountExpectation = self.expectation(description: "get count of a resource")
        let resourcePath = "/ws/v1/district/school"

        client.resourceCount(path: resourcePath) { resourceCount, error in
            if let resourceCount = resourceCount {
                if let testCount = self.params.schoolsCount {
                    XCTAssertEqual(resourceCount, testCount)
                    resourceCountExpectation.fulfill()
                } else {
                    XCTFail(error?.localizedDescription ?? "A schools count test item was not defined.")
                }
            } else {
                XCTFail(error?.localizedDescription ?? "An error occured retreiving the resource count.")
            }
        }

        self.waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testSectionsForCourseNumber() {
        if let testCourse = self.params.testCourse {
            let courseSectionsExpectation = self.expectation(description: "get sections for course number")

            client.sectionsForCourseNumber(testCourse.courseNumber) { courseSections, error in
                if let courseSections = courseSections {
                    if let testCourseSections = testCourse.courseSections {
                        XCTAssertEqual(testCourseSections[0].courseNumber, courseSections[0].courseNumber)
                        XCTAssertEqual(testCourseSections[0].courseName, courseSections[0].courseName)
                        XCTAssertEqual(testCourseSections[0].period, courseSections[0].period)
                        XCTAssertEqual(testCourseSections[0].room, courseSections[0].room)
                        XCTAssertEqual(testCourseSections[0].numStudents, courseSections[0].numStudents)
                        XCTAssertEqual(testCourseSections[0].id, courseSections[0].id)
                        XCTAssertEqual(testCourseSections[0].teacherID, courseSections[0].teacherID)
                        XCTAssertEqual(testCourseSections[0].dcid, courseSections[0].dcid)
                        XCTAssertEqual(testCourseSections[0].sectionNumber, courseSections[0].sectionNumber)
                        courseSectionsExpectation.fulfill()
                    } else {
                        XCTFail(error?.localizedDescription ?? "There were no test sections defined.")
                    }
                } else {
                    XCTFail(error?.localizedDescription ?? "An error occured retreiving the course sections.")
                }
            }

            self.waitForExpectations(timeout: 1) { error in
                if let error = error {
                    XCTFail(error.localizedDescription)
                }
            }
        } else {
            XCTFail("No test course found.")
        }
    }
    
    func testSectionsForSchool() {
        let schoolSectionsExpectation = self.expectation(description: "get sections for school")
        let schoolID = 1
        let resourcePath = "/ws/v1/school/\(schoolID)/section"

        client.sectionsForSchool(schoolID) { sections, error in
            if let sections = sections {
                self.client.resourceCount(path: resourcePath) { sectionsCount, error in
                    if let sectionsCount = sectionsCount {
                        XCTAssertEqual(sections.count, sectionsCount)
                        schoolSectionsExpectation.fulfill()
                    }
                }
            }
            else {
                XCTFail()
            }
        }
        
        self.waitForExpectations(timeout: 5) { error in
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
                        XCTAssertEqual(testTeacherSections[0].period, teacherSections[0].period)
                        XCTAssertEqual(testTeacherSections[0].room, teacherSections[0].room)
                        XCTAssertEqual(testTeacherSections[0].numStudents, teacherSections[0].numStudents)
                        XCTAssertEqual(testTeacherSections[0].id, teacherSections[0].id)
                        XCTAssertEqual(testTeacherSections[0].teacherID, teacherSections[0].teacherID)
                        XCTAssertEqual(testTeacherSections[0].dcid, teacherSections[0].dcid)
                        XCTAssertEqual(testTeacherSections[0].sectionNumber, teacherSections[0].sectionNumber)
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
            XCTFail("No test teacher found.")
        }
    }
}
