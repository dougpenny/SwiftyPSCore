//
//    Metadata.swift
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
//
//
//    JSON Response:
//    {
//        "course_max_page_size": 0,
//        "machine_uptime": "string",
//        "mobile_api_version": "string",
//        "plugin_id": 0,
//        "powerschool_uptime": "string",
//        "powerschool_version": "string",
//        "powerteacher_version": "string",
//        "school_max_page_size": 0,
//        "schema_table_query_max_page_size": 0,
//        "section_max_page_size": 0,
//        "section_enrollment_max_page_size": 0,
//        "state_reporting_version": "string",
//        "staff_max_page_size": 0,
//        "state": "string",
//        "student_max_page_size": 0,
//        "term_max_page_size": 0
//    }


public struct Metadata: Codable {
    let courseMaxPageSize: Int?
    let machineUptime: String?
    let mobileAPIVersion: String?
    let pluginID: Int?
    let powerschoolUptime: String?
    let powerschoolVersion: String?
    let powerteacherVersion: String?
    let schoolMaxPageSize: Int?
    let schemeTableQueryMaxPageSize: Int?
    let sectionMaxPageSize: Int?
    let sectionEnrollmentMaxPageSize: Int?
    let stateReportingVersion: String?
    let staffMaxPageSize: Int?
    let state: String?
    let studentMaxPageSize: Int?
    let termMaxPageSize: Int?

    enum CodingKeys: String, CodingKey {
        case courseMaxPageSize = "course_max_page_size"
        case machineUptime = "machine_uptime"
        case mobileAPIVersion = "mobile_api_version"
        case pluginID = "plugin_id"
        case powerschoolUptime = "powerschool_uptime"
        case powerschoolVersion = "powerschool_version"
        case powerteacherVersion = "powerteacher_version"
        case schoolMaxPageSize = "school_max_page_size"
        case schemeTableQueryMaxPageSize = "scheme_table_query_max_page_size"
        case sectionMaxPageSize = "section_max_page_size"
        case sectionEnrollmentMaxPageSize = "section_enrollment_max_page_size"
        case stateReportingVersion = "state_reporting_version"
        case staffMaxPageSize = "staff_max_page_size"
        case state
        case studentMaxPageSize = "student_max_page_size"
        case termMaxPageSize = "term_max_page_size"
    }
}

