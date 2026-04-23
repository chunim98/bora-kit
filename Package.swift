// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "BoraKit",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "BoraEssentials",
            targets: ["BoraEssentials"]
        ),
        .library(
            name: "BoraDesign",
            targets: ["BoraDesign"]
        ),
        .library(
            name: "BoraNavigation",
            targets: ["BoraNavigation"]
        ),
        .library(
            name: "BoraCombine",
            targets: ["BoraCombine"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/CombineCommunity/CombineCocoa.git", from: "0.4.1"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
    ],
    targets: [
        .target(
            name: "BoraEssentials",
            dependencies: [
                .product(name: "CombineCocoa", package: "CombineCocoa"),
            ],
            path: "BoraEssentials/Sources"
        ),
        .target(
            name: "BoraDesign",
            dependencies: ["BoraEssentials"],
            path: "BoraDesign/Sources"
        ),
        .target(
            name: "BoraNavigation",
            path: "BoraNavigation/Sources"
        ),
        .target(
            name: "BoraCombine",
            dependencies: [
                "BoraNavigation",
                .product(name: "CombineCocoa", package: "CombineCocoa")
            ],
            path: "BoraCombine/Sources"
        )
    ]
)
