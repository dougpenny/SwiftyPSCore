//
//    Schools.swift
//
//    Copyright (c) 2018 Cooper Edmunds,  Doug Penny, and North Raleigh Christian Academy
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

public struct Schools: Pagable {
    private var schoolsWrapper: SchoolContainer?
    public var data: [School]? {
        get { return schoolsWrapper?.schools }
        set { schoolsWrapper?.schools = newValue }
    }
    enum CodingKeys: String, CodingKey {
        case schoolsWrapper = "schools"
    }
}

private struct SchoolContainer: Codable {
    var schools: [School]?

    enum CodingKeys: String, CodingKey {
        case schools = "school"
    }
}

public struct School: Codable {
    let id: Int?
    let schoolNumber: Int?
    let name: String?
    let stateProvinceID: String?
    let lowestGrade: Int?
    let highestGrade: Int?
    let alternateSchoolNumber: Int?
    let addresses: Addresses?
    let phones: Phones?
    let principal: Principal?
    let assistantPrincipal: Principal?

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
        let email: String?
        let name: Name?
    }
}

extension SchoolContainer {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let schoolsArray = try container.decode([School].self, forKey: .schools)
            self.init(schools: schoolsArray)
        } catch DecodingError.typeMismatch( _, _) {
            let school = try container.decode(School.self, forKey: .schools)
            self.init(schools: [school])
        }
    }
}
