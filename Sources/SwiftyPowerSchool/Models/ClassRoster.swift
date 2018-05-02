//
//  ClassRoster.swift
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

//    swiftlint:disable identifier_name

public struct ClassRoster: Codable {
    let data: [StudentItem]?

    enum CodingKeys: String, CodingKey {
        case data = "record"
    }
}

public struct StudentItem: Codable {
    var dcid: Int? {
        return Int(dcidString ?? "")
    }
    let firstName: String?
    var gradeLevel: Int? {
        return Int(gradeLevelString ?? "")
    }
    let gender: String?
    var id: Int? {
        return Int(idString ?? "")
    }
    let lastFirst: String?
    let lastName: String?
    var studentNumber: Int? {
        return Int(studentNumberString ?? "")
    }

    private let dcidString: String?
    private let gradeLevelString: String?
    private let idString: String?
    private let studentNumberString: String?

    enum CodingKeys: String, CodingKey {
        case dcidString = "dcid"
        case firstName = "first_name"
        case gradeLevelString = "grade_level"
        case gender
        case idString = "id"
        case lastFirst = "lastfirst"
        case lastName = "last_name"
        case studentNumberString = "student_number"
    }
}
