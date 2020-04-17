library translations_keychain;

import 'package:basic_utils/basic_utils.dart';
import 'package:build/build.dart';

import 'src/keychain_generator.dart';

const String _defaultPath = 'assets/langs';
const String _defaultOutput = 'lib/i18n';
const String _defaultClassName = 'TranslationsKeychain';

/// Configuration object for builder
class KeychainConfig {
  /// Folder which contains all JSON translations
  final String path;

  /// Output folder where put the final .dart file
  final String output;

  /// Name for the final class
  String className;

  /// File name for the final class
  String fileName;

  KeychainConfig({
    this.path = _defaultPath,
    this.output = _defaultOutput,
    className = _defaultClassName,
  }) {
    this.className = className.replaceAll(RegExp(r'\s\b|\b\s'), '');
    fileName = StringUtils.camelCaseToLowerUnderscore(this.className);
  }

  factory KeychainConfig.fromJson(Map<String, dynamic> json) => KeychainConfig(
        path: json['path'] ??= _defaultPath,
        output: json['output'] ??= _defaultOutput,
        className: json['class_name'] ??= _defaultClassName,
      );
}

Builder keychainGenerator(BuilderOptions options) {
  try {
    return KeychainGenerator(config: KeychainConfig.fromJson(options.config));
  } catch (e) {
    rethrow;
  }
}
