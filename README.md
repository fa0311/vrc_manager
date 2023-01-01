# VRCManager

VRChat の非公式な API を利用した VRChat のモバイルクライアント<br>
Flutter で作成されたシンプルな UI が特徴的です<br>

## <!> Updates from v3.x.x to v4.0.0 are not automatic.
Download the latest app from [release](https://github.com/fa0311/vrc_manager/releases).

## 特徴

- **マルチプラットフォーム** Android Windows(iOS 用の PullRequest Build は歓迎します)
- **多言語対応**
- **広告無し**
- **完全無料**
- **オープンソース**

<img width="20%" src="docs/img/screenshots1.png"><img width="20%" src="docs/img/screenshots2.png"><img width="20%" src="docs/img/screenshots3.png"><img width="20%" src="docs/img/screenshots4.png"><img width="20%" src="docs/img/screenshots5.png">

## インストール

### Android

[**play.google.com**](https://play.google.com/store/apps/details?id=com.yuki0311.vrc_manager)からダウンロード<br>
[**appgallery.huawei.com**](https://appgallery.huawei.com/#/app/C106854219)からダウンロード<br>

もしくは
[**Releases**](https://github.com/fa0311/vrc_manager/releases)の**app-release.apk**をクリックしてダウンロード

### Windows

[**Releases**](https://github.com/fa0311/vrc_manager/releases)の**VRCManager-Setup.exe**をクリックしてダウンロード

## 貢献

### ブランチについて

- **master** プロダクトリリース GooglePlay と同じ
- **master-HMS** プロダクトリリース AppGallery と同じ
- **pre** プレリリース 大きな機能追加もしくは GooglePlay の審査
- **pre-HMS** プレリリース AppGallery の審査
- **develop** 開発バージョン PullRequest はここへ

### 翻訳

[lib/l10n](https://github.com/fa0311/vrc_manager/tree/develop/lib/l10n)

### セットアップ

```
flutter pub get
```

### ビルド

```
flutter run
```

#### HMS

```
flutter run --no-sound-null-safety
```

`lib/init_hms.dart` が必要です

```lib/init_hms.dart
// ignore_for_file: import_of_legacy_library_into_null_safe

// Package imports:
import 'package:agconnect_core/agconnect_core.dart';

Future<void> initHMS() async {
  await AGCApp.instance.setClientId('client_id');
  await AGCApp.instance.setClientSecret('client_secret');
  await AGCApp.instance.setApiKey('api_key');
}
```

## 免責事項

VRChat API の使用に関する VRChat チーム(Tupper 氏)の公式な回答です。

> Use of the API using applications other than the approved methods (website, VRChat application) are not officially supported. You may use the API for your own application, but keep these guidelines in mind:
>
> - We do not provide documentation or support for the API.
> - Do not make queries to the API more than once per 60 seconds.
> - Abuse of the API may result in account termination.
> - Access to API endpoints may break at any given time, with no warning.
