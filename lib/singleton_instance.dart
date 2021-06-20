import 'package:get_it/get_it.dart';
import 'package:sas_application/firebase_services/auth.dart';

GetIt singletonInstance = GetIt.instance;

void registerSingleton() {
  singletonInstance.registerLazySingleton(() => Auth());
}
