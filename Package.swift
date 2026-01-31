// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "AppStoreReviewManager",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .macCatalyst(.v17),
        .tvOS(.v17),
        .visionOS(.v1),
        .watchOS(.v10)
    ],
    products: [
        .library(name: "AppStoreReviewManager", targets: ["AppStoreReviewManager"])
    ],
    dependencies: [
        .package(url: "https://github.com/markbattistella/DefaultsKit", from: "26.0.0"),
    ],
    targets: [
        .target(
            name: "AppStoreReviewManager",
            dependencies: ["DefaultsKit"],
        )
    ]
)
