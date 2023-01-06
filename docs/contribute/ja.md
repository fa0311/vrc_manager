# 貢献

## ブランチについて

- **master** プロダクトリリース GooglePlay と同じ
- **master-HMS** プロダクトリリース AppGallery と同じ
- **pre** プレリリース 大きな機能追加もしくは GooglePlay の審査
- **pre-HMS** プレリリース AppGallery の審査
- **develop** 開発バージョン PullRequest はここへ

## 翻訳

- [Issues](https://github.com/fa0311/vrc_manager/issues/new?assignees=&labels=bug&template=translation-error.yml)
- [lib/l10n](../../lib/l10n)

### アイコン

現在のアプリアイコンは仮のものです  
募集中です

## セットアップ

```shell
flutter pub get
```

## ビルド

```shell
flutter run
```

### HMS

```shell
flutter run --no-sound-null-safety
```

`lib/init_hms.dart` が必要です

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
