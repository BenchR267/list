// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "list",
    products: [
        .executable(
            name: "example",
            targets: ["example"]),
        .library(
            name: "list",
            targets: ["list"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "example",
            dependencies: ["list"]),
        .target(
            name: "list",
            dependencies: []),
        .testTarget(
            name: "listTests",
            dependencies: ["list"]),
    ]
)
