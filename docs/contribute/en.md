# Contribute

## About Branches

- **master** Product Release Same as GooglePlay
- **master-HMS** Product Release Same as AppGallery
- **pre** Pre-release Major feature additions or Google Play review
- **pre-HMS** Pre-release AppGallery review
- **develop** Development version PullRequest goes here

## Translation

- [Issues](/issues/new?assignees=&labels=bug&template=translation-error.yml)
- [lib/l10n](/develop/lib/l10n)

### icon

The current app icon is temporary  
We are currently accepting applications

## Setup

```shell
flutter pub get
```

## Build

```shell
flutter run
```

### HMS

```shell
flutter run --no-sound-null-safety
```

`lib/init_hms.dart` is required.

```dart
// ignore_for_file: import_of_legacy_library_into_null_safe

// Package imports:
import 'package:agconnect_core/agconnect_core.dart';

Future<void> initHMS() async {
  await AGCApp.instance.setClientId('client_id');
  await AGCApp.instance.setClientSecret('client_secret');
  await AGCApp.instance.setApiKey('api_key');
}
```
