// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Yandex-iOS-ADS-Godot",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Yandex-iOS-ADS-Godot",
            type: .dynamic,
            targets: ["Yandex-iOS-ADS-Godot"]),
    ],
    dependencies: [
        .package(url: "https://github.com/migueldeicaza/SwiftGodot", revision: "440a0b4"),
        .package(url: "https://github.com/yandexmobile/yandex-ads-sdk-ios", exact: "7.8.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Yandex-iOS-ADS-Godot",
            dependencies: [
                "SwiftGodot",
                .product(name: "YandexMobileAds", package: "yandex-ads-sdk-ios")
            ],
            swiftSettings: [.unsafeFlags(["-suppress-warnings"])],
            linkerSettings: [
                .unsafeFlags(["-ObjC"]),
//                .linkedFramework("Foundation")
            ]
        ),
    ]
)
