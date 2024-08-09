// ignore_for_file: avoid_slow_async_io

import 'dart:io';

class ProjectLocationUtil {
  Future<bool> isProjectRoot() async {
    final currentDir = Directory.current;
    final pubspecExists = await File('${currentDir.path}/pubspec.yaml').exists();
    final libDirExists = await Directory('${currentDir.path}/lib').exists();

    return pubspecExists && libDirExists;
  }

  Future<void> createPath(String featuresPath) async {
    await Directory(featuresPath).create(recursive: true);
  }

  Future<bool> isPathExists(String featuresPath) {
    return Directory(featuresPath).exists();
  }
}
