library example;

import 'package:example/i18n/translations_keychain.dart';

void main() {
  // Simple label
  print(TranslationsKeychain.HELLO);

  // Label with numbers
  print(TranslationsKeychain.A_123);

  // Label with spaces
  print(TranslationsKeychain.LABEL_WITH_SPACES);

  // Label with symbols
  print(TranslationsKeychain.LABEL_WITH_SYMBOLS);

  // Label with pluralization with [easy_localization] package
  // print(TranslationsKeychain.CLICKED.plural(counter));
}
