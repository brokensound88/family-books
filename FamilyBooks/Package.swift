// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FamilyBooks",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17)
    ],
    products: [
        // Main app library
        .library(
            name: "FamilyBooksCore",
            targets: ["FamilyBooksCore"]
        ),
        // Shared models library
        .library(
            name: "FamilyBooksModels",
            targets: ["FamilyBooksModels"]
        ),
        // Services library
        .library(
            name: "FamilyBooksServices",
            targets: ["FamilyBooksServices"]
        ),
        // Utilities library
        .library(
            name: "FamilyBooksUtilities",
            targets: ["FamilyBooksUtilities"]
        )
    ],
    dependencies: [
        // Firebase SDK for backend services
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "10.20.0"
        ),
        // Plaid SDK for bank account integration
        .package(
            url: "https://github.com/plaid/plaid-link-ios.git",
            from: "5.4.0"
        ),
        // Yodlee SDK for alternative bank integration
        .package(
            url: "https://github.com/yodlee/YodleeSDK-iOS.git",
            from: "1.0.0"
        ),
        // Alamofire for networking
        .package(
            url: "https://github.com/Alamofire/Alamofire.git",
            from: "5.8.1"
        ),
        // SwiftUI Charts for data visualization
        .package(
            url: "https://github.com/apple/swift-charts.git",
            from: "1.0.0"
        ),
        // Keychain wrapper for secure storage
        .package(
            url: "https://github.com/evgenyneu/keychain-swift.git",
            from: "20.0.0"
        ),
        // SwiftLint for code quality
        .package(
            url: "https://github.com/realm/SwiftLint.git",
            from: "0.54.0"
        ),
        // CryptoSwift for encryption
        .package(
            url: "https://github.com/krzyzanowskim/CryptoSwift.git",
            from: "1.8.0"
        ),
        // Lottie for animations
        .package(
            url: "https://github.com/airbnb/lottie-ios.git",
            from: "4.4.0"
        ),
        // SwiftUI Introspect for UIKit integration
        .package(
            url: "https://github.com/siteline/SwiftUI-Introspect.git",
            from: "1.1.0"
        ),
        // AsyncImage for image loading
        .package(
            url: "https://github.com/kean/Nuke.git",
            from: "12.4.0"
        ),
        // SwiftFormat for code formatting
        .package(
            url: "https://github.com/nicklockwood/SwiftFormat.git",
            from: "0.52.11"
        ),
        // Quick and Nimble for testing
        .package(
            url: "https://github.com/Quick/Quick.git",
            from: "7.3.0"
        ),
        .package(
            url: "https://github.com/Quick/Nimble.git",
            from: "13.0.0"
        ),
        // SwiftGen for resource generation
        .package(
            url: "https://github.com/SwiftGen/SwiftGen.git",
            from: "6.6.2"
        ),
        // Combine schedulers for testing
        .package(
            url: "https://github.com/pointfreeco/combine-schedulers.git",
            from: "1.0.0"
        ),
        // TCA (The Composable Architecture) for state management
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            from: "1.5.6"
        ),
        // SwiftUI Navigation for advanced navigation
        .package(
            url: "https://github.com/pointfreeco/swiftui-navigation.git",
            from: "1.2.0"
        ),
        // Dependencies for dependency injection
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies.git",
            from: "1.1.5"
        ),
        // IdentifiedCollections for performance
        .package(
            url: "https://github.com/pointfreeco/swift-identified-collections.git",
            from: "1.0.0"
        ),
        // SwiftUI Flow Layout
        .package(
            url: "https://github.com/globulus/swiftui-flow-layout.git",
            from: "1.0.5"
        ),
        // SwiftUI Shimmer for loading states
        .package(
            url: "https://github.com/markiv/SwiftUI-Shimmer.git",
            from: "1.4.2"
        )
    ],
    targets: [
        // MARK: - Main Targets
        
        // Core library target
        .target(
            name: "FamilyBooksCore",
            dependencies: [
                "FamilyBooksModels",
                "FamilyBooksServices",
                "FamilyBooksUtilities",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SwiftUINavigation", package: "swiftui-navigation"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "IdentifiedCollections", package: "swift-identified-collections")
            ],
            path: "Sources/FamilyBooksCore",
            resources: [
                .process("Resources")
            ]
        ),
        
        // Models library target
        .target(
            name: "FamilyBooksModels",
            dependencies: [
                .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
                .product(name: "CryptoSwift", package: "CryptoSwift")
            ],
            path: "Sources/FamilyBooksModels",
            resources: [
                .process("Resources")
            ]
        ),
        
        // Services library target
        .target(
            name: "FamilyBooksServices",
            dependencies: [
                "FamilyBooksModels",
                "FamilyBooksUtilities",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
                .product(name: "FirebasePerformance", package: "firebase-ios-sdk"),
                .product(name: "LinkKit", package: "plaid-link-ios"),
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "KeychainSwift", package: "keychain-swift"),
                .product(name: "CryptoSwift", package: "CryptoSwift"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "CombineSchedulers", package: "combine-schedulers")
            ],
            path: "Sources/FamilyBooksServices",
            resources: [
                .process("Resources")
            ]
        ),
        
        // Utilities library target
        .target(
            name: "FamilyBooksUtilities",
            dependencies: [
                .product(name: "Lottie", package: "lottie-ios"),
                .product(name: "SwiftUIIntrospect", package: "SwiftUI-Introspect"),
                .product(name: "Nuke", package: "Nuke"),
                .product(name: "NukeUI", package: "Nuke"),
                .product(name: "FlowLayout", package: "swiftui-flow-layout"),
                .product(name: "Shimmer", package: "SwiftUI-Shimmer"),
                .product(name: "CryptoSwift", package: "CryptoSwift")
            ],
            path: "Sources/FamilyBooksUtilities",
            resources: [
                .process("Resources")
            ]
        ),
        
        // MARK: - Test Targets
        
        // Core tests
        .testTarget(
            name: "FamilyBooksCoreTests",
            dependencies: [
                "FamilyBooksCore",
                .product(name: "Quick", package: "Quick"),
                .product(name: "Nimble", package: "Nimble"),
                .product(name: "CombineSchedulers", package: "combine-schedulers")
            ],
            path: "Tests/FamilyBooksCoreTests",
            resources: [
                .process("Resources")
            ]
        ),
        
        // Models tests
        .testTarget(
            name: "FamilyBooksModelsTests",
            dependencies: [
                "FamilyBooksModels",
                .product(name: "Quick", package: "Quick"),
                .product(name: "Nimble", package: "Nimble")
            ],
            path: "Tests/FamilyBooksModelsTests"
        ),
        
        // Services tests
        .testTarget(
            name: "FamilyBooksServicesTests",
            dependencies: [
                "FamilyBooksServices",
                .product(name: "Quick", package: "Quick"),
                .product(name: "Nimble", package: "Nimble"),
                .product(name: "CombineSchedulers", package: "combine-schedulers")
            ],
            path: "Tests/FamilyBooksServicesTests"
        ),
        
        // Utilities tests
        .testTarget(
            name: "FamilyBooksUtilitiesTests",
            dependencies: [
                "FamilyBooksUtilities",
                .product(name: "Quick", package: "Quick"),
                .product(name: "Nimble", package: "Nimble")
            ],
            path: "Tests/FamilyBooksUtilitiesTests"
        )
    ],
    swiftLanguageVersions: [.v5]
)

// MARK: - Build Configuration

#if canImport(PackageConfig)
import PackageConfig

let config = PackageConfiguration([
    "SwiftLint": .init([
        "--config", ".swiftlint.yml"
    ]),
    "SwiftFormat": .init([
        "--config", ".swiftformat"
    ]),
    "SwiftGen": .init([
        "config", "run", "--config", "swiftgen.yml"
    ])
])
#endif

// MARK: - Conditional Dependencies

// Add development dependencies only in debug builds
#if DEBUG
package.dependencies.append(contentsOf: [
    .package(
        url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
        from: "1.15.0"
    )
])

// Add snapshot testing to test targets
if let coreTestTarget = package.targets.first(where: { $0.name == "FamilyBooksCoreTests" }) {
    coreTestTarget.dependencies.append(
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
    )
}
#endif

// MARK: - Platform-specific Dependencies

// iOS-specific dependencies
#if os(iOS)
package.dependencies.append(contentsOf: [
    .package(
        url: "https://github.com/apple/swift-docc-plugin.git",
        from: "1.3.0"
    )
])
#endif

// MARK: - Compiler Settings

// Add compiler flags for all targets
for target in package.targets {
    target.swiftSettings = [
        .enableUpcomingFeature("BareSlashRegexLiterals"),
        .enableUpcomingFeature("ConciseMagicFile"),
        .enableUpcomingFeature("ForwardTrailingClosures"),
        .enableUpcomingFeature("ImportObjcForwardDeclarations"),
        .enableUpcomingFeature("DisableOutwardActorInference"),
        .enableExperimentalFeature("StrictConcurrency"),
        .define("SWIFT_PACKAGE"),
        .unsafeFlags([
            "-Xfrontend", "-warn-concurrency",
            "-Xfrontend", "-enable-actor-data-race-checks"
        ], .when(configuration: .debug))
    ]
}

// MARK: - Resource Processing

// Ensure all resource bundles are properly configured
for target in package.targets where target.type == .regular {
    if target.resources == nil {
        target.resources = []
    }
    
    // Add common resources
    target.resources?.append(contentsOf: [
        .process("Localizable.strings"),
        .process("InfoPlist.strings")
    ])
}

// MARK: - Documentation

// Configure documentation generation
package.targets.forEach { target in
    if target.type == .regular {
        target.swiftSettings?.append(contentsOf: [
            .define("DOCC_JSON_PRETTYPRINT"),
            .define("ENABLE_DOCC_SUPPORT")
        ])
    }
}