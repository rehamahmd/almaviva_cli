import 'package:almaviva_cli/helpers/colors.dart';
import 'package:args/args.dart';


void showCommands(ArgParser parser) {
  
  print('${Colors.coloredCommand('  setup')}         ${Colors.coloredDescription('Set up the Cli after update')}');
  print('${Colors.coloredCommand('  run')}           ${Colors.coloredDescription('Run the Flutter app')}');
  print('${Colors.coloredCommand('  clean')}         ${Colors.coloredDescription('Clean project dependencies and build artifacts')}');
  print('${Colors.coloredCommand('  feature')}       ${Colors.coloredDescription('Create a new feature module')}');
  print('${Colors.coloredCommand('  version')}       ${Colors.coloredDescription('Display Flutter version')}');
  print('${Colors.coloredCommand('  logs')}          ${Colors.coloredDescription('Show Current Available Cli commands')}');
  print('${Colors.coloredCommand('  gen')}           ${Colors.coloredDescription('Generate app code - run build_runner')}');
  print(Colors.coloredHeader('\nOptions:'));
  print(Colors.coloredOptions(parser.usage));
}