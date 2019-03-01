import 'dart:async';

import 'package:log4d/log4d.dart';

class LogHelper {
  Log4dClient _client;

  bool isLog = true;

  bool isRemote = true;

  LogHelper._() {
    _client = Log4dClient();
  }

  Future connectRemote() async {
    await _client.connect();
  }

  static LogHelper _instance;

  factory LogHelper() {
    _instance ??= LogHelper._();
    return _instance;
  }

  void info(String msg) {
    if (isLog) print(msg);

    if (isLog && isRemote) {
      _client.sendEntity(
        LogEntity()
          ..level = Level.info
          ..msg = msg,
      );
    }
  }
}

void main() async {
  var log = LogHelper();
  await log.connectRemote();

  log.info("你好");
}