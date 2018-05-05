//
//    Schools.swift
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

public struct Schools: Pagable {
    private let schoolsWrapper: SchoolsContainer?
    public var data: [School]? {
        get { return schoolsWrapper?.schools }
        set { data = newValue }
    }
    enum CodingKeys: String, CodingKey {
        case schoolsWrapper = "schools"
    }
}

private struct SchoolsContainer: Codable {
    public let schools: [School]?

    enum CodingKeys: String, CodingKey {
        case schools = "school"
    }
}

public struct School: Codable {
    public let id: Int?
    public let schoolNumber: Int?
    public let name: String?
    public let stateProvinceID: String?
    public let lowestGrade: Int?
    public let highestGrade: Int?
    public let alternateSchoolNumber: Int?
    public let addresses: Addresses?
    public let phones: Phones?
    public let principal: Principal?
    public let assistantPrincipal: Principal?

    enum CodingKeys: String, CodingKey {
        case id
        case schoolNumber = "school_number"
        case name
        case stateProvinceID = "state_province_id"
        case lowestGrade = "low_grade"
        case highestGrade = "high_grade"
        case alternateSchoolNumber = "alternate_school_number"
        case addresses
        case phones
        case principal
        case assistantPrincipal = "assistant_principal"
    }

    public struct Principal: Codable {
        public let email: String?
        public let name: Name?
    }
}
