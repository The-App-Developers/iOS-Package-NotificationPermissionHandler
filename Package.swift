// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NotificationPermissionHandler",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "NotificationPermissionHandler",
            targets: ["NotificationPermissionHandler"]),
    ],
    targets: [
        .target(
            name: "NotificationPermissionHandler",
            dependencies: []),
    ]
)
