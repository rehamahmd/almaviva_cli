import 'dart:io';

class CliSetup {
  CliSetup._();
  static void setup() {
    print('You mest run this command in the project dir');
    _compile();
    _createFile();
    _moveFile();
    print('almaviva CLI is ready to use! Run it with "alma".');
  }

  static void _compile() {
    Process.run("dart", ["pub", 'global', 'deactivate', 'almaviva_cli']);
    print('1- Compiling the CLI...');
    final result = Process.runSync('dart', [
      'compile',
      'exe',
      'bin/almaviva_cli.dart',
      '-o',
      'alma',
    ]);
    if (result.exitCode == 0) {
      print('Compilation successful!');
    } else {
      print('Compilation failed: ${result.stderr}');
    }
  }

  static void _createFile() {
    print('2- Setting execute permissions...');
    final result = Process.runSync('sudo', ['chmod', '+x', 'alma']);
    if (result.exitCode == 0) {
      print('Permissions set successfully!');
    } else {
      print('Failed to set permissions: ${result.stderr}');
    }
  }

  static void _moveFile() {
    print('3- Moving the executable to /usr/local/bin...');
    final result = Process.runSync('sudo', [
      'mv',
      'alma',
      '/usr/local/bin/',
    ]);
    if (result.exitCode == 0) {
      print('File moved successfully!');
    } else {
      print('Failed to move file: ${result.stderr}');
    }
  }
}
