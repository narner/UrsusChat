# Ursus Chat

An Urbit chat application for iOS.

Work in progress; first project using my [UrsusAirlock](https://github.com/dclelland/UrsusAirlock) HTTP/`%eyre` client library.

### Screenshots

<img src="/Screenshots/IMG_8933.PNG" width="200"> <img src="/Screenshots/IMG_8934.PNG" width="200"> <img src="/Screenshots/IMG_8935.PNG" width="200">

### Current status

#### 23 October 2020

Am currently spinning this project back up after a two-month break.

The network level components are complete - the airlock library is implemented, with authentication, pokes and subscribes working smoothly. Channel disconnection/reconnection is handled gracefully. At the app level, I use a redux/unidirectional data flow pattern, and types and reducers for managing the client-side store are complete.

At the interface level, the project is at an "MVP" stage - a user can sign in and post messages, but it's still rough around the edges, and there's a long laundry list of features that need to be built in order to get the project "feature complete". Top priority is getting a graph-store adaptor working in Ursus Airlock.

I've opted to develop the interface layer in SwiftUI, as it's much faster for me to build interfaces in SwiftUI than UIKit.

#### TestFlight

I'm running a TestFlight with an iOS 14-compatible build - feel free to DM me at `~lanrus-rinfep` for an invite, and join the `~lanrus-rinfep/ursus` group for discussion. ~~Unfortunately you will need to supply your Apple ID email address - if uncomfortable with that, perhaps you can install Xcode in order to build the project.~~ Update: Can confirm that installing via the invite link should not reveal your identity to me.

## Todo list

Tasks are managed on the [UrsusChat kanban board](https://github.com/dclelland/UrsusChat/projects/1).

## Installation

1. [Install Xcode](https://apps.apple.com/us/app/xcode/id497799835) (version 11.5 at time of writing)
2. Open `Ursus Chat.xcworkspace`
3. Build

You may possibly need to: Open Xcode, navigate to *Targets* → *Signing & Capabilities*, select your development team, and change the bundle identifier.

In addition to this, you will likely also need to open *Settings* → *General* → *Device Management* on your device, and trust the certificate used to code sign your app.

## Dependencies:

Internal

- [UrsusAirlock](https://github.com/dclelland/UrsusAirlock)
- [UrsusAtom](https://github.com/dclelland/UrsusAtom)
- [UrsusSigil](https://github.com/dclelland/UrsusSigil)

External

- [AlamofireNetworkActivityIndicator](https://github.com/Alamofire/AlamofireNetworkActivityIndicator)
- [AlamofireLogger](https://github.com/dclelland/AlamofireLogger)
- [Introspect](https://github.com/siteline/SwiftUI-Introspect)
- [KeyboardObserving](https://github.com/nickffox/KeyboardObserving)
- [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess)
- [NonEmpty](https://github.com/pointfreeco/swift-nonempty)
- [ReSwift](https://github.com/ReSwift/ReSwift)
- [ReSwiftThunk](https://github.com/ReSwift/ReSwift-Thunk)
- [SwiftDate](https://github.com/malcommac/SwiftDate)
