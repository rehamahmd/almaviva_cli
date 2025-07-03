import 'dart:io';

import 'package:almaviva_cli/helpers/colors.dart';

void showVersion() {
  
  final version = File('pubspec.yaml')
      .readAsStringSync()
      .split('\n')
      .firstWhere((line) => line.contains('version:'))
      .split(':')[1]
      .trim();
  print('almaviva CLI version: v${Colors.coloredCommand(version)}');
}