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
     Retrieve all courses from the given school for the current school year.
     - Parameters:
       - schoolID: The school DCID (not the ID or school number)
     - Returns: An optional array of Courses
     */
    public func coursesForSchool(_ schoolID: Int) async throws -> [Course]? {
        let path = "/ws/v1/school/\(schoolID)/course"
        let coursesObj = try await fetchData(path: path, model: Courses.self)
        return coursesObj?.data
    }

    /**
     Retrieve the count of a resource.
     - Parameters:
       - path: The path of the resource
     - Returns: An optional count
     */
    public func resourceCount(path: String) async throws -> Int? {
        let resourceCount = try await fetchData(path: "\(path)/count", model: ResourceCount.self)
        return resourceCount?.count
    }

    /**
     Retrieve all schools in the current district. Schools are sorted by name.
     - Returns: An optional array of Schools
     */
    public func schools() async throws -> [School]? {
        let basePath = "/ws/v1/district/school"
        let schoolsObj = try await fetchData(path: basePath, model: Schools.self)
        return schoolsObj?.data
    }

    /**
     Retrieve the number of schools in the current district.
     - Returns: An optional number of schools
     */
    public func schoolsCount() async throws -> Int? {
        let path = "/ws/v1/district/school"
        return try await resourceCount(path: path)
    }

    /**
     Retrieve the number of sections in a given school.
     - Returns: An optional number of sections
     */
    public func sectionsCountForSchool(_ schoolID: Int) async throws -> Int? {
        let path = "/ws/v1/school/\(schoolID)/section"
        return try await resourceCount(path: path)
    }

    /**
     Retrieve all sections from the given school for the current school year.
     - Parameters:
       - schoolID: The school DCID (not the ID or school number)
     - Returns: An optional array of Sections
    */
    public func sectionsForSchool(_ schoolID: Int) async throws -> [Section]? {
        let basePath = "/ws/v1/school/\(schoolID)/section"
        let sectionsObj = try await fetchData(path: basePath, model: Sections.self)
        return sectionsObj?.data
    }

    /**
     Retrieve all students in the current district.
     - Returns: An optional array of Student structs
     */
    public func studentsInDistrict() async throws -> [Student]? {
        let path = "/ws/v1/district/student"
        let studentsObj = try await fetchData(path: path, model: Students.self)
        return studentsObj?.data
    }
}
