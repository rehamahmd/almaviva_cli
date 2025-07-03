import 'dart:io';
import 'package:almaviva_cli/actions/clean.dart';
import 'package:almaviva_cli/actions/create_module.dart';
import 'package:almaviva_cli/actions/generate.dart';
import 'package:almaviva_cli/actions/run_project.dart';
import 'package:almaviva_cli/actions/show_commands.dart';
import 'package:almaviva_cli/actions/version.dart';
import 'package:almaviva_cli/helpers/colors.dart';
import 'package:almaviva_cli/helpers/run_command.dart';
import 'package:args/args.dart';
import 'package:almaviva_cli/actions/cli_setup.dart';
import 'package:almaviva_cli/actions/clone_project.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addCommand('setup')
    ..addCommand('version')
    ..addCommand('init')
    ..addCommand('run', _configureRunCommand())
    ..addCommand('clean')
    ..addCommand('feature')
    ..addCommand('build-apk')
    ..addCommand('build-bundle')
    ..addCommand('gen')
    ..addCommand('status')
    ..addCommand('logs');

  final argResults = parser.parse(arguments);

  if (argResults.command == null) {
    print('Please specify a command.');
    showCommands(parser);
    exit(1);
  }

  switch (argResults.command!.name) {
    case 'setup':
      CliSetup.setup();
      break;
    case 'version':
      showVersion();
      break;
    case 'feature':
      createFeature(argResults.command!.rest);
      break;
    case 'init':
      initProject(argResults.command!.rest);
      break;
    case 'run':
      handleRunCommand(argResults.command!);
      break;
    case 'clean':
      handlePrepareCommand();
      break;
    case 'build-apk':
      buildApk();
      break;
    case 'build-bundle':
      buildBundle();
      break;
    case 'start':
      startFlutterApp(parser);
      break;
    case 'gen':
      runBuildRunner();
      break;
    case 'logs':
      showCommands(parser);
      break;
    case 'status':
      showStatus();
      break;  
    default:
      print('Unknown command');
  }
}
showStatus(){
  print(Colors.coloredHeader('Usage: flutter_cli Tasks Status for `alma`'));
  print(Colors.coloredHeader('Status Done✅'));
  print('${Colors.coloredCommand('  Setup')}         ${Colors.coloredDescription(' ✅Done')}');
  print('${Colors.coloredCommand('  Run')}           ${Colors.coloredDescription(' ✅Done')}');
  print('${Colors.coloredCommand('  Clean')}         ${Colors.coloredDescription(' ✅Done')}');
  print('${Colors.coloredCommand('  Version')}       ${Colors.coloredDescription(' ✅Done')}');
  print('${Colors.coloredCommand('  Feature')}       ${Colors.coloredDescription(' ✅Done')}');
  print('${Colors.coloredCommand('  Logs')}          ${Colors.coloredDescription(' ✅Done')}');
  print('${Colors.coloredCommand('  Generate')}      ${Colors.coloredDescription(' ✅Done')}');

  print(Colors.coloredHeader('\nOptions:'));

}

void initProject(List<String> args) {
  if (args.isEmpty) {
    print('Please provide a project name.');
    exit(1);
  }
  final projectName = args[0];
  print('Initializing project: $projectName');
  CloneProject.cloneProject(args);
  // Call function to initialize project here
}

void cleanProject() async {
  print('Cleaning project...');

  try {
    await runCommand('flutter', ['clean']);
    await runCommand('flutter', ['pub', 'get']);
    await runCommand('rm', ['-rf', 'Podfile.lock'], workingDirectory: 'ios');
    await runCommand('rm', ['-rf', 'Pods'], workingDirectory: 'ios');
    await runCommand('pod', ['install'], workingDirectory: 'ios');

    print('✅ Project cleaned successfully.');
  } catch (error) {
    print('❌ Error: $error');
    exit(1);
  }
}

void generateCode() async {
  try {
    print('Generate Code...');
    await runCommand('dart', [
      'pub',
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ]);
  } catch (error) {
    print('❌ Error: $error');
    exit(1);
  }
}

void buildApk() {
  print('Building APK...');
  // Functionality to build APK
}

void buildBundle() {
  print('Building Bundle...');
  // Functionality to build AppBundle
}

void startFlutterApp(ArgParser argParser) {
  print('Starting Flutter app...');

  argParser
    ..addOption(
      'env',
      abbr: 'e',
      help: 'Environment to run (dev, staging, production)',
      allowed: ['dev', 'staging', 'production'],
      defaultsTo: 'dev',
    )
    ..addOption('device-id', abbr: 'd', help: 'Target device ID to run on')
    ..addFlag('release', help: 'Run in release mode', negatable: false)
    ..addFlag('profile', help: 'Run in profile mode', negatable: false);
}

void createDir(String dirPath) {
  final dir = Directory(dirPath);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
}

void createFile(String filePath, String content) {
  final file = File(filePath);
  file.writeAsStringSync(content);
}

String convertToCamelCase(String name) {
  final words = name
      .split(RegExp(r'[-_]+'))
      .map((word) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      })
      .join('');
  return words[0].toLowerCase() + words.substring(1);
}

String convertToVariableIdentifier(String name) {
  final camelCaseName = convertToCamelCase(name);
  return camelCaseName[0].toLowerCase() + camelCaseName.substring(1);
}

ArgParser _configureRunCommand() {
  return ArgParser()
    ..addOption(
      'env',
      abbr: 'e',
      help: 'Environment to run (dev, staging, prod)',
      allowed: ['dev', 'staging', 'prod'],
      defaultsTo: 'dev',
    )
    ..addOption('device-id', abbr: 'd', help: 'Target device ID to run on')
    ..addFlag('release', help: 'Run in release mode', negatable: false)
    ..addFlag('profile', help: 'Run in profile mode', negatable: false);
}
