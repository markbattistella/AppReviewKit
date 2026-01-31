//
// Project: AppReviewKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import DefaultsKit
import Foundation

/// An enumeration representing keys for storing review-related settings in `UserDefaults`.
/// Each case corresponds to a specific setting that can be stored and retrieved.
public enum ReviewUserDefaultsKey: String, UserDefaultsKeyRepresentable {

    /// The number of user interactions counted towards the review threshold.
    case reviewCountThreshold

    /// The app installation date.
    ///
    /// - Important: This key is not persistent across app reinstalls.
    case appInstallDate

    /// The last date a review was requested.
    case lastReviewRequestDate

    /// The app version at the time of the last review request.
    case lastReviewedVersion

    /// Default suite name to group all package keys.
    public static var suiteName: String? {
        "com.markbattistella.packages.appReviewKit"
    }
}
