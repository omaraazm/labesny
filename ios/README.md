# labesny iOS app

SwiftUI app. Open `labesny.xcodeproj` — target `labesny`, iOS 18.0+.

## Required: create Secrets.swift

`labesny/Secrets.swift` is gitignored, so a fresh clone won't compile until you
create it:

    import Foundation

    enum Secrets {
        static let openWeatherMapAPIKey = "<your OpenWeatherMap key>"
        static let backendBaseURL = "http://<your Mac's LAN IP>:8000"
    }

Find your Mac's IP with `ipconfig getifaddr en0`.

**This IP changes.** Switching networks or getting a new DHCP lease will break the
app's connection to the backend, with no obvious error — it just fails to load
anything. When that happens, update two places: `backendBaseURL` above, and the
matching ATS exception in `labesny/Info.plist`, which is what permits plain HTTP
to that address.

## Running

Start the backend first, then run from Xcode. **Pick an iPhone simulator, not
"My Mac"** — the project lists macOS among its supported platforms, but
`ImagePicker.swift` uses UIKit-only APIs, so a Mac build fails with
"No such module 'UIKit'".

## Layout

    labesny/
      Views/         Screens (HomeView is the entry point)
      Models/        ClothingItem, Outfit, enums, weather models
      Services/      Backend client, image upload, weather, background removal
      Secrets.swift  Gitignored — you create this

## Screens

- `HomeView` — entry point: temperature, event, location, and GENERATE
- `WardrobeView` — photo grid of your items; long-press to delete, `+` to add
- `AddItemDrawer` — add an item (type, dress code, fit, colour, photo)
- `ContentView` — the generated outfit, composited into one image
- `LoginView` — unused; the app launches straight into HomeView
- `TripView` / `TripContentView` / `TripItemView` — unfinished mockup

## How the outfit image is built

`OutfitCollageView` downloads both item photos and runs `SubjectLiftService` on
each — Vision's `VNGenerateForegroundInstanceMaskRequest`, entirely on-device — to
cut each garment out of its background, then stacks the cutouts. If an item has no
photo, or Vision can't find a clear subject, it falls back to SF Symbol icons.

## Gotchas worth knowing

`WardrobeService` and `WeatherService` are `@MainActor` on purpose: they publish to
SwiftUI views, and hopping to the main queue mid-call previously deadlocked the
main thread during view teardown. Observe the `WeatherService.shared` singleton
with `@ObservedObject`, never `@StateObject`.

Views that are pushed onto a navigation stack must not wrap themselves in their own
`NavigationStack` — nesting them breaks the pop transition. `TripView` and
`TripContentView` still do this and will need fixing if that flow is revived.
