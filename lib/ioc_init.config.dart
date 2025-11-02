// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'data/repositories/user_profile_repository.dart' as _i200;
import 'data/services/bt_advertising_service.dart' as _i596;
import 'data/services/bt_discovery_service.dart' as _i623;
import 'data/services/hive_secure_service.dart' as _i16;
import 'data/services/user_profile_service.dart' as _i1033;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i596.BtAdvertisingService>(() => _i596.BtAdvertisingService());
    gh.factory<_i623.BtDiscoveryService>(() => _i623.BtDiscoveryService());
    gh.factory<_i1033.UserProfileService>(() => _i1033.UserProfileService());
    gh.singleton<_i16.HiveSecureService>(() => _i16.HiveSecureService());
    gh.singleton<_i200.UserProfileRepository>(() => _i200.UserProfileRepository(
          btDiscoveryService: gh<_i623.BtDiscoveryService>(),
          btAdvertisingService: gh<_i596.BtAdvertisingService>(),
          hiveSecureService: gh<_i16.HiveSecureService>(),
        ));
    return this;
  }
}
