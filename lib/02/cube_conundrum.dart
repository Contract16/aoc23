import 'dart:io';
import 'dart:math';

import 'package:aoc23/reader/file_reader.dart';
import 'package:args/args.dart';

void main(List<String> arguments) {
  exitCode = 0;
  final parser = ArgParser()..addMultiOption('bag', abbr: 'b');

  ArgResults argResults = parser.parse(arguments);
  final paths = argResults.rest;
  final bag = argResults['bag'];
  if (bag.isEmpty ||
      bag.length != 3 ||
      bag.any((c) => int.tryParse(c) == null)) {
    stderr.writeln('Please provide 3 numbers');
    exitCode = 1;
    return;
  }

  _part1(paths, bag.map<int>((c) => int.parse(c)).toList());
}

void _part1(List<String> paths, List<int> bag) => FileReader.read(
      paths: paths,
      onFileOpened: (lines) async {
        var gameRegex = RegExp('Game\\s\\d{1,}');
        var colorsRegex = RegExp(
          '\\d{1,}\\s(blue|red|green)',
          caseSensitive: false,
        );
        int total = 0;
        await for (final line in lines) {
          int red = 0;
          int green = 0;
          int blue = 0;

          final matches = colorsRegex.allMatches(line);

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

          if (red <= bag[0] && green <= bag[1] && blue <= bag[2]) {
            final game = gameRegex.firstMatch(line);
            int gameNumber =
                int.tryParse(game?.group(0)?.split(' ').last ?? '') ?? 0;
            total += gameNumber;
          }
        }
        stdout.writeln(total);
      },
    );
