import 'dart:io';

import 'package:log4d/src/entity/log.dart';

class Log4dClient {
  int port;
  String host;

  WebSocket ws;

  Log4dClient({this.port = 8899, this.host = "localhost"});

  Future connect() async {
    ws = await WebSocket.connect("ws://$host:8899");
    ws.listen((data) {
      print("receive: $data");
    });
  }

  void sendMsg(
    String msg, {
    Level level = Level.debug,
  }) {
    var entity = LogEntity(msg: msg, level: level);
    ws?.add(entity.toJson());
  }

  void sendEntity(LogEntity entity) {
    ws?.add(entity);
  }

  void disconnect() {
    ws?.close();
  }
}
