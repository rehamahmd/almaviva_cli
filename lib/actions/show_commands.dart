import 'package:almaviva_cli/helpers/colors.dart';
import 'package:args/args.dart';


void showCommands(ArgParser parser) {
  
  print('${Colors.coloredCommand('  setup')}         ${Colors.coloredDescription('alma setup _ Set up the Cli after update for manual installation')}');
  print('${Colors.coloredCommand('  run')}           ${Colors.coloredDescription('alma run _ Run the Flutter app')}');
  print('${Colors.coloredCommand('  clean')}         ${Colors.coloredDescription('alma clean _ Clean project dependencies and build artifacts')}');
  print('${Colors.coloredCommand('  feature')}       ${Colors.coloredDescription('alma feature [name] _ Create a new feature module')}');
  print('${Colors.coloredCommand('  version')}       ${Colors.coloredDescription('alma version _ Display Flutter version')}');
  print('${Colors.coloredCommand('  logs')}          ${Colors.coloredDescription('alma logs _ Show Current Available Cli commands')}');
  print('${Colors.coloredCommand('  gen')}           ${Colors.coloredDescription('alma gen _  Generate app code - run build_runner')}');
  print(Colors.coloredHeader('\nOptions:'));
  print(Colors.coloredOptions(parser.usage));
}