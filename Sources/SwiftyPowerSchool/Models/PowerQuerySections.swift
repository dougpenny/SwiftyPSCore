//
//    PowerQuerySections.swift
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

//    swiftlint:disable identifier_name

public struct PowerQuerySections: Codable {
    let data: [SectionInfo]?

    enum CodingKeys: String, CodingKey {
        case data = "record"
    }
}

public struct SectionInfo: Codable {
    let courseName: String?
    let courseNumber: String?
    var dcid: Int? {
        return Int(dcidString)
    }
    var id: Int? {
        return Int(idString)
    }
    var numStudents: Int? {
        return Int(numStudentsString)
    }
    let period: String?
    let room: String?
    var sectionNumber: Int? {
        return Int(sectionNumberString)
    }
    var teacherID: Int? {
        return Int(teacherIDString)
    }

    private let dcidString: String
    private let idString: String
    private let numStudentsString: String
    private let sectionNumberString: String
    private let teacherIDString: String

    enum CodingKeys: String, CodingKey {
        case courseName = "course_name"
        case courseNumber = "course_number"
        case dcidString = "dcid"
        case idString = "id"
        case numStudentsString = "num_students"
        case period = "external_expression"
        case room
        case sectionNumberString = "section_number"
        case teacherIDString = "teacher"
    }
}
