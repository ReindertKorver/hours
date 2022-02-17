import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:hours/Models/work_iteration.dart';
import 'package:hours/Services/work_iteration_service.dart';
import 'package:hours/service_locator.dart';
import 'package:intl/intl.dart';

class WorkIterationViewModel extends ChangeNotifier {
  List<WorkIteration> _iterations = List.empty();
  Map<int, TextEditingController> _firstEditControllers = {};
  Map<int, TextEditingController> _lastEditControllers = {};
  List<WorkIteration> get iterations => _iterations;
  Map<int, TextEditingController> get firstEditControllers =>
      _firstEditControllers;
  Map<int, TextEditingController> get lastEditControllers =>
      _lastEditControllers;
  IWorkIterationService service = locator<IWorkIterationService>();
  loadData() {
    _iterations = service.getAll();
    _firstEditControllers = {
      for (var e in _iterations)
        e.id: TextEditingController(text: DateFormat("HH:mm").format(e.first))
    };
    _lastEditControllers = {
      for (var e in _iterations)
        e.id: TextEditingController(text: DateFormat("HH:mm").format(e.last))
    };

    notifyListeners();
  }

  @override
  void dispose() {
    disposeEditors();
    super.dispose();
  }

  add(DateTime item, DateTime item1) {
    var iter = service.addIteration(item, item1);
    _firstEditControllers[iter.id] =
        TextEditingController(text: DateFormat("HH:mm").format(item));
    _lastEditControllers[iter.id] =
        TextEditingController(text: DateFormat("HH:mm").format(item1));
    _iterations = service.getAll();
    notifyListeners();
  }

  update(WorkIteration iteration) {
    service.update(iteration);
    _iterations = service.getAll();
    notifyListeners();
  }

  remove(WorkIteration item) {
    // _firstEditControllers[item.id]?.dispose();
    // _lastEditControllers[item.id]?.dispose();
    _firstEditControllers.remove(item.id);
    _lastEditControllers.remove(item.id);
    service.removeIteration(item.id);
    _iterations = service.getAll();
    notifyListeners();
  }

  disposeEditors() {
    for (var element in _firstEditControllers.values) {
      element.dispose();
    }
    for (var element in _lastEditControllers.values) {
      element.dispose();
    }
    _firstEditControllers.clear();
    _lastEditControllers.clear();
  }

  String calcHours() {
    if (_iterations.isNotEmpty) {
      var res = _iterations.map((e) => e.last.difference(e.first));

      var res1 = res.reduce((a, b) => a + b);
      var str = "";
      if (res1.inMinutes.remainder(60) == 59 &&
          res1.inSeconds.remainder(60) == 59) {
        str = "${res1.inHours + 1}";
      } else {
        str = "${res1.inHours}";
        if (res1.inMinutes.remainder(60) != 0) {
          str += ":${res1.inMinutes.remainder(60)}";
        }
      }
      return str;
    } else {
      return "0";
    }
  }
}
