// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SwiftyPSCore",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "SwiftyPSCore",
            targets: ["SwiftyPSCore"]
        )
    ],
    targets: [
        .target(
            name: "SwiftyPSCore"
        ),
        .testTarget(
            name: "SwiftyPSCoreTests",
            dependencies: ["SwiftyPSCore"],
            resources: [.process("Resources")]
        )
    ]
)
