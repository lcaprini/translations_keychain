import 'dart:async';
import 'dart:convert';

import 'package:glob/glob.dart';
import 'package:build/build.dart';
import 'package:path/path.dart' as p;

import '../builder.dart';

class I18nGenerator implements Builder {
  final I18nGeneratorConfig config;

  I18nGenerator({
    this.config,
  });

  @override
  FutureOr<void> build(
    BuildStep buildStep,
  ) async {
    try {
      Glob _allTranslationsFiles = _getAllTranslationFiles(config);

      final Map<String, dynamic> translations = {};

      await for (final input in buildStep.findAssets(_allTranslationsFiles)) {
        // Reads original translation file as String
        final String file = await buildStep.readAsString(input);

        // Adds the translations to the list
        translations..addAll(json.decode(file));
      }
      // Expands the Map into one level Map
      final expandedTranslations = _extractTranslations(translations);

      // Converts the Map into a static class
      final dartFileAsString = _createTranslationFile(expandedTranslations);

      // Writes the dart file into project
      final outputFile = _getOutputFile(buildStep);
      return buildStep.writeAsString(outputFile, dartFileAsString);
    } catch (e) {
      print(e.toString());
    }
  }

  /// Extracts all translations key in a recursive way
  Map<String, String> _extractTranslations(
    Map<String, dynamic> block, {
    List<String> prefix = const [],
  }) {
    final Map<String, String> extracted = {};

    block.forEach((key, value) {
      final newPrefix = List<String>.from(prefix)..add(key);

      // Writes the final key and value for translation
      if (value is String) {
        extracted[newPrefix.join('_')] = newPrefix.join('.');
      }

      // Extracts the translations from inner JSON
      else if (value is Map) {
        final expandedTranslations = _extractTranslations(value, prefix: newPrefix);
        extracted.addAll(expandedTranslations);
      }
    });
    return extracted;
  }

  String _createTranslationFile(Map<String, dynamic> translations) {
    String file = '''
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// I18nGenerator
// **************************************************************************

abstract class Translations {
''';
    final sortedKeys = translations.keys.toList()..sort();

    sortedKeys.forEach((key) {
      file += '  static const $key = \'${translations[key]}\';\n';
    });

    file += '}\n';

    return file;
  }

  /// Writes a single dart file with all expandedn translations
  AssetId _getOutputFile(
    BuildStep buildStep,
  ) {
    return AssetId(
      buildStep.inputId.package,
      p.join(config.output, '${config.className}.dart'),
    );
  }

  /// Reads all JSON file into [config.path]
  Glob _getAllTranslationFiles(
    I18nGeneratorConfig config,
  ) {
    return Glob('${config.path}/**.json');
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$package$': ['${config.output}/${config.className}.dart'],
      };
}
