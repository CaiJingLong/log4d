import 'dart:convert';
import 'dart:io';

import 'package:log4d/src/entity/log.dart';
import 'package:log4d/src/log.dart';
import 'package:log4d/src/dye.dart';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Log4dServer {
  int port;

  bool showConsole;

  bool split;

  String outPath;

  File logFile;

  Log4dServer({
    int port = 8899,
    String outpath,
    bool showConsole = true,
    bool split = false,
  }) {
    this.port = port ??= 8899;
    this.showConsole = showConsole ??= true;
    this.split = split ??= false;
    this.outPath = outpath;

    if (outpath != null) this.logFile = File(outpath);

    if (logFile?.existsSync() == false) {
      logFile.createSync(recursive: true);
    }

    Log.showLog = showConsole;
  }

  void serve() async {
    var handler = webSocketHandler((WebSocketChannel channel) {
      channel.stream
          .asBroadcastStream()
          .listen((event) => _onListen(channel, event))
          .onDone(_onDone);
    });

    HttpServer server = await shelf_io.serve(handler, 'localhost', port);

    var successText = "log4j serve at ws://localhost:$port";
    Log.success(successText);

    ProcessSignal.sigint.watch().listen((data) {
      server.close();
      print("\n");
      Log.success("log4j server is stopped");
      exit(0);
    });
  }

  void _onDone() {
    var text = "log4j serve disconnect";
    Log.success(text);
  }

  void _onListen(WebSocketChannel channel, event) {
    if (event is String) {
      var entity = LogEntity.fromString(event);

      if (entity == null) {
        channel.sink.add("$event is must be ${LogEntity}");
        return;
      }
      String logText;

      var color;
      switch (entity.level) {
        case Level.debug:
          color = gray;
          break;
        case Level.info:
          color = green;
          break;
        case Level.warning:
          color = magenta;
          break;
        case Level.error:
          color = red;
          break;
      }

      String dt() {
        return new DateTime.now().toString().substring(11, 19);
      }

      if (entity.showTime && entity.showColor) {
        logText = color("[${color(dt())}] ${entity.msg}");
      } else if (entity.showTime) {
        logText = "[${dt()}] ${entity.msg}";
      } else if (entity.showColor) {
        logText = color(entity.msg);
      } else {
        logText = entity.msg;
      }

      if (this.showConsole) print(logText);

      _writeToLog(logText);
    }
  }

  void _writeToLog(String msg) {
    logFile?.writeAsStringSync(
      "$msg\n",
      mode: FileMode.append,
      flush: true,
    );
  }
}
