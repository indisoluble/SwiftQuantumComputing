// swift-tools-version:5.1

import PackageDescription

var dependencies: [Package.Dependency] = []
#if os(Linux)
dependencies = [
    .package(
        url: "https://github.com/indisoluble/CBLAS-Linux.git",
        from: "1.0.0"
    )
]
#endif

let package = Package(
    name: "SwiftQuantumComputing",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13)
    ],
    products: [
        .library(
            name: "SwiftQuantumComputing",
            targets: [
                "SwiftQuantumComputing"
            ]
        )
    ],
    dependencies: dependencies,
    targets: [
        .target(
            name: "SwiftQuantumComputing",
            exclude: [
                "Drawer"
            ]
        ),
        .testTarget(
            name: "SwiftQuantumComputingTests",
            dependencies: [
                "SwiftQuantumComputing"
            ],
            exclude: [
                "Drawer"
            ]
        )
    ]
)
