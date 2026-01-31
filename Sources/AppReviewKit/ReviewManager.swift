//
// Project: AppReviewKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import SwiftUI
import StoreKit
import DefaultsKit

/// Manages when to prompt users for App Store reviews based on usage patterns.
///
/// `ReviewManager` tracks install date, user interactions, and cooldown periods to decide when it
/// is appropriate to show a review request. This helps avoid prompting too soon or too often,
/// improving user experience and compliance with Apple's guidelines.
@MainActor
public final class ReviewManager {

    /// Minimum number of days since installation before a review can be requested.
    private let minDaysSinceInstall: Int

    /// Number of user interactions required before a review can be considered.
    private let actionThreshold: Int

    /// Minimum number of days between review requests.
    private let cooldownDays: Int

    /// Shared user defaults for persisting review state.
    private let defaults = UserDefaults.review

    /// Creates a new review manager.
    ///
    /// On first launch, this initialiser records the install date in user defaults.
    ///
    /// - Parameters:
    ///   - minDaysSinceInstall: Minimum days after install before prompting. Defaults to `7`.
    ///   - actionThreshold: Number of interactions required before prompting. Defaults to `20`.
    ///   - coolDownDays: Minimum days between review prompts. Defaults to `30`.
    public nonisolated init(
        minDaysSinceInstall: Int = 7,
        actionThreshold: Int = 20,
        coolDownDays: Int = 30
    ) {
        self.minDaysSinceInstall = minDaysSinceInstall
        self.actionThreshold = actionThreshold
        self.cooldownDays = coolDownDays
    }

    /// Registers a user interaction that may count towards triggering a review prompt.
    ///
    /// Increments the interaction counter and, once the threshold is reached, checks install age
    /// and cooldown before requesting a review.
    ///
    /// - Parameter requestReview: The review action provided by SwiftUI's
    ///   `@Environment(\.requestReview)`.
    public func registerInteraction(_ requestReview: RequestReviewAction) {
        recordInstallDateIfNeeded()
        let newCount = defaults.integer(for: ReviewUserDefaultsKey.reviewCountThreshold) + 1
        defaults.set(newCount, for: ReviewUserDefaultsKey.reviewCountThreshold)

        guard newCount >= actionThreshold else { return }

        guard passesGatingChecks() else { return }

        defaults.set(0, for: ReviewUserDefaultsKey.reviewCountThreshold)
        recordAndRequest(requestReview)
    }

    /// Triggers a review prompt after a significant user event, bypassing the action counter.
    ///
    /// Use this for meaningful moments (e.g. completing a project, exporting a file) where the
    /// action count threshold doesn't apply, but install age and cooldown are still respected.
    ///
    /// - Parameter requestReview: The review action provided by SwiftUI's
    ///   `@Environment(\.requestReview)`.
    public func registerSignificantEvent(_ requestReview: RequestReviewAction) {
        recordInstallDateIfNeeded()
        guard passesGatingChecks() else { return }
        recordAndRequest(requestReview)
    }

    /// Triggers a review prompt if the app has been updated to a new version since the last prompt.
    ///
    /// Checks whether the current bundle version differs from the version stored at the time of
    /// the last review request. Install age and cooldown are still respected.
    ///
    /// - Parameter requestReview: The review action provided by SwiftUI's
    ///   `@Environment(\.requestReview)`.
    public func registerNewVersionEvent(_ requestReview: RequestReviewAction) {
        recordInstallDateIfNeeded()
        let currentVersion = Bundle.main.appVersion
        let lastVersion = defaults.string(for: ReviewUserDefaultsKey.lastReviewedVersion)

        guard currentVersion != lastVersion else { return }
        guard passesGatingChecks() else { return }

        defaults.set(currentVersion, for: ReviewUserDefaultsKey.lastReviewedVersion)
        recordAndRequest(requestReview)
    }
}

// MARK: - Private

extension ReviewManager {

    /// Records the install date if it has not already been set.
    private func recordInstallDateIfNeeded() {
        if defaults.date(for: ReviewUserDefaultsKey.appInstallDate) == nil {
            defaults.set(Date.now, for: ReviewUserDefaultsKey.appInstallDate)
        }
    }

    /// Returns `true` if both the install-age and cooldown checks pass.
    private func passesGatingChecks() -> Bool {
        if let installDate = defaults.date(for: ReviewUserDefaultsKey.appInstallDate) {
            guard let cutoff = Calendar.autoupdatingCurrent
                .date(byAdding: .day, value: minDaysSinceInstall, to: installDate),
                  Date.now >= cutoff else { return false }
        }

        if let lastRequest = defaults.date(for: ReviewUserDefaultsKey.lastReviewRequestDate) {
            guard let cutoff = Calendar.autoupdatingCurrent
                .date(byAdding: .day, value: cooldownDays, to: lastRequest),
                  Date.now >= cutoff else { return false }
        }

        return true
    }

    /// Records the review request date and calls the review action.
    private func recordAndRequest(_ requestReview: RequestReviewAction) {
        defaults.set(Date.now, for: ReviewUserDefaultsKey.lastReviewRequestDate)
        requestReview()
    }
}
