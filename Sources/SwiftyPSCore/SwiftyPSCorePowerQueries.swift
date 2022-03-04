//
//    SwiftyPSCoreEndpoints.swift
//
//    Copyright (c) 2018 Cooper Edmunds, Doug Penny, and North Raleigh Christian Academy
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

import Foundation

extension SwiftyPSCore {
    /**
     Retrieve the distinct student enrollments for the given sections.
     - Important: PowerQuery Endpoint
     - Parameters:
       - sectionID: An array of section DCIDs (not the ID or section number)
     - Returns: An optional array of PowerQueryStudents
     */
    public func enrollmentsForSections(_ sectionID: [String]) async throws -> [StudentItem]? {
        let path = "/ws/schema/query/com.pearson.core.teachers.sectionEnrollments"
        let rosterObj = try await fetchData(path: path, model: ClassRoster.self, method: "POST", params: ["section_dcid": sectionID])
        return rosterObj?.data
    }
}
