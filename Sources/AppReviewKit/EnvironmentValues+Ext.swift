//
// Project: AppReviewKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI

// MARK: - Environment

/// Environment key for injecting a `ReviewManager` into the SwiftUI environment.
private struct ReviewManagerKey: EnvironmentKey {
    static let defaultValue = ReviewManager()
}

extension EnvironmentValues {

    /// The review manager for the current environment.
    ///
    /// Use this to access the review manager from any SwiftUI view:
    ///
    /// ```swift
    /// @Environment(\.reviewManager) private var reviewManager
    /// ```
    ///
    /// To provide a custom instance, use the `environment` modifier:
    ///
    /// ```swift
    /// ContentView()
    ///     .environment(\.reviewManager, ReviewManager(minDaysSinceInstall: 3))
    /// ```
    public var reviewManager: ReviewManager {
        get { self[ReviewManagerKey.self] }
        set { self[ReviewManagerKey.self] = newValue }
    }
}
