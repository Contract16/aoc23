import 'dart:io';
import 'dart:math';

import 'package:aoc23/reader/file_reader.dart';
import 'package:args/args.dart';

const _part = 'part';

void main(List<String> arguments) {
  exitCode = 0;
  final parser = ArgParser()..addOption(_part, mandatory: true, abbr: 'p');

  ArgResults argResults = parser.parse(arguments);
  final paths = argResults.rest;

  _part1(paths);
}

void _part1(List<String> paths) => FileReader.read(
      paths: paths,
      onFileOpened: (lines) async {
        List<List<String>> matrix = [];
        matrix.addAll({await for (var line in lines) line.split('')});

        final rows = matrix.length;
        final columns = matrix.first.length;

        int total = 0;
        for (int y = 0; y < rows; y++) {
          bool found = false;

          int x = 0;
          while (x < columns) {
            final char = matrix[y][x];

            int? parsedNum = int.tryParse(char);

            if (parsedNum == null) {
              found = false;
              x++;
              continue;
            }

            if (found) {
              x++;
              continue;
            }

            int startY = max(y - 1, 0);
            int toY = min(y + 1, rows - 1);

            int startX = max(x - 1, 0);
            int toX = x;

            StringBuffer fullNumberBuilder = StringBuffer();

            while (toX < columns && int.tryParse(matrix[y][toX]) != null) {
              fullNumberBuilder.write(matrix[y][toX]);
              toX++;
              x++;
            }
            toX = min(toX, columns - 1);

            int fullNumber = int.parse(fullNumberBuilder.toString());

            int currentY = startY;
            while (currentY <= toY && !found) {
              int currentX = startX;
              while (currentX <= toX && !found) {
                if (currentY == y && currentX > startX && currentX < toX) {
                  currentX++;
                  continue;
                }

                final adjacentChar = matrix[currentY][currentX];
                if (int.tryParse(adjacentChar) == null && adjacentChar != '.') {
                  found = true;
                }
                currentX++;
              }
              currentY++;
            }

            if (found) {
              total += fullNumber;
            }
          }
        }

        stdout.writeln('total: $total');
      },
    );
