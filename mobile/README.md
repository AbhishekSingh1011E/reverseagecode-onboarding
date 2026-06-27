# ReverseAge Onboarding — Mobile

Flutter app for the onboarding flow (Step 1 of 3): collects name, date of birth, gender, lifestyle, weight, and height, then saves the profile through the backend API.

See the [root README](../README.md) for the full picture — backend setup, API endpoints, database schema, and screenshots. This file just covers the mobile side.

## Folder Structure

```text
lib/
  models/        OnboardingModel — the data shape sent to/from the API
  providers/     OnboardingProvider — holds form state, talks to the repository
  screens/       OnboardingScreen, SuccessScreen
  services/      OnboardingService (HTTP calls), LocalStorageService (offline cache)
  utils/         Validators, BmiCalculator
  widgets/       CustomTextField, GenderSelector, LifestyleDropdown, DatePickerField, etc.
  main.dart
```

`OnboardingRepository` sits between the provider and the service: it tries the network call first, and if that fails it falls back to `LocalStorageService` so the submission isn't lost.

## Packages Used

| Package | Why it's there |
| --- | --- |
| `provider` | State management for the form |
| `http` | Calls `POST`/`GET /api/onboarding` |
| `connectivity_plus` | Detects when the device is back online, to retry a pending submission |
| `shared_preferences` | Stores the pending submission on-device when the backend can't be reached |
| `cupertino_icons` | Default icon set from the Flutter starter template |
| `flutter_lints` (dev) | Lint rules used by `flutter analyze` |

## Run

```bash
flutter pub get
flutter run
```

The backend address is set in `lib/services/onboarding_service.dart`:

```dart
const host = "10.122.193.154";
```

Change this to whatever address can reach your backend (LAN IP for a phone, `10.0.2.2` for the Android emulator, `localhost` for the iOS simulator), then restart the app.

## Tests

```bash
flutter test
```

Covers form validation/disabled-button behavior, layout on multiple screen sizes, and the offline save/retry flow.
