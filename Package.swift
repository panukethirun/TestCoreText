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
        .package(url: "https://github.com/Flipboard/FLAnimatedImage.git", from: "1.0.16"), // หรือใช้ fork ที่รองรับ SPM
        // DTCoreText ไม่มี SPM อย่างเป็นทางการ ต้องใช้แบบ local หรือ fork ที่มี Package.swift
        .package(url: "https://github.com/Cocoanetics/DTCoreText.git", from: "1.6.28") // ถ้าคุณแปลง DTCoreText เองเป็น SPM
    ],
    targets: [
        .target(
            name: "TestCoreText",
            dependencies: [
                "SDWebImage",
                "FLAnimatedImage",
                "DTCoreText"
            ],
            path: "Sources/TestCoreText",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
