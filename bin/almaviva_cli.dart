import 'dart:io';
import 'package:almaviva_cli/actions/clean.dart';
import 'package:almaviva_cli/actions/create_module.dart';
import 'package:almaviva_cli/actions/generate.dart';
import 'package:almaviva_cli/actions/run_project.dart';
import 'package:almaviva_cli/actions/show_commands.dart';
import 'package:almaviva_cli/actions/status.dart';
import 'package:almaviva_cli/actions/version.dart';

import 'package:args/args.dart';
import 'package:almaviva_cli/actions/cli_setup.dart';
import 'package:almaviva_cli/actions/clone_project.dart';
import 'package:almaviva_cli/actions/generate_localization.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addCommand('setup')
    ..addCommand('version')
    ..addCommand('run', _configureRunCommand())
    ..addCommand('clean')
    ..addCommand('feature')
    ..addCommand('gen')
    ..addCommand('status')
    ..addCommand('logs')
    ..addCommand('l10n');

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
    case 'gen':
      runBuildRunner();
      break;
    case 'logs':
      showCommands(parser);
      break;
    case 'status':
      showStatus();
      break;
    case 'l10n':
      handleLocalizationGenerateCommand();
      break;
    default:
      print('Unknown command');
  }
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




void buildApk() {
  print('Building APK...');
  // Functionality to build APK
}

void buildBundle() {
  print('Building Bundle...');
  // Functionality to build AppBundle
}


void createDir(String dirPath) {
  final dir = Directory(dirPath);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
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
