// ignore_for_file: lines_longer_than_80_chars

import 'package:args/command_runner.dart';
import 'package:injil_cli/src/commands/feature/feature_service.dart';
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
    required FeatureService featureService,
  })  : _logger = logger,
        _locationUtils = locationUtils,
        _featureService = featureService {
    argParser.addOption(
      'name',
      help: 'Name of the feature',
    );
  }

  @override
  String get description => 'Creates a new feature folders structure';

  @override
  String get name => 'feature';

  final Logger _logger;
  final ProjectLocationUtil _locationUtils;
  final FeatureService _featureService;

  @override
  Future<int> run() async {
    final featureName = argResults?['name'];
    if (featureName == null) {
      _logger.info(
          '${red.wrap('Feature name is required, example:') ?? ''}\n${lightCyan.wrap('inj feature name=Auth') ?? ''}');
      return ExitCode.success.code;
    }
    final isRoot = await _locationUtils.isProjectRoot();
    if (isRoot) {
      return _featureService.createFeature(featureName.toString());
    } else {
      _logger.err('Not a project root');
    }
    return ExitCode.success.code;
  }
}
