// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "BoraNavigation",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "BoraNavigation",
            targets: ["BoraNavigation"]
        )
    ],
    dependencies: [
        .package(path: "../BoraEssentials")
    ],
    targets: [
        .target(
            name: "BoraNavigation",
            dependencies: [
                .product(name: "BoraEssentials", package: "BoraEssentials")
            ]
        )
    ]
)
