//
//    Students.swift
//
//    Copyright (c) 2018 Doug Penny – North Raleigh Christian Academy
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

public struct Students: Codable {
    private let studentsWrapper: StudentContainer?
    var data: [Student]? {
        return studentsWrapper?.students
    }

    enum CodingKeys: String, CodingKey {
        case studentsWrapper = "students"
    }
}

private struct StudentContainer: Codable {
    let students: [Student]?

    enum CodingKeys: String, CodingKey {
        case students = "student"
    }
}

public struct Student: Codable {
    let addresses: Addresses?
    let dcid: Int?
    let demographics: Demographics?
    let name: Name?
    let phones: Phones?
    let studentNumber: Int?
    let studentUsername: String?

    enum CodingKeys: String, CodingKey {
        case addresses
        case dcid = "id"
        case demographics
        case name
        case phones
        case studentNumber = "local_id"
        case studentUsername = "student_username"
    }
}

extension StudentContainer {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let studentsArray = try container.decode(Array<Student>.self, forKey: .students)
            self.init(students: studentsArray)
        } catch DecodingError.typeMismatch(_, _) {
            let student = try container.decode(Student.self, forKey: .students)
            self.init(students: [student])
        }
    }
}
