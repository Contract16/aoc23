import 'dart:convert';
import 'dart:io';

class FileReader {
  static Future<void> read(
      {required List<String> paths,
      required Function(Stream<String> lines) onFileOpened}) async {
    if (paths.isEmpty) {
      await stdin.pipe(stdout);
    } else {
      for (final path in paths) {
        final lines = utf8.decoder
            .bind(File(path).openRead())
            .transform(const LineSplitter());
        try {
          onFileOpened(lines);
        } catch (_) {
          await _handleError(path);
        }
      }
    }
  }

  static Future<void> _handleError(String path) async {
    if (await FileSystemEntity.isDirectory(path)) {
      stderr.writeln('error: $path is a directory');
    } else {
      exitCode = 2;
    }
  }
}
