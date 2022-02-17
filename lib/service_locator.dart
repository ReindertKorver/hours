import 'package:get_it/get_it.dart';
import 'package:hours/Services/work_iteration_service.dart';

final locator = GetIt.instance;

setupServiceLocator() {
  locator.registerLazySingleton<IWorkIterationService>(
      () => WorkIterationService());
}
