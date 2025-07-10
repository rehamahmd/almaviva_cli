import 'package:almaviva_cli/helpers/colors.dart';
import 'package:args/args.dart';


void showCommands(ArgParser parser) {
  
  print('${Colors.coloredCommand('  setup')}         ${Colors.coloredHeader('alma setup')}${Colors.coloredDescription(' - Set up the Cli after update for manual installation')}');
  print('${Colors.coloredCommand('  run')}           ${Colors.coloredHeader('alma run')}${Colors.coloredDescription(' - Run the Flutter app')}');
  print('${Colors.coloredCommand('  clean')}         ${Colors.coloredHeader('alma clean')}${Colors.coloredDescription(' - Clean project dependencies and build artifacts')}');
  print('${Colors.coloredCommand('  feature')}       ${Colors.coloredHeader('alma feature [name]')}${Colors.coloredDescription(' - Create a new feature module')}');
  print('${Colors.coloredCommand('  version')}       ${Colors.coloredHeader('alma version')}${Colors.coloredDescription(' - Display Flutter version')}');
  print('${Colors.coloredCommand('  logs')}          ${Colors.coloredHeader('alma logs')}${Colors.coloredDescription(' - Show Current Available Cli commands')}');
  print('${Colors.coloredCommand('  gen')}           ${Colors.coloredHeader('alma gen')}${Colors.coloredDescription(' - Generate app code - run build_runner')}');
  print('${Colors.coloredCommand('  l10n')}           ${Colors.coloredHeader('alma l10n')}${Colors.coloredDescription(' - Generate App localization files')}');
  print(Colors.coloredOptions(parser.usage));
}