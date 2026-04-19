// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "BoraDesign",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "BoraDesign",
            targets: ["BoraDesign"]
        )
    ],
    dependencies: [
        .package(path: "../BoraEssentials")
    ],
    targets: [
        .target(
            name: "BoraDesign",
            dependencies: [
                .product(name: "BoraEssentials", package: "BoraEssentials")
            ]
        )
    ]
)
