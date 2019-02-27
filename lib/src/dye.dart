import 'package:ansicolor/ansicolor.dart';

black(text) => (new AnsiPen()..black())(text);
blue(text) => (new AnsiPen()..blue())(text);
cyan(text) => (new AnsiPen()..cyan())(text);
green(text) => (new AnsiPen()..green())(text);
magenta(text) => (new AnsiPen()..magenta())(text);
red(text) => (new AnsiPen()..red())(text);
white(text) => (new AnsiPen()..white())(text);
yellow(text) => (new AnsiPen()..yellow())(text);

// Custom colors
gray(text) => (new AnsiPen()..rgb(r: 0.5, g: 0.5, b: 0.5))(text);
dim(text) => (new AnsiPen()..rgb(r: 0.3, g: 0.3, b: 0.3))(text);
