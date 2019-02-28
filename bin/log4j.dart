import 'package:log4d/log4d.dart' as log4d;
import 'package:log4d/server.dart' as log4d;
import 'package:args/args.dart';

main(List<String> args) {
  var parser = ArgParser();
  parser.addOption('output', abbr: 'o', help: "output path");
  parser.addOption('port', abbr: 'p', help: "server port", defaultsTo: "8899");
  parser.addFlag('help', abbr: "h", help: "usage");
  parser.addFlag('server', abbr: "s", help: "open the server");
  parser.addFlag('console',
      abbr: "c", help: "show log in console", defaultsTo: true);

  if (args.isEmpty) {
    print(parser.usage);
    return;
  }
  ArgResults results;
  try {
    results = parser.parse(args);
  } on FormatException catch (e) {
    print(e.message);
    return;
  }

  if (results["help"]) {
    print(parser.usage);
    return;
  }

  String outputPath = results["output"];

  int port = int.tryParse(results["port"]);

  if (results["server"]) {
    var server = log4d.Log4dServer(
      outpath: outputPath,
      port: port,
      showConsole: results["console"],
    );
    server.serve();
  }
}
