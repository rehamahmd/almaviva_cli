import 'package:ansicolor/ansicolor.dart';

class Colors{
static  final AnsiPen _headerPen = AnsiPen()..cyan(bold: true);
static final AnsiPen _commandPen = AnsiPen()..green();
static final AnsiPen _descriptionPen = AnsiPen()..white();
static final AnsiPen _optionsPen = AnsiPen()..yellow();
static final AnsiPen _errorPen = AnsiPen()..red(bold: true);

static String coloredHeader(String text) => _headerPen(text);
static String coloredCommand(String text) => _commandPen(text);
static String coloredDescription(String text) => _descriptionPen(text);
static String coloredOptions(String text) => _optionsPen(text);
static String coloredError(String text) => _errorPen(text);

}