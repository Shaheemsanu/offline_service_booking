import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:offline_service_booking/app/injector/injector.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();
