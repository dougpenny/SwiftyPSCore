//
//    TestingParameters.swift
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

@testable import SwiftyPSCore

public struct TestingParameters: Codable {
    let baseURL: String
    let clientID: String
    let clientSecret: String
    let schoolsCount: Int?
    let schoolNames: [String]?
    let testSchool: TestSchool?

    public struct TestSchool: Codable {
        let schoolNumber: Int
        let courseCount: Int
    }

    let testTeacher: TestTeacher?

    public struct TestTeacher: Codable {
        let teacherID: Int
        let dcid: Int
        let teacherSections: [SectionInfo]?
        let teacherSectionsCount: Int?
        let homeroomRoster: [StudentItem]?
    }

    let testSection: TestSection?

    public struct TestSection: Codable {
        let sectionDCID: String
        let enrollments: [StudentItem]?
    }

    let testCourse: TestCourse?

    public struct TestCourse: Codable {
        let courseNumber: String
        let courseSections: [SectionInfo]?
    }

    let testStudents: [Student]?
}
