//
// Project: EmbeeKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import StoreKit

public extension SKStoreReviewController {

    /// Requests a review for the app in the appropriate context based on the operating system.
    static func requestReviewInCurrentContext() {

        #if os(iOS)
        // iOS specific code to request a review in the current scene.
        if let scene = UIApplication.shared.connectedScenes.first(where: {
            $0.activationState == .foregroundActive
        }) as? UIWindowScene {
            // Request an App Store review in that scene.
            requestReview(in: scene)
        }

        #else

        // macOS specific code to request a review.
        // Directly request a review without specifying a scene.
        SKStoreReviewController.requestReview()

        #endif
    }
}
