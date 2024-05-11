//
// Project: EmbeeKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import StoreKit
import DefaultsKit

/// Manages the logic of requesting app store reviews.
final public class AppStoreReviewManager {

	// MARK: - Properties

	/// Minimum number of "worthy actions" to trigger the review request.
	private var minimumWorthyActionCount: Int

	// MARK: - Initializers

	public init(minimumWorthyActionCount: Int = 20) {
		self.minimumWorthyActionCount = minimumWorthyActionCount
	}

	// MARK: - Public Methods

	/// Requests an app store review if certain conditions are met.
	public func requestReviewIfAppropriate() {

		// Check if it's appropriate to request a review
		if shouldRequestReview() {
			SKStoreReviewController.requestReviewInCurrentContext()
			resetCounters()
		} else {
			incrementCounter()
		}
	}

	// MARK: - Private Methods

	/// Determines whether or not it is appropriate to request an app review.
	private func shouldRequestReview() -> Bool {
		let currentCount = getCurrentWorthyActionCount()
		guard currentCount >= minimumWorthyActionCount else { return false }

		let currentVersion = Bundle.main.appVersion
		let lastVersion = getLastReviewRequestAppVersion()

		return lastVersion != currentVersion
	}

	/// Retrieves the current count of review-worthy actions from UserDefaults.
	private func getCurrentWorthyActionCount() -> Int {
		return UserDefaults.standard.integer(
			for: UserDefaultKeys.currentReviewWorthyActionCount)
	}

	/// Increments the counter for review-worthy actions.
	private func incrementCounter() {
		var count = getCurrentWorthyActionCount()
		count += 1
		UserDefaults.standard.set(count, 
								  for: UserDefaultKeys.currentReviewWorthyActionCount)
	}

	/// Resets the counters and sets the current app version as the last version for 
    /// which a review was requested.
	private func resetCounters() {
		UserDefaults.standard.set(0, for: UserDefaultKeys.currentReviewWorthyActionCount)
		UserDefaults.standard.set(Bundle.main.appVersion,
								  for: UserDefaultKeys.lastReviewRequestAppVersion)
	}

	/// Retrieves the last app version for which a review was requested from UserDefaults.
	private func getLastReviewRequestAppVersion() -> String? {
		return UserDefaults.standard.string(
			for: UserDefaultKeys.lastReviewRequestAppVersion)
	}
}
