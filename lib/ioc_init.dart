import 'package:date_o_matic/ioc_init.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// ignore: public_member_api_docs
final getIt = GetIt.instance;

/// initializes the dependency injection system
@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDependencies() => getIt.init();
