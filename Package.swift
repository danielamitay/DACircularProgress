// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DACircularProgress",
    platforms: [.iOS(.v9)],
    products: [
        .library(name: "DACircularProgress", targets: ["DACircularProgress"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DACircularProgress",
            dependencies: [],
            path: "DACircularProgress",
            publicHeadersPath: ".")
    ]
)
