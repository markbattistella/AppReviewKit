//
// Project: 
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

internal extension Bundle {

    /// The version number of the app.
    var appVersion: String {
        object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
}
