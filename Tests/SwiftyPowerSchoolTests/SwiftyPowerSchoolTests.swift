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
                if let schoolsWrapper = allSchools.schoolsWrapper {
                    if let schools = schoolsWrapper.schools {
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

    static var allTests = [
        ("testSchoolModel", testSchoolModel),
        ("testCourseModel", testCourseModel),
    ]
}
