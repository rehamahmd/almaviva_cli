import 'dart:io';
import 'package:almaviva_cli/helpers/colors.dart';

Future<void> handleLocalizationGenerateCommand(List<String> userArgs) async {
  // Default parameters
  String source = 'assets/translations';
  const String format = 'keys'; // Now static
  String outputDir = 'lib/src/core/l10n';
  String outputFile = 'locale_keys.g.dart';

  // If user provided args, try to parse them (ignore -f)
  if (userArgs.isNotEmpty) {
    for (int i = 0; i < userArgs.length; i++) {
      switch (userArgs[i]) {
        case '-S':
          if (i + 1 < userArgs.length) source = userArgs[i + 1];
          break;
        case '-O':
          if (i + 1 < userArgs.length) outputDir = userArgs[i + 1];
          break;
        case '-o':
          if (i + 1 < userArgs.length) outputFile = userArgs[i + 1];
          break;
        // Ignore -f and its value
      }
    }
  }

  print(Colors.coloredHeader('🌍 Localization Generation Parameters:'));
  stdout.write('Source directory [-S] [${Colors.coloredOptions(source)}]: ');
  String? input = stdin.readLineSync();
  if (input != null && input.trim().isNotEmpty) source = input.trim();

  // Format is static, do not prompt

  stdout.write('Output directory [-O] [${Colors.coloredOptions(outputDir)}]: ');
  input = stdin.readLineSync();
  if (input != null && input.trim().isNotEmpty) outputDir = input.trim();

  stdout.write('Output file [-o] [${Colors.coloredOptions(outputFile)}]: ');
  input = stdin.readLineSync();
  if (input != null && input.trim().isNotEmpty) outputFile = input.trim();

  final arguments = [
    'pub', 'run', 'easy_localization:generate',
    '-S', source,
    '-f', format,
    '-O', outputDir,
    '-o', outputFile,
  ];
  const command = 'flutter';

  print(Colors.coloredHeader('\n🌍 Generating localization files...'));
  print(Colors.coloredCommand('Command: $command ${arguments.join(' ')}'));
  print(Colors.coloredDescription('Parameters:'));
  print(Colors.coloredOptions('  -S $source'));
  print(Colors.coloredOptions('  -O $outputDir'));
  print(Colors.coloredOptions('  -o $outputFile'));
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