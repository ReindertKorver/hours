import 'package:hours/Models/work_iteration.dart';

abstract class IWorkIterationService {
  WorkIteration addIteration(DateTime start, DateTime end);
  void removeIteration(int id);
  List<WorkIteration> getAll();
  WorkIteration getOne(int id);
  WorkIteration update(WorkIteration iteration);
}

class WorkIterationService implements IWorkIterationService {
  final List<WorkIteration> _workIterations = List.empty(growable: true);
  int _indexCounter = 1;
  @override
  WorkIteration addIteration(DateTime start, DateTime end) {
    var iter = WorkIteration(_indexCounter++, start, end);
    _workIterations.add(iter);
    print("should save");

    return iter;
  }

  @override
  List<WorkIteration> getAll() {
    _workIterations.sort((a, b) => a.first.compareTo(b.first));
    return _workIterations;
  }

  @override
  WorkIteration getOne(int id) {
    return _workIterations.firstWhere((element) => element.id == id);
  }

  @override
  void removeIteration(int id) {
    _workIterations.removeWhere((element) => element.id == id);
    print("should save");
  }

  @override
  WorkIteration update(WorkIteration iteration) {
    var item =
        _workIterations.firstWhere((element) => element.id == iteration.id);
    item.first = iteration.first;
    item.last = iteration.last;
    print("should save");
    return item;
  }
}
