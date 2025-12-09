// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Cantina",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "AppFeature", targets: ["AppFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.10.0"),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
        ),
    ],
)
