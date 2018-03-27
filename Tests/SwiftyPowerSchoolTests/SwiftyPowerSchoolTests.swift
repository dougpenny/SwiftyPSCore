import XCTest
@testable import SwiftyPowerSchool

class SwiftyPowerSchoolTests: XCTestCase {
    func testSchoolModel() {
        let jsonSchoolsExample =
"""
{"schools":{"@expansions":"school_boundary, full_time_equivalencies, school_fees_setup","@extensions":"schoolscorefields,c_school_registrar,s_sch_crdc_x,schoolssuccessnetfields,s_sch_ncea_x","school":[{"id":2,"name":"George Washington High School","school_number":3,"low_grade":9,"high_grade":12,"alternate_school_number":0,"addresses":{"physical":{"street":"123 Cherry Tree Ave","city":"Big City","state_province":"VT","postal_code":12345}},"phones":{"main":{"number":"444-555-1234"}},"principal":{"name":{"first_name":"Thomas","last_name":"Jefferson"},"email":"tj@gwhs.com"},"assistant_principal":{"name":{"first_name":"John","last_name":"Adams"},"email":"ja@gwhs.com"}}]}}
"""
        if let data = jsonSchoolsExample.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                let allSchools = try decoder.decode(Schools.self, from: data)
                if let schools = allSchools.data {
                    XCTAssertEqual(schools[0].schoolNumber, 3)
                    if let city = schools[0].addresses?.physical?.city {
                        XCTAssertEqual(city, "Big City")
                    } else { XCTFail() }
                    if let firstName = schools[0].principal?.name?.firstName {
                        XCTAssertEqual(firstName, "Thomas")
                    } else { XCTFail() }
                    if let email = schools[0].principal?.email {
                        XCTAssertEqual(email, "tj@gwhs.com")
                    } else { XCTFail() }
                } else { XCTFail() }
            }
            catch let parseError {
                XCTFail(parseError.localizedDescription)
            }
        }
    }

    func testCourseModel() {
        let jsonCoursesExample =
"""
{"courses":{"@extensions":"s_crs_crdc_x","course":[{"id":2135,"course_number":"CSC101","course_name":"Computer Science I"}]}}
"""
        if let data = jsonCoursesExample.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                let allCourses = try decoder.decode(Courses.self, from: data)
                if let courses = allCourses.data {
                    XCTAssertEqual(courses.count, 1)
                    XCTAssertEqual(courses[0].id, 2135)
                    XCTAssertEqual(courses[0].number, "CSC101")
                } else { XCTFail() }
            }
            catch let parseError {
                XCTFail(parseError.localizedDescription)
            }
        }
    }
    
    func testSectionModel() {
        let jsonSectionsExample =
"""
{"sections":{"@expansions":"term","@extensions":"s_sec_crdc_x,s_sec_edfi_x","section":[{"id":1500,"school_id":3,"course_id":1391,"term_id":1989,"section_number":5,"expression":"8(A-E)","external_expression":"6(M-F)","staff_id":3955,"gradebooktype":"PTG"},{"id":15919,"school_id":3,"course_id":1391,"term_id":1989,"section_number":6,"expression":"9(A-E)","external_expression":"7(M-F)","staff_id":3955,"gradebooktype":"PTG"}]}}
"""
        if let data = jsonSectionsExample.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                let allSections = try decoder.decode(Sections.self, from: data)
                if let sections = allSections.data {
                    XCTAssertEqual(sections.count, 2)
                    XCTAssertEqual(sections[0].id, 1500)
                    XCTAssertEqual(sections[0].expression, "8(A-E)")
                    XCTAssertEqual(sections[1].staffID, 3955)
                    XCTAssertEqual(sections[1].gradebookType, "PTG")
                } else { XCTFail() }
            }
            catch let parseError {
                XCTFail(parseError.localizedDescription)
            }
        }
    }
    func testResourceCountModel() {
        let jsonResourceCountExample =
"""
{"resource":{"count":20}}
"""
        if let data = jsonResourceCountExample.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                let resourceCount = try decoder.decode(ResourceCount.self, from: data)
                
                if let count = resourceCount.count {
                    XCTAssertEqual(count, 20)
                } else { XCTFail() }
            }
            catch let parseError {
                XCTFail(parseError.localizedDescription)
            }
        }
    }
   

    static var allTests = [
        ("testSchoolModel", testSchoolModel),
        ("testCourseModel", testCourseModel),
        ("testSectionModel", testSectionModel),
        ("testResourceCountModel", testResourceCountModel),
    ]
}
