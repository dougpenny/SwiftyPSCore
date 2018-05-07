//
//    ContactInformation.swift
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

public struct Addresses: Codable {
    public let home: Address?
    public let mailing: Address?
    public let physical: Address?

}

public struct Address: Codable {
    public let city: String?
    public let postalCode: Int?
    public let state: String?
    public let street: String?

    enum CodingKeys: String, CodingKey {
        case city
        case postalCode = "postal_code"
        case state = "state_province"
        case street
    }

}

public struct Phones: Codable {
    private let faxNumber: PhoneNumber?
    private let homePhone: PhoneNumber?
    private let mainNumber: PhoneNumber?

    var fax: String? {
        return faxNumber?.number
    }
    var home: String? {
        return homePhone?.number
    }
    var main: String? {
        return mainNumber?.number
    }

    enum CodingKeys: String, CodingKey {
        case faxNumber = "fax"
        case homePhone = "home_phone"
        case mainNumber = "main"
    }
}

public struct PhoneNumber: Codable {
    public let number: String?
}
