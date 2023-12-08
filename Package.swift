// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "SQLite.swift",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13),
        .watchOS(.v4),
        .tvOS(.v11)
    ],
    products: [
        .library(
            name: "SQLiteSwift",
            targets: ["SQLiteSwift"]
        ),
        .library(
            name: "SQLCipher",
            targets: ["SQLCipher"]
        )
    ],
    targets: [
        .target(
            name: "SQLiteSwift",
            dependencies: [
                "SQLCipher"
            ],
            exclude: [
                "Info.plist"
            ],
            cSettings: [
                .define("SQLITE_HAS_CODEC")
            ],
            swiftSettings: [
                .define("SQLITE_SWIFT_SQLCIPHER"),
            ]
        ),
        .target(
            name: "SQLCipher",
            publicHeadersPath: ".",
            cSettings: [
                .define("SQLITE_HAS_CODEC"),
                .define("SQLCIPHER_CRYPTO_CC"),
                .define("NDEBUG"),
                .define("SQLITE_TEMP_STORE", to: "3"),
                .unsafeFlags(["-w"])
            ]
        ),
        .testTarget(
            name: "SQLiteSwiftests",
            dependencies: [
                "SQLiteSwift"
            ],
            path: "Tests/SQLiteSwiftTests",
            exclude: [
                "Info.plist"
            ],
            resources: [
                .copy("Resources")
            ]
        )
    ]
)

#if os(Linux)
package.dependencies = [
    .package(url: "https://github.com/stephencelis/CSQLite.git", from: "0.0.3")
]
package.targets.first?.dependencies += [
    .product(name: "CSQLite", package: "CSQLite")
]
#endif
