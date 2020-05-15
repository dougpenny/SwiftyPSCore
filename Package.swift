// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SwiftyPowerSchoolCore",
    products: [
        .library(name: "SwiftyPowerSchoolCore", targets: ["SwiftyPowerSchoolCore"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "SwiftyPowerSchoolCore", dependencies: []),
        .testTarget(name: "SwiftyPowerSchoolTests", dependencies: ["SwiftyPowerSchoolCore"])
    ]
)
