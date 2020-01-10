import 'package:get_it/get_it.dart';

import '../../app/index.dart' as app;
import '../../auth/index.dart' as auth;
import 'service_register.dart' as core;

GetIt sl = GetIt.instance;

void setupServiceLocator() {
  core.registerServices(sl);
  app.registerServices(sl);
  auth.registerServices(sl);
}
