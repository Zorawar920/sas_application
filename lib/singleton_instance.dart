import 'package:get_it/get_it.dart';
import 'package:sas_application/firebase_services/auth.dart';
import 'package:sas_application/firebase_services/firebase_db.dart';
import 'package:sas_application/models/user_model.dart';
import 'package:sas_application/uniformity/var_gradient.dart';

import 'external_services/contact_services.dart';

GetIt singletonInstance = GetIt.instance;

void registerSingleton() {
  singletonInstance.registerLazySingleton(() => Auth());
  singletonInstance.registerLazySingleton(() => VarGradient());
  singletonInstance.registerLazySingleton(() => Services());
  singletonInstance.registerLazySingleton(() => FirebaseDbService());
  singletonInstance.registerLazySingleton(() => UserModel());
}
