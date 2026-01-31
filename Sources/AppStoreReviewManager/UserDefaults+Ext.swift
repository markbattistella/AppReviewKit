//
// Project: AppStoreReviewManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

extension UserDefaults {

    /// A `UserDefaults` instance specifically used for managing review-related settings.
    ///
    /// This instance is created using an app group identifier to allow shared access between app
    /// extensions. If the app group cannot be found, the standard `UserDefaults` instance is used
    /// as a fallback.
    ///
    /// - Note: The app group identifier must be correctly configured for this to work. This allows
    /// for storing shared settings that can be accessed across different parts of the app, such
    /// as extensions or widgets.
    nonisolated(unsafe)
    public static let review: UserDefaults = {
        guard let userDefaults = UserDefaults(suiteName: ASRUserDefaultsKey.suiteName) else {
            return .standard
        }
        return userDefaults
    }()
}
