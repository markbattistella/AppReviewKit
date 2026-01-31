<!-- markdownlint-disable MD024 MD033 MD041 -->
<div align="center">

# AppStoreReviewManager

![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FAppStoreReviewManager%2Fbadge%3Ftype%3Dswift-versions)

![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FAppStoreReviewManager%2Fbadge%3Ftype%3Dplatforms)

![Licence](https://img.shields.io/badge/Licence-MIT-white?labelColor=blue&style=flat)

</div>

`AppStoreReviewManager` is a Swift package that provides a configurable and reusable way to prompt users for App Store reviews. It tracks install date, interaction count, and cooldown periods to determine the right moment to request a review — avoiding prompting too early or too often.

## Features

- **Interaction-Based Prompting:** Accumulate user interactions and prompt only after a configurable threshold is reached.
- **Significant Event Prompting:** Trigger a review prompt after meaningful moments (e.g. completing a project, exporting a file) without requiring a counter threshold.
- **Version-Based Prompting:** Prompt users once per app version update, ideal for re-engaging users after new features ship.
- **Install Age Gating:** Prevent prompting users who only recently installed the app.
- **Cooldown Periods:** Enforce a minimum number of days between review requests.
- **Isolated Persistence:** All state is stored in a dedicated `UserDefaults` suite to avoid clashes with your app's other settings.

## Installation

Add `AppStoreReviewManager` to your Swift project using Swift Package Manager.

```swift
dependencies: [
  .package(url: "https://github.com/markbattistella/AppStoreReviewManager", from: "1.0.0")
]
```

## Usage

### Setup

Create a `ReviewManager` instance with your desired configuration. The defaults are sensible starting points:

```swift
let reviewManager = ReviewManager(
  minDaysSinceInstall: 7,   // wait 7 days after install
  actionThreshold: 20,      // require 20 interactions
  coolDownDays: 30           // wait 30 days between prompts
)
```

All three methods require the `RequestReviewAction` provided by SwiftUI's `@Environment(\.requestReview)`:

```swift
struct ContentView: View {
  @Environment(\.requestReview) private var requestReview

  let reviewManager = ReviewManager()

  var body: some View {
    // ...
  }
}
```

### Interaction-Based Prompting

Use `registerInteraction(_:)` for general user actions. Each call increments an internal counter. Once the threshold is reached and the install age and cooldown checks pass, a review is requested and the counter resets.

```swift
Button("Save Document") {
  saveDocument()
  reviewManager.registerInteraction(requestReview)
}
```

This is the most common entry point — sprinkle it across routine actions (saving, navigating, completing tasks) and let the threshold and timing logic handle the rest.

### Significant Event Prompting

Use `registerSignificantEvent(_:)` for meaningful moments where you want to bypass the action counter. Install age and cooldown are still respected.

```swift
func didFinishExport() {
  // Export completed — good moment to ask
  reviewManager.registerSignificantEvent(requestReview)
}
```

Use this for moments like completing a game round, finishing onboarding, or successfully exporting content.

### Version-Based Prompting

Use `registerNewVersionEvent(_:)` to prompt users once after updating to a new app version. Install age and cooldown are still respected.

```swift
struct ContentView: View {
  @Environment(\.requestReview) private var requestReview

  let reviewManager = ReviewManager()

  var body: some View {
    MyMainView()
      .onAppear {
        reviewManager.registerNewVersionEvent(requestReview)
      }
  }
}
```

This compares the current `CFBundleShortVersionString` against the version stored at the time of the last review prompt. It only fires once per new version.

### Choosing the Right Method

| Method | Action counter | Install age | Cooldown | Version check |
| --- | :-: | :-: | :-: | :-: |
| `registerInteraction` | Yes | Yes | Yes | No |
| `registerSignificantEvent` | No | Yes | Yes | No |
| `registerNewVersionEvent` | No | Yes | Yes | Yes |

- **General usage** — `registerInteraction`: call it on routine actions and let the counter and timing do the work.
- **Meaningful moments** — `registerSignificantEvent`: skip the counter but still respect timing.
- **Post-update** — `registerNewVersionEvent`: prompt once after a version change.

> [!NOTE]
> If you don't need any gating logic and just want to request a review directly, use SwiftUI's `@Environment(\.requestReview)` without this package. Apple still rate-limits review prompts at the OS level regardless.

## How It Works

On first initialisation, `ReviewManager` records the install date in a dedicated `UserDefaults` suite (`com.markbattistella.packages.appStoreReviewManager`). All review state — interaction count, last request date, and last reviewed version — is stored in this isolated suite to prevent conflicts with your app's other settings.

Every method shares the same gating logic:

1. **Install age check** — has enough time passed since the app was installed?
2. **Cooldown check** — has enough time passed since the last review request?

`registerInteraction` adds an additional step before these checks: it increments a counter and only proceeds once the configured threshold is met. `registerNewVersionEvent` adds a version comparison before the gating checks.

## Contributing

Contributions are always welcome! Feel free to submit a pull request or open an issue for any suggestions or improvements you have.

## License

`AppStoreReviewManager` is licensed under the MIT License. See the LICENCE file for more details.
