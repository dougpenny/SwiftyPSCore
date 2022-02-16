![SwiftyPSCore](Images/swiftypowerschool.png)

[![MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdougonecent%2FSwiftyPSCore%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/dougonecent/SwiftyPSCore)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdougonecent%2FSwiftyPSCore%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/dougonecent/SwiftyPSCore)


SwiftyPSCore is a pure Swift PowerSchool API client. The goal is to simplify the process of communicating with the [PowerSchool Student Information System](https://www.powerschool.com/solutions/student-information-system-sis/) API by handling authentication and decoding, allowing you to focus on using the data, not retrieving it.

_SwiftyPSCore is not endorsed, sponsored, or affilitated with PowerSchool in any way. Swift and the Swift logo are trademarks of Apple Inc._

***

## Table of Contents
* [Installation](#installation)
  * [Swift Pacakge Manager](#swift-package-manager)
* [Usage](#usage)
  * [Examples](#examples)
* [PowerQueries](#powerqueries)
* [Contributing](#contributing)
  * [Endpoint Testing](#endpoint-testing)
* [License](#license)

---

## Installation
Before using _SwiftyPSCore_ in your application, you will first need to create and install a Plugin XML file for your PowerSchool server. Information about creating the plugin file can be found on the [PowerSchool Developer Support](https://support.powerschool.com/developer/#/page/plugin-xml) site. We have created an example plugin ([SwiftyPSCorePlugin](https://github.com/dougonecent/SwiftyPSCorePlugin)) that you can use as is, or modify as you see fit. Once you have installed the plugin, you will be provided a client ID and client secret that you will use for authenticating with the PowerSchool server.

### Swift Package Manager
To include SwiftyPSCore in a [Swift Package Manager](https://swift.org/package-manager/) package, add it to the `dependencies` attribute defined in your `Package.swift` file. For example:
```swift
dependencies: [
  .package(url: "https://github.com/dougonecent/SwiftyPSCore.git", from: "1.0.0-beta6")
]
```

---

## Usage
Set environment variables for your base URL, client ID, and client secret. Then, in your code, fetch the environment variables and instantiate a client:
```swift
if let baseURL = ProcessInfo.processInfo.environment["BASE_URL"],
    let clientID = ProcessInfo.processInfo.environment["CLIENT_ID"],
    let clientSecret = ProcessInfo.processInfo.environment["CLIENT_SECRET"] {
        let client = SwiftyPSCore(baseURL, clientID: clientID, clientSecret: clientSecret)
}
```

Now you can use your client to retrieve many different resources. Below are a few examples:
<a id="examples"></a>
### Number of sections in a school
```swift
if let sections = try await client.sectionsForSchool(schoolID) {
    // sections: [Section]
} else {
    // no sections found
}
```

### All students in district
```swift
if let students = try await client.studentsInDistrict() {
    // students: [Student]
} else {
    // no students found
}
```

## PowerQueries
PowerQueries are a feature that allows for the creation of custom API endpoints. SwiftyPSCore only includes core endpoints and PowerQueries provided directly by PowerSchool. To add additional core PowerQueries to SwiftyPSCore, you will need to modify the plugin file ([SwiftyPSCorePlugin](https://github.com/NRCA/SwiftyPSCorePlugin)) with the proper <[access-request](https://support.powerschool.com/developer/#/page/access-request)> elements.

If you are interested in creating your own, custom PowerQueries, see our companion package, SwiftyPSCustomQueries, and the corresponding plugin, SwiftyPSCustomQueriesPlugin.

Using a PowerQuery endpoint works just like any other endpoint:
### Enrollments for sections
```swift
if let enrollments = try await client.enrollmentsForSections([testSection.sectionDCID]) {
    // enrollments: [StudentItem]
} else {
    // error: Error
}
```

## Contributing
If you have a feature or idea you would like to see added to SwiftyPSCore, please [create an issue](https://github.com/NRCA/SwiftyPSCore/issues/new) explaining your idea with as much detail as possible.

If you come across a bug, please [create an issue](https://github.com/NRCA/SwiftyPSCore/issues/new) explaining the bug with as much detail as possible.

The PowerSchool API provides access to a lot of information and, unfortunately, we don't have time to research and implement every endpoint. We've tried to make it as easy as possible for you to extend the library and contribute your changes. The basics for adding a new endpoint are:

1. Fork this repository and clone it to your development machine.
2. Create a new model based on the JSON response expected through the PowerSchool API. You can find this information on the [PowerSchool Developer Support](https://support.powerschool.com/developer) site.
3. Add a test to the `ModelTests.swift` file with an example of the JSON response to ensure the model is decoded properly.
4. Add a new function to the `SwiftyPSCoreEndpoints.swift` file for your endpoint. You can simply copy one that is already there and change the `path` and the model type to match the expected response.

Please feel free to open a pull request with any additional endpoints you create. We would love to have as many of the endpoints covered as possible.

We strive to keep the code as clean as possible and follow standard Swift coding conventions, mainly the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) and the [raywenderlich.com Swift Style Guide](https://github.com/raywenderlich/swift-style-guide). Please run any code changes through [SwiftLint](https://github.com/realm/SwiftLint) before submitting a pull request.

### Endpoint Testing
We provide the files needed to test your endpoints against a sandbox PowerSchool server, but you'll have to do a little setup on your end.

1. Duplicate the file `testing_parameters.sample.json` and name it `testing_parameters.json`. This is a JSON file to hold the values you will be testing against and is decoded when the `EndpointTests` file is run.
2. Add the `testing_parameters.json` file to your Xcode project, including it in the `SwiftyPSCoreTests` target.
3. Modify the `TestingParameters.swift` model to included any additional parameters you would like to use in your tests.
4. Add any new testing functions to the `EndpointTests.swift` file.


---

## License
SwiftyPSCore is released under an MIT license. See [LICENSE](https://opensource.org/licenses/MIT) for more information.
