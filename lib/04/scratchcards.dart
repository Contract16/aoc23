import 'dart:io';
import 'dart:math';

import 'package:aoc23/reader/file_reader.dart';
import 'package:args/args.dart';

final _splitRegex = RegExp(r':|\|');

void main(List<String> arguments) {
  exitCode = 0;
  final parser = ArgParser();

  ArgResults argResults = parser.parse(arguments);
  final paths = argResults.rest;

  stdout.writeln('paths: $paths');

  _part1(paths);
}

void _part1(List<String> paths) => FileReader.read(
      paths: paths,
      onFileOpened: (lines) async {
        num total = 0;
        await for (final line in lines) {
          final (_, winningNumbers) = parse(line);
          if (winningNumbers.isEmpty) continue;

          total += pow(2, winningNumbers.length - 1);
        }

        stdout.writeln(total);
      },
    );

(int cardNumber, Iterable<int> winningNumbers) parse(String line) {
  final parts = line.split(_splitRegex);
  final int cardNumber = int.parse(parts.first.split((' ')).last);
  final ticketNumbers = parts[1]
      .split(' ')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toSet();
  final entryNumbers = parts.last
      .split(' ')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toSet();

  final winningNumbers =
      ticketNumbers.intersection(entryNumbers).map((e) => int.parse(e));

  return (cardNumber, winningNumbers);
}
