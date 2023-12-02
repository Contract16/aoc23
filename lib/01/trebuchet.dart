import 'dart:io';

import 'package:aoc23/reader/file_reader.dart';
import 'package:args/args.dart';

const part = 'part';

void main(List<String> arguments) {
  exitCode = 0;
  final parser = ArgParser()..addOption(part, mandatory: true, abbr: 'p');

  ArgResults argResults = parser.parse(arguments);
  final paths = argResults.rest;

  final p = int.parse(argResults[part]);

  if (p == 1) {
    _part1(paths);
  } else {
    _part2(paths);
  }
}

void _part1(List<String> paths) => FileReader.read(
      paths: paths,
      onFileOpened: (lines) async {
        int result = 0;
        await for (final line in lines) {
          var digits = line.replaceAll(RegExp('[^\\d]'), '');
          result += int.parse('${digits[0]}${digits[digits.length - 1]}');
        }
        stdout.writeln(result);
      },
    );

void _part2(List<String> paths) => FileReader.read(
      paths: paths,
      onFileOpened: (lines) async {
        int result = 0;
        var regex = RegExp(
          '(?=(${['\\d', ..._nums.keys].join('|')}))',
          caseSensitive: false,
        );
        await for (final line in lines) {
          final matches = regex.allMatches(line);
          final first = int.tryParse(matches.first[1].toString()) ??
              _nums[matches.first[1]];
          final last = int.tryParse(matches.last[1].toString()) ??
              _nums[matches.last[1]];
          result += int.parse('$first$last');
        }
        stdout.writeln(result);
      },
    );

Map<String, int> get _nums => {
      'zero': 0,
      'one': 1,
      'two': 2,
      'three': 3,
      'four': 4,
      'five': 5,
      'six': 6,
      'seven': 7,
      'eight': 8,
      'nine': 9
    };
