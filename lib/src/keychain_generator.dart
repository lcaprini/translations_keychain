import 'dart:async';
import 'dart:convert';

import 'package:glob/glob.dart';
import 'package:build/build.dart';
import 'package:path/path.dart' as p;

import '../translations_keychain.dart';

class KeychainGenerator implements Builder {
  final KeychainConfig config;

  KeychainGenerator({
    this.config,
  });

  @override
  FutureOr<void> build(
    BuildStep buildStep,
  ) async {
    try {
      final Glob _allTranslationsFiles = _getAllTranslationFiles(config);

      final Map<String, dynamic> translations = {};

      await for (final input in buildStep.findAssets(_allTranslationsFiles)) {
        // Reads original translation file as String
        final String file = await buildStep.readAsString(input);

        // Adds the translations to the list
        translations.addAll(json.decode(file));
      }
      // Expands the Map into one level Map
      final expandedTranslations = _extractTranslations(translations);

      // Converts the Map into a static class
      final dartFileAsString = _buildTranslationsFile(expandedTranslations);

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
      final finalKey = _buildPropertyName(newPrefix);
      extracted[finalKey] = newPrefix.join('.');

      // Extracts the translations from inner JSON
      if (value is Map) {
        final expandedTranslations = _extractTranslations(value, prefix: newPrefix);

        extracted.addAll(expandedTranslations);
      }
    });
    return extracted;
  }

  /// Create the final property name
  String _buildPropertyName(List<String> prefix) {
    // Replace all symbols with underscore
    final prefixKeys = prefix.map((p) => p.replaceAll(RegExp(r'[^\w]'), '_')).toList();
    try {
      // If the first char of key is a number, add A_ prefix
      int.parse(prefixKeys[0][0]);
      prefixKeys[0] = 'A_${prefixKeys[0]}';
    } catch (e) {}
    // Join all prefix in one string
    return prefixKeys.join('_');
  }

  /// Create the final abstract class text
  String _buildTranslationsFile(Map<String, dynamic> translations) {
    String file = '''
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Translations Keychain Generator
// **************************************************************************

abstract class ${config.className} {
''';
    final sortedKeys = translations.keys.toList()..sort();

    for (final key in sortedKeys) {
      file += '  static const $key = \'${translations[key]}\';\n';
    }

    file += '}\n';

    return file;
  }

  /// Writes a single dart file with all expandedn translations
  AssetId _getOutputFile(
    BuildStep buildStep,
  ) {
    return AssetId(
      buildStep.inputId.package,
      p.join(config.output, '${config.fileName}.dart'),
    );
  }

  /// Reads all JSON file into [config.path]
  Glob _getAllTranslationFiles(
    KeychainConfig config,
  ) {
    return Glob('${config.path}/**.json');
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$package$': ['${config.output}/${config.fileName}.dart']
      };
}
