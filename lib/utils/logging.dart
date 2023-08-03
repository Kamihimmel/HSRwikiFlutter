import 'package:logger/logger.dart';
import 'package:stack_trace/stack_trace.dart';

final logger = Logger(
  level: Level.info,
  printer: CustomLogPrinter(),
  filter: DevelopmentFilter(),
);

class DevelopmentFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    var shouldLog = false;
    assert(() {
      // development env
      if (event.level.index >= Level.debug.index) {
        shouldLog = true;
      }
      return true;
    }());
    // production env
    if (!shouldLog && event.level.index >= level!.index) {
      shouldLog = true;
    }
    return shouldLog;
  }
}

class CustomLogPrinter extends LogPrinter {

  @override
  List<String> log(LogEvent event) {
    var printLocation = false;
    assert(() {
      // development env
      printLocation = true;
      return true;
    }());
    DateTime t = event.time;
    String time = "${t.year}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')} ${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:${t.second.toString().padLeft(2, '0')}";
    String levelStr = event.level.name.toUpperCase();
    if (printLocation) {
      List<Frame> frames = Trace.current().frames;
      String stack = frames.length > 3 ? frames[3].location : 'unknown';
      return ["$time\t[$levelStr]\t[$stack]\t${event.message}"];
    } else {
      return ["$time\t[$levelStr]\t${event.message}"];
    }
  }
}