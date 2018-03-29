//
//    SwiftyPowerSchool-Extension.swift
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

import Foundation

extension SwiftyPowerSchool {
    public func getSchools(completion: @escaping ([School]?, Error?) -> Void) {
        let path = "/ws/v1/district/school"
        fetchData(path: path, model: Schools.self, method: "GET") {schoolsObj, error in
            let schools = schoolsObj?.data
            completion(schools, error)
        }
    }

    public func getCoursesFromSchool(_ schoolID: Int, completion: @escaping ([Course]?, Error?) -> Void) {
        let path = "/ws/v1/school/\(schoolID)/course"
        fetchData(path: path, model: Courses.self, method: "GET") {coursesObj, error in
            let courses = coursesObj?.data
            completion(courses, error)
        }
    }

    public func getSectionsFromSchool(_ schoolID: Int, completion: @escaping ([Section]?, Error?) -> Void) {
        let path = "/ws/v1/school/\(schoolID)/section"
        fetchData(path: path, model: Sections.self, method: "GET") {sectionsObj, error in
            let sections = sectionsObj?.data
            completion(sections, error)
        }
    }

    public func getSchoolsCount(completion: @escaping (Int?, Error?) -> Void) {
        let path = "/ws/v1/district/school/count"
        fetchData(path: path, model: ResourceCount.self, method: "GET") {resourceCount, error in
            let count = resourceCount?.count
            completion(count, error)
        }
    }
}
