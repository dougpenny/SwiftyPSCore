![SwiftyPowerSchool](Images/swiftypowerschool.png)

[![Swift](https://img.shields.io/badge/Swift-4.0-orange.svg)](https://swift.org)
[![MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)


SwiftyPowerSchool is a pure Swift PowerSchool API client. Our goal is to simplify the process of communicating with the [PowerSchool Student Information System](https://www.powerschool.com/solutions/student-information-system-sis/) API by handling authentication and decoding, allowing you to focus on using the data, not retrieving it.

_SwiftyPowerSchool is not endorsed, sponsored, or affilitated with PowerSchool in any way. Swift and the Swift logo are trademarks of Apple Inc._

***

## Table of Contents
* [Installation](#installation)
  * [Swift Pacakge Manager](#swift-package-manager)
  * [CocoaPods](#cocoapods)
* [Usage](#usage)
  * [Examples](#schools)
  * [PowerQueries](#powerqueries)
* [Contributing](#contributing)
  * [Endpoint Testing](#endpoint-testing)
* [License](#license)

---

## Installation
Before using _SwiftyPowerSchool_ in your application, you will first need to create and install a Plugin XML file for your PowerSchool server. Information about creating the plugin file can be found on the[PowerSchool Developer Support](https://support.powerschool.com/developer/#/page/plugin-xml) site. We have created an example plugin ([SwiftyPowerSchool-Plugin](https://github.com/NRCA/SwiftyPowerSchool-Plugin)) that you can use as is, or modify as you see fit. Once you have installed the plugin, you will be provided a client ID and client secret that you will use for authenticating with the PowerSchool server.

### Swift Package Manager
To include SwiftyPowerSchool in a [Swift Package Manager](https://swift.org/package-manager/) package, add it to the `dependencies` attribute defined in your `Package.swift` file. For example:
```swift
dependencies: [
  .package(url: "https://github.com/nrca/swiftypowerschool.git", from: "1.0.0-beta1")
]
```

### CocoaPods
CocoaPods support will be coming soon!

---

## Usage
You can hard code your base URL, client ID and client secret into your code, but a better option might be to set environment variables for these.

First, fetch the environment variables and instantiate a client:
```swift
if let baseURL = ProcessInfo.processInfo.environment["BASE_URL"],
    let clientID = ProcessInfo.processInfo.environment["CLIENT_ID"],
    let clientSecret = ProcessInfo.processInfo.environment["CLIENT_SECRET"] {

    let client = SwiftyPowerSchool(baseURL,
                                   clientID: clientID,
                                   clientSecret: clientSecret)
}
```

Now you can use your client to retrieve many different resources. Below are a few examples with more coming soon.

### Schools
```swift
client.getSchools() { schools, error in
  if let schools = schools {
    print("Array of schools: \(schools)")
  }
  else {
    print(error?.localizedDescription ?? "Generic error")
  }
}
```

### Courses
```swift
client.getCoursesFromSchool(1) { courses, error in
  if let courses = courses {
    print("Array of courses: \(courses)")
  }
  else {
    print(error?.localizedDescription ?? "Generic error")
  }
}
```

### Sections
```swift
client.getSectionsFromSchool(3) { sections, error in
  if let sections = sections {
    print("Array of sections: \(sections)")
  }
  else {
    print(error?.localizedDescription ?? "Generic error")
  }
}
```

### Number of schools
```swift
client.getSchoolsCount() { schoolsCount, error in
  if let schoolsCount = schoolsCount {
    print("Number of schools: \(schoolsCount)")
  }
  else {
    print(error?.localizedDescription ?? "Generic error 2")
  }
}
```

### PowerQueries
PowerQueries are a feature that allows you create custom API endpoints. You define the data to be returned and write a SQL select statement to fetch the data. PowerQueries are created through the PowerSchool plugin interface. You can see an example of one in our sample PowerSchool plugin, [SwiftyPowerSchool-Plugin](https://github.com/NRCA/SwiftyPowerSchool-Plugin). You can learn more about PowerQueries on the [PowerSchool Developer Support](https://support.powerschool.com/developer/#/page/powerqueries) site.

## Contributing
If you have a feature or idea you would like to see added to SwiftyPowerSchool, please [create an issue](https://github.com/NRCA/SwiftyPowerSchool/issues/new) explaining your idea with as much detail as possible.

If you come across a bug, please [create an issue](https://github.com/NRCA/SwiftyPowerSchool/issues/new) explaining the bug with as much detail as possible.

The PowerSchool API provides access to a lot of information and, unfortunately, we don't have time to research and implement every endpoint. We've tried to make it as easy as possible for you to extend the library and contribute your changes. The basics for adding a new endpoint are:

1. Generate an Xcode project file using the `swift package generate-xcodeproj` command.
2. Create a new model based on the JSON response expected through the PowerSchool API. You can find this information on the [PowerSchool Developer Support](https://support.powerschool.com/developer) site.
3. Add a test to the `ModelTests.swift` file with an example of the JSON response to ensure the model is decoded properly.
4. Add a new function to the `SwiftyPowerSchool-Extension.swift` file for your endpoint. You can simply copy one that is already there and change the `path` and the model type to match the expected response.

Please feel free to open a pull request with any additional endpoints you create. We would love to have as many of the endpoints covered as possible.

We strive to keep the code as clean as possible and follow standard Swift coding conventions, mainly the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) and the [raywenderlich.com Swift Style Guide](https://github.com/raywenderlich/swift-style-guide). Please run any code changes  through [SwiftLint](https://github.com/realm/SwiftLint) before submitting a pull request.

### Endpoint Testing
We provide the files needed to test your endpoints against a testing PowerSchool server, but you'll have to do a little setup on your end. Unfortunately, we are unable to get these to work on the command line at this time, but hopefully we'll be able to figure that out soon.

1. Duplicate the file `testing_parameters.sample.json` and name it `testing_parameters.json`. This is a JSON file to hold the values you will be testing against and is decoded when the `EndpointTests` file is run.
2. Add the `testing_parameters.json` file to your Xcode project, including it in the `SwiftyPowerSchoolTests` target.
3. Modify the `TestingParameters.swift` model to included any additional parameters you would like to use in your tests.
4. Add any new testing functions to the `EndpointTests.swift` file.


---

## License
SwiftyPowerSchool is released under an MIT license. See [LICENSE](https://opensource.org/licenses/MIT) for more information.
