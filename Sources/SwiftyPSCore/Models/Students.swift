//
//    Students.swift
//
//    Copyright (c) 2018 Doug Penny and North Raleigh Christian Academy
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

extension StudentContainer {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let studentsArray = try container.decode([Student].self, forKey: .students)
            self.init(students: studentsArray)
        } catch DecodingError.typeMismatch(_, _) {
            let student = try container.decode(Student.self, forKey: .students)
            self.init(students: [student])
        } catch DecodingError.keyNotFound(_, _) {
            self.init(students: nil)
        }
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

extension Student {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var tempAddresses: Addresses?
        do {
            tempAddresses = try container.decode(Addresses.self, forKey: .addresses)
        } catch DecodingError.keyNotFound(_, _) {
            tempAddresses = nil
        }

        var tempDCID: Int?
        do {
            tempDCID = try container.decode(Int.self, forKey: .dcid)
        } catch DecodingError.keyNotFound(_, _) {
            tempDCID = nil
        }

        var tempDemographics: Demographics?
        do {
            tempDemographics = try container.decode(Demographics.self, forKey: .demographics)
        } catch DecodingError.keyNotFound(_, _) {
            tempDemographics = nil
        }

        var tempName: Name?
        do {
            tempName = try container.decode(Name.self, forKey: .name)
        } catch DecodingError.keyNotFound(_, _) {
            tempName = nil
        }

        var tempPhones: Phones?
        do {
            tempPhones = try container.decode(Phones.self, forKey: .phones)
        } catch DecodingError.keyNotFound(_, _) {
            tempPhones = nil
        }

        var tempStudentNumber: Int?
        do {
            tempStudentNumber = try container.decode(Int.self, forKey: .studentNumber)
        } catch DecodingError.keyNotFound(_, _) {
            tempStudentNumber = nil
        }

        var tempStudentUsername: String?
        do {
            tempStudentUsername = try container.decode(String.self, forKey: .studentUsername)
        } catch DecodingError.typeMismatch(_, _) {
            let tempStudentUsernameInt = try container.decode(Int.self, forKey: .studentUsername)
            tempStudentUsername = String(tempStudentUsernameInt)
        } catch DecodingError.keyNotFound(_, _) {
            tempStudentUsername = nil
        }

        self.init(addresses: tempAddresses, dcid: tempDCID, demographics: tempDemographics,
                  name: tempName, phones: tempPhones, studentNumber: tempStudentNumber,
                  studentUsername: tempStudentUsername)
    }
}
