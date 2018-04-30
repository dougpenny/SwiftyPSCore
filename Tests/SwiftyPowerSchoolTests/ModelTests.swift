//
//    ModelTests.swift
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

//    swiftlint:disable function_body_length type_body_length line_length

import XCTest
@testable import SwiftyPowerSchool

class ModelTests: XCTestCase {
    static var allTests = [
        ("testSchoolModel", testSchoolModel),
        ("testCourseModel", testCourseModel),
        ("testSectionModel", testSectionModel),
        ("testTeacherSectionsModel", testTeacherSectionsModel),
        ("testResourceCountModel", testResourceCountModel)
    ]

    func testSchoolModel() {
        let jsonSchoolsExample =
"""
{
    "schools": {
        "@expansions": "school_boundary, full_time_equivalencies, school_fees_setup",
        "@extensions": "schoolscorefields,c_school_registrar,s_sch_crdc_x,schoolssuccessnetfields,s_sch_ncea_x",
        "school": [
            {
                "id": 2,
                "name": "George Washington High School",
                "school_number": 3,
                "low_grade": 9,
                "high_grade": 12,
                "alternate_school_number": 0,
                "addresses": {
                    "physical": {
                        "street": "123 Cherry Tree Ave",
                        "city": "Big City",
                        "state_province": "VT",
                        "postal_code": 12345
                    }
                },
                "phones": {
                    "main": {
                        "number": "444-555-1234"
                    }
                },
                "principal": {
                    "name": {
                        "first_name": "Thomas",
                        "last_name": "Jefferson"
                    },
                    "email": "tj@gwhs.com"
                },
                "assistant_principal": {
                    "name": {
                        "first_name": "John",
                        "last_name": "Adams"
                    },
                    "email": "ja@gwhs.com"
                }
            }
        ]
    }
}
"""
        if let data = jsonSchoolsExample.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                let allSchools = try decoder.decode(Schools.self, from: data)
                if let schools = allSchools.data {
                    XCTAssertEqual(schools[0].schoolNumber, 3)
                    if let city = schools[0].addresses?.physical?.city {
                        XCTAssertEqual(city, "Big City")
                    } else { XCTFail("Address 'city' field is nil") }
                    if let firstName = schools[0].principal?.name?.firstName {
                        XCTAssertEqual(firstName, "Thomas")
                    } else { XCTFail("Principal 'firstName' field is nil") }
                    if let email = schools[0].principal?.email {
                        XCTAssertEqual(email, "tj@gwhs.com")
                    } else { XCTFail("Principal 'email' field is nil") }
                } else { XCTFail("Schools data array is nil") }
            } catch let parseError {
                XCTFail(parseError.localizedDescription)
            }
        }
    }

    func testClassRosterModel() {
        let jsonClassRosterExample =
        """
{
    "name": "STUDENTS",
    "record": [
        {
            "grade_level": "1",
            "_name": "STUDENTS",
            "dcid": "5978",
            "gender": "M",
            "lastfirst": "Appleseed, Johnny",
            "student_number": "78219",
            "last_name": "Appleseed",
            "_id": 5978,
            "id": "16789",
            "first_name": "Johnny"
        },
        {
            "grade_level": "7",
            "_name": "STUDENTS",
            "dcid": "5849",
            "gender": "F",
            "lastfirst": "Appleseed, Sally",
            "student_number": "61597",
            "last_name": "Appleseed",
            "_id": 5849,
            "id": "13598",
            "first_name": "Sally"
        }
    ],
    "@extensions": "activities,studentcorefields,u_students_extension,s_stu_ncea_x,s_stu_crdc_x,c_studentlocator,s_stu_edfi_x"
}
"""
        if let data = jsonClassRosterExample.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                let classRoster = try decoder.decode(ClassRoster.self, from: data)
                if let students = classRoster.data {
                    XCTAssertEqual(students[0].gradeLevel, 1)
                    XCTAssertEqual(students[0].lastFirst, "Appleseed, Johnny")
                    XCTAssertEqual(students[1].gender, "F")
                    XCTAssertEqual(students[1].studentNumber, 61597)
                } else { XCTFail("Class roster students array is nil") }
            } catch let parseError {
                XCTFail(parseError.localizedDescription)
            }
        }
    }

    func testCourseModel() {
        let jsonCoursesExample =
"""
{
    "courses": {
        "@extensions": "s_crs_crdc_x",
        "course": [
            {
                "id": 2135,
                "course_number": "CSC101",
                "course_name": "Computer Science I"
            }
        ]
    }
}
"""
        if let data = jsonCoursesExample.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                let allCourses = try decoder.decode(Courses.self, from: data)
                if let courses = allCourses.data {
                    XCTAssertEqual(courses.count, 1)
                    XCTAssertEqual(courses[0].id, 2135)
                    XCTAssertEqual(courses[0].number, "CSC101")
                } else { XCTFail("Courses data array is nil") }
            } catch let parseError {
                XCTFail(parseError.localizedDescription)
            }
        }
    }

    func testSectionModel() {
        let jsonSectionsExample =
"""
{
    "sections": {
        "@expansions": "term",
        "@extensions": "s_sec_crdc_x,s_sec_edfi_x",
        "section": [
            {
                "id": 1500,
                "school_id": 3,
                "course_id": 1391,
                "term_id": 1989,
                "section_number": 5,
                "expression": "8(A-E)",
                "external_expression": "6(M-F)",
                "staff_id": 3955,
                "gradebooktype": "PTG"
            },
            {
                "id": 15919,
                "school_id": 3,
                "course_id": 1391,
                "term_id": 1989,
                "section_number": 6,
                "expression": "9(A-E)",
                "external_expression": "7(M-F)",
                "staff_id": 3955,
                "gradebooktype": "PTG"
            }
        ]
    }
}
"""
        if let data = jsonSectionsExample.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                let allSections = try decoder.decode(Sections.self, from: data)
                if let sections = allSections.data {
                    XCTAssertEqual(sections.count, 2)
                    XCTAssertEqual(sections[0].id, 1500)
                    XCTAssertEqual(sections[0].expression, "8(A-E)")
                    XCTAssertEqual(sections[1].staffID, 3955)
                    XCTAssertEqual(sections[1].gradebookType, "PTG")
                } else { XCTFail("Sections data array is nil") }
            } catch let parseError {
                XCTFail(parseError.localizedDescription)
            }
        }
    }

    func testTeacherSectionsModel() {
        let jsonTeacherSectionsExample =
        """
{
    "name": "SECTIONS",
    "record": [
        {
            "_name": "SECTIONS",
            "course_number": "SOC441",
            "course_name": "Honors US Constitution",
            "num_students": "25",
            "id": "21329",
            "external_expression": "1(M-F)",
            "room": "J301"
        },
        {
            "_name": "SECTIONS",
            "course_number": "MISC112",
            "course_name": "Study Hall",
            "num_students": "2",
            "id": "21962",
            "external_expression": "2(M-F)",
            "room": "J301"
        }
    ],
    "@extensions": "s_sec_edfi_x,s_sec_crdc_x"
}
"""
        if let data = jsonTeacherSectionsExample.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                let allSections = try decoder.decode(TeacherSections.self, from: data)
                let sections = allSections.data
                XCTAssertEqual(sections.count, 2)
                XCTAssertEqual(sections[0].sectionID, "21329")
                XCTAssertEqual(sections[0].expression, "1(M-F)")
                XCTAssertEqual(sections[0].numStudents, "25")
                XCTAssertEqual(sections[1].room, "J301")
                XCTAssertEqual(sections[1].courseName, "Study Hall")
            } catch let parseError {
                XCTFail(parseError.localizedDescription)
            }
        }
    }

    func testResourceCountModel() {
        let jsonResourceCountExample =
"""
{
    "resource": {
        "count": 20
    }
}
"""
        if let data = jsonResourceCountExample.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                let resourceCount = try decoder.decode(ResourceCount.self, from: data)
                if let count = resourceCount.count {
                    XCTAssertEqual(count, 20)
                } else { XCTFail("'Count' field is nil") }
            } catch let parseError {
                XCTFail(parseError.localizedDescription)
            }
        }
    }
}
