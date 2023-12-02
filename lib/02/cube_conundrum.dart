import 'dart:io';
import 'dart:math';

import 'package:aoc23/reader/file_reader.dart';
import 'package:args/args.dart';

final _part = 'part';

final _gameRegex = RegExp('Game\\s\\d{1,}');
final _colorsRegex = RegExp(
  '\\d{1,}\\s(blue|red|green)',
  caseSensitive: false,
);

void main(List<String> arguments) {
  exitCode = 0;
  final parser = ArgParser()
    ..addMultiOption('bag', abbr: 'b')
    ..addOption(_part, mandatory: true, abbr: 'p');

  ArgResults argResults = parser.parse(arguments);
  final paths = argResults.rest;

  final p = int.parse(argResults[_part]);

  if (p == 1) {
    final bag = argResults['bag'];
    if (bag.isEmpty ||
        bag.length != 3 ||
        bag.any((c) => int.tryParse(c) == null)) {
      stderr.writeln('Please provide 3 numbers');
      exitCode = 1;
      return;
    }
    _part1(paths, bag.map<int>((c) => int.parse(c)).toList());
  } else {
    _part2(paths);
  }
}

void _part1(List<String> paths, List<int> bag) => FileReader.read(
      paths: paths,
      onFileOpened: (lines) async {
        int total = 0;
        await for (final line in lines) {
          final parsed = parse(line);
          if (parsed.red <= bag[0] &&
              parsed.green <= bag[1] &&
              parsed.blue <= bag[2]) {
            total += parsed.id;
          }
        }
        stdout.writeln(total);
      },
    );

void _part2(List<String> paths) => FileReader.read(
      paths: paths,
      onFileOpened: (lines) async {
        int total = 0;
        await for (final line in lines) {
          final parsed = parse(line);

          total += parsed.red * parsed.green * parsed.blue;
        }
        stdout.writeln(total);
      },
    );

({int id, int red, int green, int blue}) parse(String line) {
  int red = 0;
  int green = 0;
  int blue = 0;

  final matches = _colorsRegex.allMatches(line);

  for (final match in matches) {
    final split = match[0]?.split(' ') ?? [];
    if (split.isEmpty) continue;

    final amount = int.tryParse(split.first) ?? 0;
    final color = split.last;
    if (color == 'red') {
      red = max(red, amount);
    } else if (color == 'green') {
      green = max(green, amount);
    } else if (color == 'blue') {
      blue = max(blue, amount);
    }
  }
  final game = _gameRegex.firstMatch(line);
  int id = int.tryParse(game?.group(0)?.split(' ').last ?? '') ?? 0;

  return (id: id, red: red, green: green, blue: blue);
}
