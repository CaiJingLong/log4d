import 'package:args/args.dart';
import 'package:log4d/log4d.dart';

main(List<String> args) async {
  var parser = ArgParser();

  parser.addOption(
    "port",
    abbr: "p",
    defaultsTo: "8899",
    help: "port with server",
  );

  parser.addFlag(
    "help",
    abbr: 'h',
    help: "show help info",
    defaultsTo: false,
  );

  parser.addFlag(
    "time",
    abbr: 't',
    help: "show time",
    defaultsTo: true,
  );

  parser.addOption(
    "host",
    abbr: "s",
    defaultsTo: "localhost",
    help: "host with server",
  );

  parser.addOption(
    "level",
    abbr: 'l',
    help: "level for log",
    defaultsTo: "debug",
    allowedHelp: {
      "d": "debug",
      "i": "info",
      "w": "warning",
      "e": "error",
    },
  );

  parser.addFlag(
    "force",
    abbr: 'f',
    defaultsTo: false,
    help: 'if true, color,level,time will be ignore.',
  );

  var result = parser.parse(args);

  if (result["help"] == true) {
    print(parser.usage);
    return;
  }

  var port = int.parse(result["port"]);

  String l = result["level"];
  Level level;
  if (l == "e") {
    level = Level.error;
  } else if (l == "i") {
    level = Level.info;
  } else if (l == "w") {
    level = Level.warning;
  } else {
    level = Level.debug;
  }

  var force = result["force"];
  var showTime = result["time"];
  var host = result["host"];

  var client = Log4dClient(port: port, host: host);
  await client.connect();

  var msg = result.rest;
  msg.forEach((arg) {
    client.sendMsg(
      arg,
      level: level,
      showTime: showTime,
      force: force,
    );
  });

  client.disconnect();
}
