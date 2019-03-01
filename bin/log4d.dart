import 'package:log4d/log4d.dart' as log4d;
import 'package:args/args.dart';

main(List<String> args) {
  var parser = ArgParser();
  parser.addOption('output', abbr: 'o', help: "output path");
  parser.addOption('port', abbr: 'p', help: "server port", defaultsTo: "8899");
  parser.addFlag('help', abbr: "h", help: "usage");
  parser.addFlag('console',
      abbr: "c", help: "show log in console", defaultsTo: true);

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

  var server = log4d.Log4dServer(
    outpath: outputPath,
    port: port,
    showConsole: results["console"],
  );
  server.serve();
}
