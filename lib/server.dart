import 'dart:io';

import 'package:log4d/src/log.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Server {
  int port;

  bool showConsole;

  bool split;

  String outPath;

  File logFile;

  Server({
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

    Log.showLog = showConsole;
  }

  void serve() async {
    var handler = webSocketHandler((WebSocketChannel channel) {
      channel.stream.asBroadcastStream().listen(_onListen).onDone(_onDone);
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

  void _onListen(event) {
    if (event is String) {
      var logText = Log.message(event);
      logFile?.writeAsStringSync(logText);
    }
  }
}
