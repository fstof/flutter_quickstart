import 'package:meta/meta.dart';

enum Flavor { NONPROD, PROD }

class FlavorValues {
  FlavorValues({@required this.someFlavorConfig});
  final bool someFlavorConfig;
  //Add other flavor specific values
}

class FlavorConfig {
  static FlavorConfig _instance;

  final Flavor flavor;
  final FlavorValues values;

  factory FlavorConfig({
    @required Flavor flavor,
    @required FlavorValues values,
  }) {
    _instance ??= FlavorConfig._internal(
      flavor,
      values,
    );
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.values);

  static FlavorConfig get instance {
    return _instance;
  }

  static bool isProd() => _instance.flavor == Flavor.PROD;
  static bool isNonprod() => _instance.flavor == Flavor.NONPROD;
}
