// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "GildraEvents",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        .library(name: "GildraEvents", targets: ["GildraEvents"])
    ],
    targets: [
        .target(
            name: "GildraEvents",
            path: "swift/Sources/GildraEvents"
        )
    ]
)
