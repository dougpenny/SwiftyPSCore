
import XCTest
@testable import SwiftyPowerSchool

class EndpointTests: XCTestCase {
    static var allTests = [
        ("testGetSchoolsCount", testGetSchoolsCount),
        ]

    var client: SwiftyPowerSchool!
    var params: TestingParameters!

    override func setUp() {
        super.setUp()
        print("EndpointTests setup called--")
        if let paramFilePath = Bundle(for: type(of: self)).path(forResource: "testing_parameters", ofType: "json") {
            let decoder = JSONDecoder()
            do {
                let paramData = try Data(contentsOf: URL(fileURLWithPath: paramFilePath))
                self.params = try decoder.decode(TestingParameters.self, from: paramData)
                self.client = SwiftyPowerSchool(self.params.baseURL,
                                                clientID: self.params.clientID,
                                                clientSecret: self.params.clientSecret)
            }
            catch let parseError {
                XCTFail("Failed to decode JSON parameters file.\nError: \(parseError.localizedDescription)")
            }
        }
        else {
            print("File not found!")
        }
    }

    func testGetSchoolsCount() {
        let getSchoolsCountExpectation = self.expectation(description: "get schools count")

        client.getSchoolsCount() { schoolsCount, error in
            if let schoolsCount = schoolsCount {
                print(schoolsCount)
                XCTAssertEqual(self.params.schoolsCount, schoolsCount)
                getSchoolsCountExpectation.fulfill()
            }
            else {
                XCTFail("schoolsCount is nil")
            }
        }

        self.waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
}
