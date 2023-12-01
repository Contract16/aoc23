import 'dart:io';

import 'package:aoc23/reader/file_reader.dart';
import 'package:args/args.dart';

void main(List<String> arguments) {
  exitCode = 0;
  final parser = ArgParser();

  ArgResults argResults = parser.parse(arguments);
  final paths = argResults.rest;

  FileReader.read(
    paths: paths,
    onFileOpened: (lines) async {
      int result = 0;
      await for (final line in lines) {
        var digits = line.replaceAll(RegExp(r'[^\d]'), '');
        result += int.parse('${digits[0]}${digits[digits.length - 1]}');
      }
      stdout.writeln(result);
    },
  );
}
