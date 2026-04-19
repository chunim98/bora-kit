// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "BoraEssentials",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "BoraEssentials",
            targets: ["BoraEssentials"]
        )
    ],
    targets: [
        .target(name: "BoraEssentials")
    ]
)
