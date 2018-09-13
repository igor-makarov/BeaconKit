// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "BeaconKit",
    products: [
        .library(
            name: "BeaconKit",
            targets: ["BeaconKit"])
        ],
    targets: [
        .target(name: "BeaconKit"),
        .testTarget(name: "BeaconKitTests",
                    dependencies: [
                        "BeaconKit"
            ])
        ],
    swiftLanguageVersions: [3, 4]
)
