//
//    Person.swift
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

public struct Name: Codable {
    public let firstName: String?
    public let middleName: String?
    public let lastName: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case middleName = "middle_name"
        case lastName = "last_name"
    }
}

public struct Demographics: Codable {
    let birthDate: String?
    let districtEntryDate: String?
    let gender: String?
    let projGradYear: Int?

    enum CodingKeys: String, CodingKey {
        case birthDate = "birth_date"
        case districtEntryDate = "district_entry_date"
        case gender
        case projGradYear = "projected_graduation_year"
    }
}
