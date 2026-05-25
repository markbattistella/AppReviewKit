//
// Project: AppReviewKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import DefaultsKit
import Foundation
import Testing

@testable import AppReviewKit

@Suite(.serialized)
struct ReviewManagerTests {

  @Test("Initialisation records the install date")
  func initialisationRecordsInstallDate() {
    let defaults = UserDefaults.review
    defaults.remove(for: ReviewUserDefaultsKey.appInstallDate)

    #expect(defaults.date(for: ReviewUserDefaultsKey.appInstallDate) == nil)

    _ = ReviewManager()

    #expect(defaults.date(for: ReviewUserDefaultsKey.appInstallDate) != nil)

    defaults.remove(for: ReviewUserDefaultsKey.appInstallDate)
  }
}
