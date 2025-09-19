// swift-tools-version:5.7
//
//  Package.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "DNSThemeObjects",
    platforms: [
        .iOS(.v16),
        .tvOS(.v16),
        .macCatalyst(.v16),
        .macOS(.v13),
        .watchOS(.v9),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DNSThemeObjects",
            type: .static,
            targets: ["DNSThemeObjects"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/optonaut/ActiveLabel.swift", .upToNextMajor(from: "1.1.5")),
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", .upToNextMajor(from: "4.3.0")),
        .package(url: "https://github.com/DoubleNodeOpen/AnimatedField.git", .upToNextMajor(from: "2.5.69")),
        .package(url: "https://github.com/DoubleNode/DNSCore.git", .upToNextMajor(from: "1.12.0")),
        .package(url: "https://github.com/DoubleNode/DNSThemeTypes.git", .upToNextMajor(from: "1.12.0")),
//        .package(path: "../../Open Source/AnimatedField"),
//        .package(path: "../DNSCore"),
//        .package(path: "../DNSThemeTypes"),
        .package(url: "https://github.com/Juanpe/SkeletonView.git", .upToNextMajor(from: "1.30.4")),
        .package(url: "https://github.com/SwipeCellKit/SwipeCellKit", .upToNextMajor(from: "2.7.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DNSThemeObjects",
            dependencies: [
                "AlamofireImage", "AnimatedField", "DNSCore", "DNSThemeTypes", "SkeletonView", "SwipeCellKit",
                .product(name: "ActiveLabel", package: "ActiveLabel.swift"),
            ],
            resources: [.process("Resources/DNSUIAnimatedField.xib")]
        ),
        .testTarget(
            name: "DNSThemeObjectsTests",
            dependencies: ["DNSThemeObjects"]),
    ],
    swiftLanguageVersions: [.v5]
)
