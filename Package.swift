// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SwiftKotlinOnline",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        // 🍃 An expressive, performant, and extensible templating language built for Swift.
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0"),

        .package(url: "https://github.com/yanagiba/swift-transform", .exact("0.18.10")),
        .package(url:"https://github.com/angelolloqui/SwiftKotlin.git", .revision("e993ad55276531e5f723b0ede47d0619ea734dcf"))


    ],
    targets: [
        .target(name: "App", dependencies: ["Leaf", "Vapor", "SwiftKotlinFramework", "swift-transform"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

