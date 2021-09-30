// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "Blaze",
  platforms: [
    .macOS(.v10_13)
  ],
  products: [
    .executable(name: "blaze", targets: ["Blaze"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.1"),
    .package(name: "Auth", url: "https://github.com/googleapis/google-auth-library-swift", from: "0.5.3")
  ],
  targets: [
    .target(
      name: "Blaze",
      dependencies: [
        "BlazeCore"
      ]
    ),
    .target(
      name: "BlazeCore",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "OAuth2",  package: "Auth")
      ]
    ),
    .testTarget(
      name: "BlazeTests",
      dependencies: [
        "BlazeCore"
      ]
    ),
  ]
)
