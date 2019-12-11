import 'package:meta/meta.dart';

import './remote_config.dart';
import '../core.dart';

class AppConfig {
  final _logger = getLogger();

  final RemoteConfig _remoteConfig;
  AppConfig({@required RemoteConfig remoteConfig})
      : assert(remoteConfig != null),
        this._remoteConfig = remoteConfig;

  bool someConfig;
  String anotherConfig;
  String apiBaseUrl;

  void initialise() {
    someConfig = _remoteConfig.getBool(RemoteConfig.config_one);
    anotherConfig = _remoteConfig.getString(RemoteConfig.config_two);
    apiBaseUrl = _remoteConfig.getString(RemoteConfig.api_base_url);
    _logger.i('config initialised');
  }
}
