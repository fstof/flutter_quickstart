import 'package:firebase_remote_config/firebase_remote_config.dart' as frc;

import '../core.dart';

class RemoteConfig {
  static const config_one = 'config_one';
  static const config_two = 'config_two';
  static const api_base_url = 'api_base_url';

  final _log = getLogger();
  static RemoteConfig _instance;

  frc.RemoteConfig _remoteConfig;

  final _defaultsNonProd = <String, dynamic>{
    config_one: false,
    config_two: 'i am not prod',
    api_base_url: 'https://reqres.in',
  };

  final _defaultsProd = <String, dynamic>{
    config_one: false,
    config_two: 'i am prod',
    api_base_url: 'https://reqres.in',
  };

  factory RemoteConfig() {
    if (_instance == null) {
      _instance = RemoteConfig._();
    }
    return _instance;
  }
  RemoteConfig._();

  Future<RemoteConfig> initialise([bool prod = false]) async {
    _remoteConfig = await frc.RemoteConfig.instance;
    _log.d('setting default remote config for ${prod ? 'prod' : 'nonprod'}');
    await _remoteConfig.setDefaults(prod ? _defaultsProd : _defaultsNonProd);
    // TODO skip fetching remote values until loaded into Firebase
    // await _remoteConfig
    //     .setConfigSettings(frc.RemoteConfigSettings(debugMode: true));
    // try {
    //   await _remoteConfig.fetch(
    //     expiration: const Duration(seconds: 5),
    //   );
    //   _log.d('fetched remote config');
    // } catch (error) {
    //   _log.e('fetch failed, using defaults, $error', error);
    // }
    // await _remoteConfig.activateFetched();
    _log.d('activated remote config');
    return _instance;
  }

  String getString(String key) {
    return _remoteConfig.getString(key);
  }

  bool getBool(String key) {
    return _remoteConfig.getBool(key);
  }

  double getDouble(String key) {
    return _remoteConfig.getDouble(key);
  }

  int getInt(String key) {
    return _remoteConfig.getInt(key);
  }
}
