import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_service_booking/app/injector/injector.dart';
import 'package:offline_service_booking/src/application/booking_list/booking_list_bloc.dart';
import 'package:offline_service_booking/src/application/provider_list/provider_list_bloc.dart';
import 'package:offline_service_booking/src/presentation/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:offline_service_booking/src/presentation/view/splash_screen/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<ProviderListBloc>()),
        BlocProvider(create: (context) => getIt<BookingListBloc>()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        home: SplashScreen(),
      ),
    );
  }
}
