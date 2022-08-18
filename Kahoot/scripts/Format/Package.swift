// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BuildTools",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/nicklockwood/SwiftFormat", .exact("0.48.1")),
    ],
    targets: [
    	.target(name: "BuildTools", path: "")
    ]
)
