### Example

In this example the two files in `/assets/langs` directory

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

will be parsed and the `translations_keychain.dart` file in `/lib/i18n` will be generated.

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

So you could avoid to write the translation's label by hand, but you could use it with:

```dart
void main() {
  print(TranslationsKeychain.HELLO);
}
```
