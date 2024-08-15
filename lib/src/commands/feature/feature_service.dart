import 'package:injil_cli/src/utils/project_location_util.dart';
import 'package:mason_logger/mason_logger.dart';

class FeatureService {
  FeatureService(this._locationUtils, this._logger);

  final ProjectLocationUtil _locationUtils;
  final Logger _logger;

  final Map<String, dynamic> folderStructure = {
    'config': {
      'di': null,
      'navigation': null,
    },
    'data': {
      'repositories': null,
      'models': null,
    },
    'domain': {
      'repositories': null,
      'models': null,
    },
    'presentation': {
      'bloc': null,
      'screens': null,
      'widgets': null,
    },
  };

  String get featuresPath => 'lib/src/features';

  Future<int> createFeature(String featureName) async {
    final isExists = await _locationUtils.isPathExists(featuresPath);
    if (!isExists) {
      await _locationUtils.createPath(featuresPath);
    }

    await _createStructure(featureName);

    var output = 'Feature $featureName created successfully';
    output = lightYellow.wrap(output)!;
    _logger.info(output);

    return ExitCode.success.code;
  }

  Future<void> _createStructure(String featureName) async {
    final featurePath = '$featuresPath/$featureName';
    final isExists = await _locationUtils.isPathExists(featurePath);
    if (!isExists) {
      await _locationUtils.createPath(featurePath);
    }

    for (final folder in folderStructure.keys) {
      await _createFolders(featurePath, folder, folderStructure);
    }
  }

  Future<void> _createFolders(
    String path,
    String folder,
    Map<String, dynamic> folderStructure,
  ) async {
    final folderPath = '$path/$folder';
    await _locationUtils.checkAndCreateFolder(folderPath);
    if (folderStructure[folder] != null) {
      final subFolders = folderStructure[folder] as Map<String, dynamic>;
      for (final subFolder in subFolders.keys) {
        await _createFolders(folderPath, subFolder, subFolders);
      }
    }
  }

// Future<void> _createFiles({
//   required String featureName,
//   required String path,
//   required String templateURL,
// }) async {
//   final githubUrl = templateURL;
//   try {
//     final response = await http.get(Uri.parse(githubUrl));
//
//     if (response.statusCode == 200) {
//       final fileContent = response.body;
//       print(fileContent);
//       await _locationUtils.createFile(
//         path,
//         fileContent,
//       );
//     } else {
//       print('Failed to load file from GitHub. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error loading file from GitHub: $e');
//   }
// }
}
