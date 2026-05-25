//
// Project: AppReviewKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

extension UserDefaults {

  /// A `UserDefaults` instance specifically used for managing review-related settings.
  ///
  /// This accessor uses a dedicated suite name so review-related values do not collide with
  /// the app's standard defaults. If the suite cannot be created, the standard `UserDefaults`
  /// instance is used as a fallback.
  public static var review: UserDefaults {
    UserDefaults(suiteName: ReviewUserDefaultsKey.suiteName) ?? .standard
  }
}
