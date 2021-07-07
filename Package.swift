// swift-tools-version:5.1

import PackageDescription

var dependencies: [Package.Dependency] = [
    .package(
        url: "https://github.com/apple/swift-numerics.git",
        .exact("0.1.0")
    ),
    .package(
        url: "https://github.com/apple/swift-argument-parser",
        .upToNextMinor(from: "0.4.0")
    )
]
#if os(Linux)
dependencies += [
    .package(
        url: "https://github.com/indisoluble/CBLAS-Linux.git",
        .exact("1.0.0")
    ),
    .package(
        url: "https://github.com/indisoluble/CLapacke-Linux.git",
        .exact("1.0.1")
    )
]
#endif

let package = Package(
    name: "SwiftQuantumComputing",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "SwiftQuantumComputing",
            targets: [
                "SwiftQuantumComputing"
            ]
        ),
        .executable(
            name: "sqc-measure-performance",
            targets: [
                "SQCMeasurePerformance"
            ]
        )
    ],
    dependencies: dependencies,
    targets: [
        .target(
            name: "SwiftQuantumComputing",
            dependencies: [
                .product(
                    name: "ComplexModule",
                    package: "swift-numerics"
                )
            ],
            exclude: [
                "Drawer"
            ]
        ),
        .target(
            name: "SQCMeasurePerformance",
            dependencies: [
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                ),
                "SwiftQuantumComputing"
            ]
        ),
        .testTarget(
            name: "SwiftQuantumComputingTests",
            dependencies: [
                "SwiftQuantumComputing"
            ],
            exclude: [
                "Drawer",
                "TestDouble/Drawer"
            ]
        )
    ]
)
