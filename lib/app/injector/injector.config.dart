// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:offline_service_booking/src/application/booking_list/booking_list_bloc.dart'
    as _i393;
import 'package:offline_service_booking/src/application/provider_list/provider_list_bloc.dart'
    as _i334;
import 'package:offline_service_booking/src/domain/auth/i_auth_repostitory.dart'
    as _i931;
import 'package:offline_service_booking/src/domain/booking/booking.dart'
    as _i882;
import 'package:offline_service_booking/src/domain/provider_service/provider_service.dart'
    as _i877;
import 'package:offline_service_booking/src/infrastructure/auth/auth_repostitory.dart'
    as _i231;
import 'package:offline_service_booking/src/infrastructure/auth/firebase_auth.dart'
    as _i739;
import 'package:offline_service_booking/src/infrastructure/booking_repository/booking_repository.dart'
    as _i857;
import 'package:offline_service_booking/src/infrastructure/core/database_service.dart'
    as _i880;
import 'package:offline_service_booking/src/infrastructure/core/third_party_injectable_module.dart'
    as _i1026;
import 'package:offline_service_booking/src/infrastructure/provider_repository/provider_repository.dart'
    as _i339;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final thirdPartyInjectableModule = _$ThirdPartyInjectableModule();
    gh.lazySingleton<_i880.DatabaseServices>(() => _i880.DatabaseServices());
    gh.lazySingleton<_i739.FirebaseAuth>(
      () => thirdPartyInjectableModule.firebaseAuth,
    );
    gh.lazySingleton<_i877.ServiceProviderRepo>(
      () => _i339.ServiceProviderRepository(gh<_i880.DatabaseServices>()),
    );
    gh.lazySingleton<_i931.IAuthRepository>(
      () => _i231.AuthRepository(gh<_i739.FirebaseAuth>()),
    );
    gh.lazySingleton<_i882.BookingRepo>(
      () => _i857.BookingRepository(gh<_i880.DatabaseServices>()),
    );
    gh.factory<_i393.BookingListBloc>(
      () => _i393.BookingListBloc(gh<_i882.BookingRepo>()),
    );
    gh.factory<_i334.ProviderListBloc>(
      () => _i334.ProviderListBloc(gh<_i877.ServiceProviderRepo>()),
    );
    return this;
  }
}

class _$ThirdPartyInjectableModule extends _i1026.ThirdPartyInjectableModule {}
