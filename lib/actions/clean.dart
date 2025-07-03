
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cli_spinner/cli_spinner.dart';
Future<void> handlePrepareCommand() async {
  // Define all steps with metadata
  final preparationSteps = [
    {
      'name': 'Cleaning project',
      'command': ['clean'],
      'emoji': '🧹',
      'estimatedTime': 5, // seconds
    },
    {
      'name': 'Getting dependencies',
      'command': ['pub', 'get'],
      'emoji': '📦',
      'estimatedTime': 15,
    },
    {
      'name': 'Running build_runner',
      'command': ['packages', 'pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      'emoji': '🏗️',
      'estimatedTime': 30,
    },
    {
      'name': 'Generating localization files',
      'command': [
        'pub', 
        'run', 
        'easy_localization:generate', 
        '-S', 'assets/translations', 
        '-f', 'keys', 
        '-O', 'lib/src/core/l10n', 
        '-o', 'locale_keys.g.dart'
      ],
      'emoji': '🌍',
      'estimatedTime': 10,
    },
  ];

  final stopwatch = Stopwatch();
  final stepResults = <Map<String, dynamic>>[];

  print('🚀 Starting project Clean...\n');

  for (final step in preparationSteps) {
    final stepName = step['name'] as String;
    final emoji = step['emoji'] as String;
    final estimatedTime = step['estimatedTime'] as int;
    final command = step['command'] as List<String>;

    stopwatch.reset();
    stopwatch.start();

    final spinner = Spinner('$emoji $stepName (estimated: ${estimatedTime}s)');
    spinner.start();

    try {
      // Platform-specific command handling
      final process = Platform.isWindows
          ? await Process.start('flutter.bat', command, runInShell: true)
          : await Process.start('flutter', command, runInShell: true);

      // Capture all output
      final stdoutBuffer = StringBuffer();
      final stderrBuffer = StringBuffer();
      String lastOutputLine = '';

      process.stdout.transform(utf8.decoder).transform(LineSplitter()).listen((line) {
        stdoutBuffer.writeln(line);
        lastOutputLine = line; // Keep updating with the last line
      });

      process.stderr.transform(utf8.decoder).transform(LineSplitter()).listen((line) {
        stderrBuffer.writeln(line);
      });

      final exitCode = await process.exitCode;
      stopwatch.stop();

      if (exitCode != 0) {
        spinner.stop();
        print('\n❌ Error output:\n${stderrBuffer}');
        stepResults.add({
          'step': stepName,
          'status': 'failed',
          'time': stopwatch.elapsed.inSeconds,
          'error': stderrBuffer.toString(),
          'output': stdoutBuffer.toString(),
        });
        _printSummary(stepResults);
        exit(exitCode);
      }

      spinner.stop();
      
      // Print the last meaningful output line if available
      if (lastOutputLine.trim().isNotEmpty) {
        print('   ↳ $lastOutputLine');
      }
      
      stepResults.add({
        'step': stepName,
        'status': 'success',
        'time': stopwatch.elapsed.inSeconds,
        'output': stdoutBuffer.toString(),
        'lastLine': lastOutputLine,
      });

    } catch (e) {
      stopwatch.stop();
      spinner.stop();
      stepResults.add({
        'step': stepName,
        'status': 'failed',
        'time': stopwatch.elapsed.inSeconds,
        'error': e.toString()
      });
      _printSummary(stepResults);
      rethrow;
    }
  }

  _printSummary(stepResults);
  print('\n🎉 Clean and build completed successfully!');
}

void _printSummary(List<Map<String, dynamic>> results) {
  print('\n📊 Execution Summary:');
  print('┌──────────────────────────────┬──────────┬────────┬────────────────────────────┐');
  print('│ Step                        │ Status   │ Time   │ Last Output                │');
  print('├──────────────────────────────┼──────────┼────────┼────────────────────────────┤');

  for (final result in results) {
    final step = result['step'].toString().padRight(28);
    final status = (result['status'] == 'success' 
        ? '✅ Success' 
        : '❌ Failed').padRight(10);
    final time = '${result['time']}s'.padLeft(6);
    final lastLine = (result['lastLine'] ?? result['error'] ?? '')
        .toString()
        .replaceAll('\n', ' ')
        .trim();
    final truncatedOutput = lastLine.length > 28 
        ? '${lastLine.substring(0, 25)}...' 
        : lastLine.padRight(28);
    
    print('│ $step │ $status │ $time │ $truncatedOutput │');
  }

  print('└──────────────────────────────┴──────────┴────────┴────────────────────────────┘');

  final totalTime = results.fold<int>(0, (sum, result) => sum + (result['time'] as int));
  print('\n⏱️  Total execution time: ${totalTime}s');

  // Show failed step details if any
  final failedSteps = results.where((r) => r['status'] == 'failed');
  if (failedSteps.isNotEmpty) {
    print('\n🔴 Failed steps details:');
    for (final step in failedSteps) {
      print('\n❌ ${step['step']}:');
      print(step['error']);
      if (step['output'] != null) {
        print('\nFull output:');
        print(step['output']);
      }
    }
  }
}