# NeedBlood — Flutter App Codebase

This is a working Flutter codebase matching the approved wireframe:
registration (mobile + email), profile setup (gender, blood group,
province/city with a 30-city Punjab/Sindh/KPK list + custom "add city"),
home screen with the green "Need Blood" trigger, hospital-name field on
every request, a full-screen alarm alert with medium-high ringtone, the
compatibility engine, donor list, in-app chat, in-app audio calling, and
a blogs section — both online (push) and offline (SMS fallback).

## What's real vs. what's wired up

Every screen and the core matching/dispatch logic (`lib/data`,
`lib/services`) is implemented and runs. What's marked `// TODO:` are the
handful of places that need **your own accounts and keys** — I can't
create these on your behalf, they belong to you as the app owner:

| Piece | Needs |
|---|---|
| Login, user profiles, chat messages | A Firebase project (free Spark plan to start) |
| Push notification fan-out when a request is sent | A Cloud Function on that same Firebase project |
| SMS fallback when a donor/recipient has no internet | An SMS gateway account (Twilio, or a local Pakistani SMS API) |
| In-app audio calls | An Agora.io project (has a free tier) |
| Live map / distance | Already uses on-device GPS (`geolocator`) — no extra key needed |

## Getting it running

```bash
flutter create --project-name needblood .   # only if lib/ was dropped into a fresh flutter create
flutter pub get
flutterfire configure                        # links your Firebase project, generates firebase_options.dart
flutter run
```

Then in `lib/main.dart`, uncomment the two Firebase init lines once
`firebase_options.dart` exists.

## Building on Codemagic (no local computer needed)

This repo includes `codemagic.yaml`, already set up to build an
**unsigned/debug APK** — enough to sideload on your own phone for testing,
no Play Store account or signing key required:

1. Push this project to a GitHub repo.
2. In Codemagic, add the app from that repo — it will detect
   `codemagic.yaml` automatically.
3. Run the `needblood-test-apk` workflow.
4. Download the `.apk` from the build's Artifacts tab and install it on
   your phone (enable "Install unknown apps" for whichever app you open
   it with).

Note: this debug build works for installing and clicking through every
screen, but online features (chat, push alerts, Firestore) will error
until you've completed steps 1–2 below with your own Firebase project.

## Path to production (in order)

1. **Create the Firebase project** — enable Authentication (Phone + Email),
   Firestore, Cloud Messaging, and Storage.
2. **Write the Cloud Function** that fans out FCM pushes when a
   `blood_requests` doc is created (query donors by city + compatible
   blood groups, as outlined in `alert_dispatch_service.dart`).
3. **Add your alarm ringtone** — drop a medium-high intensity `.mp3` at
   `assets/sounds/alert_ring.mp3` and uncomment the `assets:` line in
   `pubspec.yaml`.
4. **Connect an SMS gateway** — swap the `telephony` direct-send call for
   your provider's API if you'd rather send from a server than the
   donor's own SIM.
5. **Get an Agora App ID** and pass it via `--dart-define=AGORA_APP_ID=...`
   when building.
6. **Test on real Android/iOS devices** — GPS, background notifications,
   and SMS all behave differently on emulators.
7. **Submit to Play Store / App Store** — needs a developer account on
   each ($25 one-time for Google, $99/year for Apple).

None of this can be skipped for a real production launch — but the app
itself, screen by screen, is done and ready for you or a developer to
plug those accounts into.
