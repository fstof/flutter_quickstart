import 'package:get_it/get_it.dart';

import '../index.dart';

void registerServices(GetIt sl) {
  sl.registerLazySingleton(() => UserRepo(applicationDao: sl()));
  sl.registerLazySingleton(() => LoginApi(sl()));
  sl.registerLazySingleton(() => LoginRepo(
        loginApi: sl(),
        tokenStorage: sl(),
        appAuth: sl(),
      ));
}
