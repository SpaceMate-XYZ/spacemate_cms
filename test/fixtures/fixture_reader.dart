import 'dart:io';
import 'package:path/path.dart' as path;

String fixture(String name) {
  final currentDirectory = Directory.current.path;
  final fixturePath = path.join(currentDirectory, 'test', 'fixtures', name);
  return File(fixturePath).readAsStringSync();
}
