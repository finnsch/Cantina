// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Cantina",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "ApiClient", targets: ["ApiClient"]),
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "PeopleFeature", targets: ["PeopleFeature"]),
        .library(name: "SharedModels", targets: ["SharedModels"]),
        .library(name: "SharedViews", targets: ["SharedViews"]),
        .library(name: "Styleguide", targets: ["Styleguide"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.10.0"),
    ],
    targets: [
        .target(
            name: "ApiClient",
            dependencies: [
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
        ),
        .target(
            name: "AppFeature",
            dependencies: [
                "PeopleFeature",
                "SharedViews",
            ],
        ),
        .target(
            name: "PeopleFeature",
            dependencies: [
                "ApiClient",
                "SharedModels",
                "SharedViews",
                "Styleguide",
            ],
        ),
        .target(name: "SharedModels"),
        .target(
            name: "SharedViews",
            dependencies: [
                "Styleguide",
            ],
        ),
        .target(name: "Styleguide"),
    ],
)
