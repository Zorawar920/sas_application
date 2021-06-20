import 'package:get_it/get_it.dart';
import 'package:sas_application/firebase_services/auth.dart';
import 'package:sas_application/uniformity/var_gradient.dart';

GetIt singletonInstance = GetIt.instance;

void registerSingleton() {
  singletonInstance.registerLazySingleton(() => Auth());
  singletonInstance.registerLazySingleton(() => VarGradient());
}
