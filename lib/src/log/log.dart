part of '../log.dart';

class Log {
  static bool showLog = true;

  static String message(text) {
    var r = '${now()} $text';
    if (showLog) print(r);
    return r;
  }

  static String error(text) {
    var r = '${now(color: red)} $text';
    if (showLog) print(r);
    return r;
  }

  static String success(text) {
    var r = '${now(color: green)} $text';
    if (showLog) print(r);
    return r;
  }

  static String warning(text) {
    var r = '${now(color: yellow)} $text';
    if (showLog) print(r);
    return r;
  }
}
