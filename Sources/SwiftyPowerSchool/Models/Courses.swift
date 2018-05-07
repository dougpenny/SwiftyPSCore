//
//    Courses.swift
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

public struct Courses: Codable {
    private let coursesWrapper: CourseContainer?

    var data: [Course]? {
        return self.coursesWrapper?.courses
    }

    enum CodingKeys: String, CodingKey {
        case coursesWrapper = "courses"
    }
}

private struct CourseContainer: Codable {
    let courses: [Course]?

    enum CodingKeys: String, CodingKey {
        case courses = "course"
    }
}

public struct Course: Codable {
    let id: Int?
    let number: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case number = "course_number"
        case name = "course_name"
    }
}

extension CourseContainer {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let coursesArray = try container.decode(Array<Course>.self, forKey: .courses)
            self.init(courses: coursesArray)
        } catch DecodingError.typeMismatch( _, _) {
            let course = try container.decode(Course.self, forKey: .courses)
            self.init(courses: [course])
        }
    }
}
