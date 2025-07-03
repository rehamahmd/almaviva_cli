import 'package:almaviva_cli/helpers/colors.dart';
import 'package:args/args.dart';


void showCommands(ArgParser parser) {
  print(Colors.coloredHeader('Usage: flutter_cli <command> [options]\n'));
  print(Colors.coloredHeader('Available commands:'));
  print('${Colors.coloredCommand('  setup')}         ${Colors.coloredDescription('Set up Flutter project dependencies')}');
  print('${Colors.coloredCommand('  version')}       ${Colors.coloredDescription('Display Flutter version')}');
  // print('${Colors.coloredCommand('  create-feature')} ${Colors.coloredDescription('Create a new feature module')}');
  print('${Colors.coloredCommand('  init')}          ${Colors.coloredDescription('Initialize a new Flutter project')}');
  print('${Colors.coloredCommand('  clean')}         ${Colors.coloredDescription('Clean project dependencies and build artifacts')}');
  print('${Colors.coloredCommand('  build-apk')}     ${Colors.coloredDescription('Build an APK for the Flutter app')}');
  print('${Colors.coloredCommand('  build-bundle')}  ${Colors.coloredDescription('Build an AAB (Android App Bundle) for the Flutter app')}');
  print('${Colors.coloredCommand('  start')}         ${Colors.coloredDescription('Run the Flutter app')}');
  print('${Colors.coloredCommand('  gen')}           ${Colors.coloredDescription('Generate app code')}');
  print('${Colors.coloredCommand('  logs')}          ${Colors.coloredDescription('Show Flutter app logs')}');
  print(Colors.coloredHeader('\nOptions:'));
  print(Colors.coloredOptions(parser.usage));
}