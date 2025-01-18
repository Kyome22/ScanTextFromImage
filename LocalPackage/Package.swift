// swift-tools-version: 6.0

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),
]

let package = Package(
    name: "LocalPackage",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(
            name: "DataLayer",
            targets: ["DataLayer"]
        ),
        .library(
            name: "Domain",
            targets: ["Domain"]
        ),
        .library(
            name: "Presentation",
            targets: ["Presentation"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", exact: "1.6.2"),
        .package(url: "https://github.com/Kyome22/WindowSceneKit.git", exact: "1.1.0"),
        .package(url: "https://github.com/sparkle-project/Sparkle.git", exact: "2.6.4"),
    ],
    targets: [
        .target(
            name: "DataLayer",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Sparkle", package: "Sparkle"),
                .product(name: "WindowSceneKit", package: "WindowSceneKit"),
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "Domain",
            dependencies: [
                "DataLayer",
                .product(name: "Logging", package: "swift-log"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: [
                "DataLayer",
                "Domain",
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "Presentation",
            dependencies: [
                "DataLayer",
                "Domain",
                .product(name: "WindowSceneKit", package: "WindowSceneKit"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
