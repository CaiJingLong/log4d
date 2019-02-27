import 'package:log4d/src/dye.dart';
import 'package:log4d/src/log.dart';

int calculate() {
  return 6 * 7;
}

void log(String msg){
  Log.message("message");
  Log.success("success");
  Log.warning("warning");
  Log.error("error");
  var n = now();
  print(n);
}