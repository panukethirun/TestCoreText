// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TestCoreText",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "TestCoreText", targets: ["TestCoreText"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.0.0"),
        .package(url: "https://github.com/Flipboard/FLAnimatedImage.git", from: "1.0.16"),
        .package(url: "https://github.com/Cocoanetics/DTCoreText.git", from: "1.6.28")
    ],
    targets: [
        .target(
            name: "TestCoreText",
            dependencies: [
                "SDWebImage",
                "FLAnimatedImage",
                "DTCoreText"
            ],
            path: "Sources"
        )
    ]
)
