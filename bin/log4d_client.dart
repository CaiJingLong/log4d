import 'package:args/args.dart';
import 'package:log4d/client.dart';
import 'package:log4d/src/entity/log.dart';

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

  parser.addOption(
    "host",
    abbr: "t",
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

  var client = Log4dClient(port: port);
  await client.connect();

  var msg = result.rest;
  msg.forEach((arg) {
    client.sendMsg(arg, level: level);
  });

  client.disconnect();
}
