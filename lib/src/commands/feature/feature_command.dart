// ignore_for_file: lines_longer_than_80_chars

import 'dart:developer';

import 'package:args/command_runner.dart';
import 'package:http/http.dart' as http;
import 'package:injil_cli/src/services/templates_storage.dart';
import 'package:injil_cli/src/utils/project_location_util.dart';
import 'package:mason_logger/mason_logger.dart';

/// {@template sample_command}
///
/// `inj sample`
/// A [Command] to exemplify a sub command
/// {@endtemplate}
class FeatureCommand extends Command<int> {
  /// {@macro sample_command}
  FeatureCommand({
    required Logger logger,
    required ProjectLocationUtil locationUtils,
  })  : _logger = logger,
        _locationUtils = locationUtils {
    _templatesStorage = TemplatesStorage();
    argParser.addOption(
      'name',
      help: 'Name of the feature',
    );
  }

  @override
  String get description => 'Creates a new feature folders structure';

  @override
  String get name => 'feature';

  final featuresPath = 'lib/src/features';
  final featureFolders = [
    'config',
    'data',
    'domain',
    'presentation',
  ];
  final Logger _logger;
  final ProjectLocationUtil _locationUtils;
  late final TemplatesStorage _templatesStorage;

  @override
  Future<int> run() async {
    final featureName = argResults?['name'];
    if (featureName == null) {
      _logger.info('${red.wrap('Feature name is required, example:') ?? ''}\n${lightCyan.wrap('inj feature name=Auth') ?? ''}');
      return ExitCode.success.code;
    }
    final isRoot = await _locationUtils.isProjectRoot();
    if (isRoot) {
      return _createFeature(featureName.toString());
    } else {
      _logger.err('Not a project root');
    }
    return ExitCode.success.code;
  }

  Future<int> _createFeature(String featureName) async {
    final isExists = await _locationUtils.isPathExists(featuresPath);
    if (!isExists) {
      await _locationUtils.createPath(featuresPath);
    }

    await _createFolders(featureName);
    await _createFiles(featureName);

    var output = 'Feature $featureName created successfully';
    output = lightYellow.wrap(output)!;
    _logger.info(output);

    return ExitCode.success.code;
  }

  Future<void> _createFolders(String featureName) async {
    for (final folder in featureFolders) {
      await _locationUtils.createPath('$featuresPath/$featureName/$folder');
    }
  }

  Future<void> _createFiles(String featureName) async {
    final githubUrl = _templatesStorage.repositoryTemplate;
    try {
      debugger();
      final response = await http.get(Uri.parse(githubUrl));

      if (response.statusCode == 200) {
        final fileContent = response.body;
        debugger();
        // Process the file content as needed
        print(fileContent);
      } else {
        print('Failed to load file from GitHub. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading file from GitHub: $e');
    }
  }
}
