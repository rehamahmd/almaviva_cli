import 'dart:convert';
import 'dart:io';

import 'package:almaviva_cli/helpers/colors.dart';
import 'package:args/args.dart';

import 'dart:async';


Future<void> handleRunCommand(ArgResults command) async {
  String env = await _selectFlavorInteractively();
  final deviceId = command['device-id'] as String?;
  final release = command['release'] as bool;
  final profile = command['profile'] as bool;

  if (release && profile) {
    print('Cannot use both --release and --profile flags together.');
    exit(1);
  }


  final targetPath = _getTargetPathForEnvironment(env);

  if (!File(targetPath).existsSync()) {
    print('Error: Target file "$targetPath" not found.');
    print('Please ensure the file exists at this location.');
    exit(1);
  }

  print('Starting Flutter app from $targetPath in $env environment...');

  final args = <String>['run', '--flavor', env, '-t', targetPath];
  if (deviceId != null) {
    args.addAll(['-d', deviceId]);
  }
  if (release) {
    args.add('--release');
  } else if (profile) {
    args.add('--profile');
  }

  try {
    print("flutter ${args.join(' ')}");
    print('Flutter Run  ${Colors.coloredCommand(args.join(' '))} ');

    await _runFlutterWithHotReload(args);
  } catch (e) {
    print('❌ Failed to run app: $e');
    exit(1);
  }
}

Future<void> _runFlutterWithHotReload(List<String> args) async {
  // Print help instructions

  final process = await Process.start('flutter', args);

  // Setup streams
  final stdoutStream = process.stdout.transform(utf8.decoder);
  final stderrStream = process.stderr.transform(utf8.decoder);

  // Listen to output streams
  stdoutStream.listen((data) => stdout.write(data));
  stderrStream.listen((data) => stderr.write(data));

  // Setup STDIN handling
  stdin.lineMode = false;
  stdin.echoMode = false;

  // Track the last key press time for multi-key sequences
  DateTime? lastKeyTime;
  String keyBuffer = '';

  stdin.listen((List<int> data) async {
    final input = String.fromCharCodes(data);
    final now = DateTime.now();

    // Handle quick successive key presses (like Shift+R)
    if (lastKeyTime != null && now.difference(lastKeyTime!) < Duration(milliseconds: 100)) {
      keyBuffer += input;
    } else {
      keyBuffer = input;
    }
    lastKeyTime = now;

    // Process the input after a short delay to catch multi-key sequences
    // await Future.delayed(Duration(milliseconds: 50), () {
      if (keyBuffer.toLowerCase().contains('r')) {
        if (keyBuffer.contains('R') || keyBuffer.toLowerCase() != keyBuffer) {
          // Hot restart for Shift+R or uppercase R
          process.stdin.write('R');
          print('\nPerforming hot restart...');
        } else {
          // Hot reload for lowercase r
          process.stdin.write('r');
          print('\nPerforming hot reload...');
        }
        keyBuffer = '';
      } else if (keyBuffer.toLowerCase() == 'h') {
        _printHotReloadHelp();
        keyBuffer = '';
      } else if (keyBuffer.toLowerCase() == 'q') {
        print('\nShutting down...');
        process.stdin.write('q');
        process.kill();
        keyBuffer = '';
      }
    // });
  }, onDone: () {
    // _clean/UpTerminal();
  });

  // Handle process completion
  final exitCode = await process.exitCode;
  // _cleanUpTerminal();
  
  if (exitCode != 0) {
    throw Exception('Process exited with code $exitCode');
  }
}


void _printHotReloadHelp() {
  print('\nHot Reload Controls:');
  print('  ${Colors.coloredCommand('r')} - Hot reload');
  print('  ${Colors.coloredCommand('R')} - Hot restart');
  print('  ${Colors.coloredCommand('h')} - Show this help');
  print('  ${Colors.coloredCommand('q')} - Quit application\n');
}


Future<String> _selectFlavorInteractively() async {
  const flavors = ['dev', 'staging', 'production'];
  const descriptions = ['Development', 'Staging ', 'Production '];

  int selectedIndex = 0;
  bool done = false;

  // Print initial menu
  print('Select Environment Flavor (Use arrow keys ↑/↓, Enter to select):');
  _printMenu(flavors, descriptions, selectedIndex);

  // Set up terminal for raw input
  stdin.echoMode = false;
  stdin.lineMode = false;

  while (!done) {
    final input = stdin.readByteSync();

    // Handle arrow keys (ANSI escape sequences)
    if (input == 27) {
      // ESC
      if (stdin.readByteSync() == 91) {
        // [
        switch (stdin.readByteSync()) {
          case 65:
            if (selectedIndex > 0) {
              selectedIndex--;
              _printMenu(flavors, descriptions, selectedIndex);
            }
            break;
          case 66:
            if (selectedIndex < flavors.length - 1) {
              selectedIndex++;
              _printMenu(flavors, descriptions, selectedIndex);
            }
            break;
        }
      }
    } else if (input == 10) {
      // Enter
      done = true;
    }
  }

  // Clean up terminal settings
  stdin.echoMode = true;
  stdin.lineMode = true;
  print('\n');

  return flavors[selectedIndex];
}

void _printMenu(
  List<String> flavors,
  List<String> descriptions,
  int selectedIndex,
) {
  // Move cursor up to rewrite the menu
  for (int i = 0; i < flavors.length; i++) {
    stdout.write('\x1B[1A\x1B[2K'); // Move up and clear line
  }

  for (int i = 0; i < flavors.length; i++) {
    if (i == selectedIndex) {
      stdout.write('> ');
    } else {
      stdout.write('  ');
    }
    stdout.writeln(Colors.coloredOptions('${flavors[i]} - ${_getTargetPathForEnvironment(flavors[i])}'));
  }
}

String _getTargetPathForEnvironment(String env) {
  switch (env) {
    case 'dev':
      return 'lib/main/dev.dart';
    case 'staging':
      return 'lib/main/staging.dart';
    case 'production':
      return 'lib/main/production.dart';
    default:
      return 'lib/main/dev.dart';
  }
}

