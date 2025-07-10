import 'dart:io';
import 'package:almaviva_cli/helpers/colors.dart';

Future<void> handleLocalizationGenerateCommand() async {
  const command = 'flutter';
  const arguments = [
    'pub', 'run', 'easy_localization:generate',
    '-S', 'assets/translations',
    '-f', 'keys',
    '-O', 'lib/src/core/l10n',
    '-o', 'locale_keys.g.dart',
  ];

  print(Colors.coloredHeader('🌍 Generating localization files...'));
  print(Colors.coloredCommand('Command: $command ${arguments.join(' ')}'));
  print(Colors.coloredDescription('Parameters:'));
  print(Colors.coloredOptions('  -S assets/translations'));
  print(Colors.coloredOptions('  -f keys'));
  print(Colors.coloredOptions('  -O lib/src/core/l10n'));
  print(Colors.coloredOptions('  -o locale_keys.g.dart'));
  print('');

  final process = await Process.start(command, arguments, runInShell: true);
  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);
  final exitCode = await process.exitCode;
  if (exitCode == 0) {
    print(Colors.coloredHeader('\n✅ Localization files generated successfully!'));
  } else {
    print(Colors.coloredError('\n❌ Failed to generate localization files.'));
    exit(exitCode);
  }
} 