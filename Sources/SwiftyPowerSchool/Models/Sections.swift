//
//    Sections.swift
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


public struct Sections: Codable {
    public let sectionsWrapper: SectionContainer?

    enum CodingKeys: String, CodingKey {
        case sectionsWrapper = "sections"
    }
}

public struct SectionContainer: Codable {
    public let sections: [Section]?

    enum CodingKeys: String, CodingKey {
        case sections = "section"
    }
}

public struct Section: Codable {
    public let id: Int?
    public let schoolID: Int?
    public let courseID: Int?
    public let termID: Int?
    public let number: Int?
    public let expression: String
    public let period: String?
    public let staffID: Int?
    public let gradebookType: String?

    enum CodingKeys: String, CodingKey {
        case id
        case schoolID = "school_id"
        case courseID = "course_id"
        case termID = "term_id"
        case number = "section_number"
        case expression
        case period = "external_expression"
        case staffID = "staff_id"
        case gradebookType = "gradebooktype"
    }
}
