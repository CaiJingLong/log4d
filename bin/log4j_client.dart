import 'dart:io';

main(List<String> args) async {
  var ws = await WebSocket.connect("ws://localhost:3030");
  ws.listen((data) {
    print("receive: $data");
  });
  ws.add("test");
  ws.add("test".codeUnits);

  ws.close();
}
