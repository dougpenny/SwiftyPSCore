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
    /**
     Retrieve all courses from the given school for the current school year.

     - parameters:
       - schoolID: The school DCID (not the ID or school number)
       - courses: An optional array of Courses
       - error: An optional error
     */
    public func coursesForSchool(_ schoolID: Int, completion: @escaping (_ courses: [Course]?, _ error: Error?) -> Void) {
        let path = "/ws/v1/school/\(schoolID)/course"
        fetchData(path: path, model: Courses.self) { coursesObj, error in
            completion(coursesObj?.data, error)
        }
    }

    /**
     Retrieve the distinct student enrollments for the given sections.

     - Important: PowerQuery Endpoint
     - parameters:
       - sectionID: An array of section DCIDs (not the ID or section number)
       - studentItem: An optional array of PowerQueryStudents
       - error: An optional error
     */
    public func enrollmentsForSections(_ sectionID: [String], completion: @escaping (_ studentItem: [StudentItem]?, _ error: Error?) -> Void) {
        let path = "/ws/schema/query/com.pearson.core.teachers.sectionEnrollments"
        fetchData(path: path, model: ClassRoster.self, method: "POST",
                  params: ["section_dcid": sectionID]) {rosterObj, error in
                    let classRoster = rosterObj?.data
                    completion(classRoster, error)
        }
    }

    /**
     Retrieve the current homeroom roster for the given teacher.

     - Important: PowerQuery Endpoint
     - Note: Setting what is considered a homeroom can be changed in the
     [SwiftyPowerSchool-Plugin](https://github.com/NRCA/SwiftyPowerSchool-Plugin).
     By default, any course with the course number \"HR\" or a course number
     starting with \"Att\" is considered a homeroom.
     - parameters:
       - teacherID: The teacher ID (not the DCID or teacher number)
       - studentItem: An optional array of PowerQueryStudents
       - error: An optional error
     */
    public func homeroomRosterForTeacher(_ teacherID: Int, completion: @escaping (_ studentItem: [StudentItem]?, _ error: Error?) -> Void) {
        let path = "/ws/schema/query/com.nrcaknights.swiftypowerschool.students.homeroom_roster_for_teacher"
        fetchData(path: path, model: ClassRoster.self, method: "POST",
                  params: ["teacher_id": "\(teacherID)"]) {rosterObj, error in
                    let classRoster = rosterObj?.data
                    completion(classRoster, error)
        }
    }

    public func resourceCount(path: String, completion: @escaping (Int?, Error?) -> Void) {
        fetchData(path: path + "/count", model: ResourceCount.self, method: "GET") {resourceCount, error in
            let count = resourceCount?.count
            completion(count, error)
        }
    }

    /**
     Retrieve all schools that are in the current district. Schools are sorted by name.

     - parameters:
       - schools: An optional array of Schools
       - error: An optional error
     */
    public func schools(completion: @escaping (_ schools: [School]?, _ error: Error?) -> Void) {
        let basePath = "/ws/v1/district/school"
        self.fetchData(path: basePath, model: Schools.self) { schoolsObj, error in
            completion(schoolsObj?.data, error)
        }
    }

    public func schoolsCount(completion: @escaping (Int?, Error?) -> Void) {
        let path = "/ws/v1/district/school"
        resourceCount(path: path, completion: completion)
    }

    public func sectionsCountForSchool(_ schoolID: Int, completion: @escaping (Int?, Error?) -> Void) {
        let path = "/ws/v1/school/\(schoolID)/section"
        resourceCount(path: path, completion: completion)
    }

    /**
     Retrieve all sections of the given course number for the current school year.

     - Important: PowerQuery Endpoint
     - parameters:
       - courseNumber: The course number you would like to get current sections for (i.e. CSC101)
       - sectionsInfo: An optional array of PowerQuerySections
       - error: An optional error
     */
    public func sectionsForCourseNumber(_ courseNumber: String, completion: @escaping (_ sectionsInfo: [SectionInfo]?, _ error: Error?) -> Void) {
        let path = "/ws/schema/query/com.nrcaknights.swiftypowerschool.section.for_course_number"
        fetchData(path: path, model: PowerQuerySections.self, method: "POST",
                  params: ["course_number": "\(courseNumber)"]) {sectionsObj, error in
                    let sections = sectionsObj?.data
                    completion(sections, error)
        }
    }

    /**
     Retrieve all sections from the given school for the current school year.
     
     - parameters:
       - schoolID: The school DCID (not the ID or school number)
       - sections: An optional array of Sections
       - error: An optional error
    */
    public func sectionsForSchool(_ schoolID: Int, completion: @escaping (_ sections: [Section]?, _ error: Error?) -> Void) {
        let basePath = "/ws/v1/school/\(schoolID)/section"
        self.fetchData(path: basePath, model: Sections.self) { sectionsObj, error in
            completion(sectionsObj?.data, error)
        }
    }
    
    /**
     Retrieve sections assigned to a given teacher for the current school year.

     - Important: PowerQuery Endpoint
     - parameters:
       - teacherID: The teacher ID (not the DCID or teacher number)
       - sectionsInfo: An optional array of PowerQuerySections
       - error: An optional error
     */
    public func sectionsForTeacher(_ teacherID: Int, completion: @escaping (_ sectionsInfo: [SectionInfo]?, _ error: Error?) -> Void) {
        let path = "/ws/schema/query/com.nrcaknights.swiftypowerschool.section.for_teacher"
        fetchData(path: path, model: PowerQuerySections.self, method: "POST",
                  params: ["teacher_id": "\(teacherID)"]) {sectionsObj, error in
            let sections = sectionsObj?.data
            completion(sections, error)
        }
    }

    /**
     Retrieve all students in the current district.

     - parameters:
     - students: An optional array of Student structs
     - error: An optional error
     */
    public func studentsInDistrict(completion: @escaping (_ students: [Student]?, _ error: Error?) -> Void) {
        let path = "/ws/v1/district/student"
        fetchData(path: path, model: Students.self) {studentsObj, error in
            let students = studentsObj?.data
            completion(students, error)
        }
    }
}
