# translations_keychain

`translations_keychain` is a small Dart builder that converts the local JSON files used for translations into a Dart abstract class.

When `translations_keychain` is running in watch mode, you could simply edit your JSON file and the abstract class will be automatically updated.

### Features

- [x] Merges all JSON keys in one single file
- [x] Supports for nested JSON objects for grouped labels
- [x] Sorts the final class properties
- [x] Use UpperCamelCase for class name and snake_case for file name

## Getting Started

### Install

Add this to your package's pubspec.yaml file:

```yaml
dev_dependencies:
  # stable version install from https://pub.dev/packages
  translations_keychain: <last_version>
  build_runner: ^1.8.1

  # Dev version install from git REPO
  translations_keychain:
    git: https://github.com/lcaprini/translations_keychain.git
```

### Configure

By default `translations_keychain` scans every JSON file into the `/assets/langs` directory and generates the `translations_keychain.dart` file into `/lib/i18n`
directory.

If you want to change the default behaviour you could create or update the `build.yaml` file of your project with:

```yaml
targets:
  $default:
    builders:
      translations_keychain:
        options:
          path: <langs_assets_directory>
          output: <output_directory>
          class_name: <class_and_file_name>
```

### Use with Dart

With `build_runner` installed, you could semply launch the `build` task

```bash
pub run build_runner build --delete-conflicting-outputs
```

or launch in `watch` mode if you want to update the final class file automagically.

```bash
pub run build_runner watch --delete-conflicting-outputs
```

### Use with Flutter

Of course this package could be used also in a flutter app; the `build_runner` tasks became:

```bash
flutter pub run build_runner build --delete-conflicting-outputs

flutter pub run build_runner watch --delete-conflicting-outputs
```

### Example

The following files in `/assets/langs` directory

```JSON
assets/langs/it.json
{
    "HELLO": "Hi!",
    "ERROR": {
        "WRONG_USERNAME": "Wrong username",
        "WRONG_PASSWORD": "Wrong password"
    },
    "OTHER_LABEL": "Only in english"
}
```

```JSON
assets/langs/en.json
{
    "HELLO": "Ciao!",
    "ERROR": {
        "WRONG_USERNAME": "Username errato",
        "WRONG_PASSWORD": "Password errata"
    }
}
```

became the `translations_keychain.dart` file in `/lib/i18n`

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// TranslationsKeychain
// **************************************************************************

abstract class TranslationsKeychain {
  static const ERROR_WRONG_PASSWORD = 'ERROR.WRONG_PASSWORD';
  static const ERROR_WRONG_USERNAME = 'ERROR.WRONG_USERNAME';
  static const HELLO = 'HELLO';
  static const OTHER_LABEL = 'OTHER_LABEL';
}
```
