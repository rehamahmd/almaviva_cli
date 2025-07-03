import 'dart:io';

Future<void> runCommand(
  String command,
  List<String> arguments, {
  String? workingDirectory,
}) async {
  final process = await Process.start(
    command,
    arguments,
    workingDirectory: workingDirectory,
    runInShell: true,
  );

  // Display command output
  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);

  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    throw Exception('Command failed: $command ${arguments.join(' ')}');
  }
}
