import 'package:almaviva_cli/helpers/colors.dart';

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
  print('${Colors.coloredCommand('  l10n')}          ${Colors.coloredDescription(' ✅Done')}');

  print(Colors.coloredHeader('\nOptions:'));

}