import 'package:intl/intl.dart';

class WorkIteration {
  WorkIteration(this.id, this.first, this.last);

  int id;
  DateTime first;
  DateTime last;
  final _valid = [false, false];
  final _lastStr = ["", ""];

  bool validate(String val, int index, var onUpdate) {
    bool isValid = false;
    var timeToCheck = DateTime.now();
    try {
      var e = val;
      var match = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$').hasMatch(e);
      if (match) {
        if (e.length == 5) {
          if (_lastStr[index] != e || !_valid[index]) {
            timeToCheck = DateFormat("yyyy-MM-dd HH:mm")
                .parse(DateFormat("yyyy-MM-dd ").format(DateTime.now()) + e);
            if (index == 0) {
              first = timeToCheck;
            } else {
              last = timeToCheck;
            }
            if (last.hour > first.hour ||
                (last.hour == first.hour && last.minute > first.minute)) {
              isValid = true;
              onUpdate(this);

              // lastEditController.text =
              //     DateFormat("HH:mm").format(widget.iteration.last);
              _lastStr[index] = val;
            } else {
              isValid = false;
              print("last greater then first " + val);
            }
          } else {
            isValid = _valid[index];
            print("Same value " + val);
          }
        } else {
          isValid = false;
          print("Length not 5: " + val);
        }
      } else {
        isValid = false;
        print("No match: " + val);
      }
    } catch (ex) {
      isValid = false;
      print("Exception: " + ex.toString() + "\n" + val);
    }
    _valid[index] = isValid;
    return isValid;
  }
}
