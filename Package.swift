// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SwiftyPowerSchool",
    products: [
        .library(name: "SwiftyPowerSchool", targets: ["SwiftyPowerSchool"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "SwiftyPowerSchool", dependencies: []),
        .testTarget(name: "SwiftyPowerSchoolTests", dependencies: ["SwiftyPowerSchool"])
    ]
)
