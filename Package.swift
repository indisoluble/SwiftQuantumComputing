// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "SwiftQuantumComputing",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13)
    ],
    products: [
        .library(name: "SwiftQuantumComputing", targets: ["SwiftQuantumComputing"]),
    ],
    targets: [
        .target(name: "SwiftQuantumComputing", exclude: ["Drawer"]),
        .testTarget(name: "SwiftQuantumComputingTests",
                    dependencies: ["SwiftQuantumComputing"],
                    exclude: ["Drawer"]),
    ]
)
