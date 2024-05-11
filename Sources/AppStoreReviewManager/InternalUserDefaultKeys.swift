//
// Project: EmbeeKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import DefaultsKit

/// An internal enumeration that defines keys for UserDefaults settings.
///
/// Conforming to `UserDefaultsKeyRepresentable` allows these keys to be easily used
/// with UserDefaults for storing and retrieving values.
internal enum UserDefaultKeys: String, UserDefaultsKeyRepresentable {

    /// The raw value of the enum case is used as the key's value.
    /// Returns the user default key string.
    var value: String {
        guard let identifier = Bundle.main.bundleIdentifier else {
            return "userDefaults.\(rawValue)"
        }
        return "\(identifier).userDefault.\(rawValue)"
    }

    /// Key for the count of actions deemed worthy of asking the user for a review.
    case currentReviewWorthyActionCount

    /// Key for the last application version for which the user was prompted for a review.
    case lastReviewRequestAppVersion
}
