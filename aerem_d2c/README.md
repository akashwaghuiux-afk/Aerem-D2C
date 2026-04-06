# Aerem Solar D2C App

Mobile D2C app for Aerem Solar — built with Flutter.

## Quick Start (Local)

```bash
flutter pub get
flutter run
```

## Build APK

```bash
flutter build apk --release
```

## Codemagic Setup

1. Push this repo to GitHub/GitLab/Bitbucket
2. Go to [codemagic.io](https://codemagic.io) → Add Application
3. Select your repo → it auto-detects `codemagic.yaml`
4. Choose workflow:
   - **Android Debug APK** — quick build, no signing needed
   - **Android Build** — release APK + AAB (needs keystore in Codemagic settings)
   - **iOS Build** — needs Apple signing setup in Codemagic

### For Android Release signing:
1. Codemagic → Settings → Code Signing → Android
2. Upload your keystore file
3. Set keystore password, key alias, key password
4. Reference name: `keystore_reference`

### For iOS:
1. Codemagic → Settings → Code Signing → iOS
2. Connect your Apple Developer account
3. Bundle ID: `co.aerem.d2c`

## Project Structure

```
aerem_d2c/
├── lib/
│   └── main.dart          # Complete app (all 30+ screens)
├── android/               # Android platform files
├── ios/                   # iOS platform files
├── codemagic.yaml         # CI/CD config
├── pubspec.yaml           # Dependencies
└── README.md
```

## App ID
- Android: `co.aerem.d2c`
- iOS Bundle: `co.aerem.d2c`
