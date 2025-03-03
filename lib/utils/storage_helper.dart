import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageHelper {
  static Future<String> getFilePath(String type) async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/${type}_${DateTime.now().millisecondsSinceEpoch}.aac";
  }

  static Future<void> saveFile(String filePath, String type) async {
    final newPath = await getFilePath(type);
    File(filePath).copySync(newPath);
    print("📁 Arquivo salvo em: $newPath");
  }

  static Future<void> saveTestFile(String filename, String content) async {
    final directory = Directory("Testes/");
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    final file = File("${directory.path}/$filename");
    file.writeAsStringSync(content);
    print("📁 Arquivo salvo em Testes/: ${file.path}");
  }
}
