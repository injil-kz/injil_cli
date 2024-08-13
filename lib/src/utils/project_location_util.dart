// ignore_for_file: avoid_slow_async_io

import 'dart:io';

class ProjectLocationUtil {
  Future<bool> isProjectRoot() async {
    final currentDir = Directory.current;
    final pubspecExists = await File('${currentDir.path}/pubspec.yaml').exists();
    final libDirExists = await Directory('${currentDir.path}/lib').exists();

    return pubspecExists && libDirExists;
  }

  Future<void> checkAndCreateFolder(String path) async {
    final isExists = await isPathExists(path);
    if (!isExists) {
      await createPath(path);
    }
  }

  Future<void> createPath(String featuresPath) async {
    await Directory(featuresPath).create(recursive: true);
  }

  // create file at path
  Future<void> createFile(String path, String content) async {
    await File(path).writeAsString(content);
  }

  Future<bool> isPathExists(String featuresPath) {
    return Directory(featuresPath).exists();
  }
}
