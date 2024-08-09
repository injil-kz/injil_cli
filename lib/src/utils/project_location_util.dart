import 'dart:io';

class ProjectLocationUtil {
  Future<bool> isProjectRoot() async {
    final currentDir = Directory.current;
    final pubspecExists = await File('${currentDir.path}/pubspec.yaml').exists();
    final libDirExists = await Directory('${currentDir.path}/lib').exists();

    return pubspecExists && libDirExists;
  }
}
