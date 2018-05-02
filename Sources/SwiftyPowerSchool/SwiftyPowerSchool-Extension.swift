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

//    swiftlint:disable line_length

import Foundation

extension SwiftyPowerSchool {
    public func schools(completion: @escaping ([School]?, Error?) -> Void) {
        let path = "/ws/v1/district/school"
        fetchData(path: path, model: Schools.self, method: "GET") {schoolsObj, error in
            let schools = schoolsObj?.data
            completion(schools, error)
        }
    }

    public func coursesForSchool(_ schoolID: Int, completion: @escaping ([Course]?, Error?) -> Void) {
        let path = "/ws/v1/school/\(schoolID)/course"
        fetchData(path: path, model: Courses.self, method: "GET") {coursesObj, error in
            let courses = coursesObj?.data
            completion(courses, error)
        }
    }

    public func enrollmentsForSections(_ sectionID: [String], completion: @escaping ([StudentItem]?, Error?) -> Void) {
        let path = "/ws/schema/query/com.pearson.core.teachers.sectionEnrollments"
        fetchData(path: path, model: ClassRoster.self, method: "POST",
                  params: ["section_dcid": sectionID]) {rosterObj, error in
                    let classRoster = rosterObj?.data
                    completion(classRoster, error)
        }
    }

    public func homeroomRosterForTeacher(_ teacherID: Int, completion: @escaping ([StudentItem]?, Error?) -> Void) {
        let path = "/ws/schema/query/com.nrcaknights.swiftypowerschool.students.homeroom_roster_for_teacher"
        fetchData(path: path, model: ClassRoster.self, method: "POST",
                  params: ["teacher_id": "\(teacherID)"]) {rosterObj, error in
                    let classRoster = rosterObj?.data
                    completion(classRoster, error)
        }
    }

    /**
     Fetch all sections from the given school for the current school year.
     
     - parameters:
       - schoolID: The school DCID (not the ID or school number)
       - sections: An optional array of sections
       - error: An optional error
    */
    public func sectionsForSchool(_ schoolID: Int, completion: @escaping (_ sections: [Section]?, _ error: Error?) -> Void) {
        let path = "/ws/v1/school/\(schoolID)/section"
        fetchData(path: path, model: Sections.self, method: "GET") {sectionsObj, error in
            let sections = sectionsObj?.data
            completion(sections, error)
        }
    }

    public func sectionsForTeacher(_ teacherID: Int, completion: @escaping ([SectionInfo]?, Error?) -> Void) {
        let path = "/ws/schema/query/com.nrcaknights.swiftypowerschool.section.for_teacher"
        fetchData(path: path, model: PowerQuerySections.self, method: "POST",
                  params: ["teacher_id": "\(teacherID)"]) {sectionsObj, error in
            let sections = sectionsObj?.data
            completion(sections, error)
        }
    }

    public func schoolsCount(completion: @escaping (Int?, Error?) -> Void) {
        let path = "/ws/v1/district/school/count"
        fetchData(path: path, model: ResourceCount.self, method: "GET") {resourceCount, error in
            let count = resourceCount?.count
            completion(count, error)
        }
    }
}
