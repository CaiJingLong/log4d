import 'dart:io';

import 'package:log4d/src/entity/log.dart';

class Log4dClient {
  int port;
  String host;

  WebSocket ws;

  Log4dClient({
    this.port = 8899,
    this.host = "localhost",
  });

  Future connect() async {
    ws = await WebSocket.connect("ws://$host:8899");
    ws.listen((data) {
      print("receive: $data");
    });
  }

  void sendMsg(
    String msg, {
    Level level = Level.debug,
    bool force = false,
    bool showColor = true,
    bool showTime = true,
  }) {
    var entity = LogEntity(
      msg: msg,
      level: level,
      force: force,
      showColor: showColor,
      showTime: showTime,
    );
    ws?.add(entity.toJson());
  }

  void sendEntity(LogEntity entity) {
    ws?.add(entity.toJson());
  }

  void disconnect() {
    ws?.close();
  }
}
