// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SwiftyPSCore",
    products: [
        .library(name: "SwiftyPSCore", targets: ["SwiftyPSCore"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "SwiftyPSCore", dependencies: []),
        .testTarget(name: "SwiftyPSCoreTests", dependencies: ["SwiftyPSCore"])
    ]
)
