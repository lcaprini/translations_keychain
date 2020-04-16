library i18n_generator;

import 'package:build/build.dart';
import 'package:i18n_generator/src/i18n_generator.dart';

const String _defaultPath = 'assets/langs';
const String _defaultOutput = 'lib/src';
const String _defaultClassName = 'Translations';

/// Configuration object for builder
class I18nGeneratorConfig {
  /// Folder which contains all JSON translations
  final String path;

  /// Output folder where put the final .dart file
  final String output;

  /// Name for the final class
  ///
  /// Also used for file name
  final String className;

  I18nGeneratorConfig({
    this.path = _defaultPath,
    this.output = _defaultOutput,
    this.className = _defaultClassName,
  });

  factory I18nGeneratorConfig.fromJson(Map<String, dynamic> json) => I18nGeneratorConfig(
        path: json['path'] ??= _defaultPath,
        output: json['output'] ??= _defaultOutput,
        className: json['class_name'] ??= _defaultClassName,
      );
}

Builder i18nGenerator(BuilderOptions options) {
  try {
    return I18nGenerator(config: I18nGeneratorConfig.fromJson(options.config));
  } catch (e) {
    throw e;
  }
}
