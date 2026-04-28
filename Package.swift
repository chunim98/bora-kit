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
            name: "CombineSupport",
            targets: ["CombineSupport"]
        )
    ],
    dependencies: [
        .package(path: "Navigation"),
        .package(url: "https://github.com/CombineCommunity/CombineCocoa.git", from: "0.4.1"),
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
            name: "CombineSupport",
            dependencies: [
                .product(name: "Navigation", package: "Navigation"),
                .product(name: "CombineCocoa", package: "CombineCocoa")
            ],
            path: "CombineSupport/Sources"
        )
    ]
)
