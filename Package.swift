// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let name = "Networking"
let package = Package(
    name: name,
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [.library(name: name, targets: [name])],
    dependencies: [
        .package(
            url: "https://github.com/CombineCommunity/CombineExt.git",
            .upToNextMajor(from: "1.8.0")
        )
    ],
    targets: [.target(name: name, dependencies: ["CombineExt"], resources: [.process("Resources")])]
)
