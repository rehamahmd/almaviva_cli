import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> runBuildRunner() async {
  const task = {
    'name': 'Running build_runner',
    'command': ['pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
    'emoji': '🏗️',
    'estimatedTime': 30,
  };

  print('\n${task['emoji']} ${task['name']}... (estimated: ${task['estimatedTime']}s)');

  try {
    final stopwatch = Stopwatch()..start();
    final process = await Process.start(
      'flutter',
      task['command'] as List<String>,
      runInShell: true,
    );

    // Live output handling
    final stdoutStream = process.stdout.transform(utf8.decoder);
    final stderrStream = process.stderr.transform(utf8.decoder);

    stdoutStream.listen((data) => stdout.write(data));
    stderrStream.listen((data) => stderr.write(data));

    // Timeout handling
    final exitCode = await process.exitCode.timeout(
      Duration(seconds: (task['estimatedTime'] as int) + 30), // Extra buffer time
      onTimeout: () {
        print('\n⚠️ Build runner is taking longer than expected...');
        print('Press:');
        print('  [C] to continue waiting');
        print('  [A] to abort');
        
        return _handleBuildRunnerTimeout(process);
      },
    );

    stopwatch.stop();

    if (exitCode == 0) {
      print('\n✅ ${task['name']} completed successfully! '
          '(took ${stopwatch.elapsed.inSeconds}s)');
    } else {
      print('\n❌ Build runner failed (exit code: $exitCode)');
      exit(exitCode);
    }
  } catch (e) {
    print('\n❌ Error running build_runner: $e');
    exit(1);
  }
}

Future<int> _handleBuildRunnerTimeout(Process process) async {
  stdin.lineMode = false;
  stdin.echoMode = false;

  final completer = Completer<int>();
  
  stdin.listen((data) {
    final input = String.fromCharCodes(data).toLowerCase();
    if (input == 'c') {
      print('\nContinuing to wait...');
      // Let the process continue
      process.exitCode.then(completer.complete);
    } else if (input == 'a') {
      print('\nAborting build runner...');
      process.kill();
      completer.complete(-1);
    }
  });

  return completer.future.whenComplete(() {
    stdin.lineMode = true;
    stdin.echoMode = true;
  });
}