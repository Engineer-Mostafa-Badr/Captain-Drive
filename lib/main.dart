// ignore_for_file: avoid_print
import 'dart:async';

import 'package:captain_drive/features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:captain_drive/screens/passenger/cubit/cubit.dart';
import 'package:captain_drive/features/home/passenger/presentation/views/layout_screen.dart';

import 'package:captain_drive/features/splash/presentation/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'business_logic/camera_model_cubit/camera_model_cubit.dart';
import 'business_logic/capatin_get_reservation_cubit/captain_get_reservation_cubit.dart';
import 'business_logic/captain_cancel_offer_cubit/captain_cancel_offer_cubit.dart';
import 'business_logic/captain_cancel_reservation_offer_cubit/captain_cancel_reservation_offer_cubit.dart';
import 'business_logic/captain_cancel_ride_offer_cubit/captain_cancel_ride_offer_cubit.dart';
import 'business_logic/captain_get_active_ride_cubit/captain_get_active_ride_cubit.dart';
import 'business_logic/captain_get_driver_reservation_cubit/captain_get_driver_reservation_cubit.dart';
import 'business_logic/captain_get_message_cubit/captain_get_message_cubit.dart';
import 'business_logic/captain_get_offer_cubit/captain_get_offer_cubit.dart';
import 'business_logic/captain_get_requests_cubit/captain_get_requests_cubit.dart';
import 'business_logic/captain_make_offer_cubit/captain_make_offer_cubit.dart';
import 'business_logic/captain_make_reservation_offer_cubit/captain_make_reservation_offer_cubit.dart';
import 'business_logic/driver_get_reservation_offer_cubit/driver_get_reservation_offer_cubit.dart';
import 'business_logic/driver_set_current_location_cubit/driver_set_current_location_cubit.dart';
import 'business_logic/maps/maps_cubit.dart';
import 'business_logic/set_arrive_ride_cubit/set_arrive_ride_cubit.dart';
import 'business_logic/set_ride_arrive_cubit/set_ride_complete_cubit.dart';
import 'core/components/constant.dart';
import 'core/di/get_it.dart' as di;
import 'core/network/dio_helper.dart';
import 'core/storage/cache_helper.dart';
import 'data/repository/maps_repo.dart';
import 'data/webservices/places_webservices.dart';
import 'features/auth/auth_selector/presentation/views/select_auth_type_view.dart';
import 'core/localization/localization_cubit.dart';

import 'core/network/share/bloc_observer.dart';
import 'features/home/driver/presentation/views/captain_layout_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const SimpleBlocObserver();

  try {
    // ✅ Initialize SharedPreferences safely
    await CacheHelper.init();
    print('✅ SharedPreferences initialized');
    await di.init();

    // ✅ Initialize Dio
    DioHelper.init();
    print('✅ Dio initialized');

    // ✅ Initialize Services

    // ✅ Get local data
    dynamic onBoarding = CacheHelper.getData(key: 'onBoarding');
    dynamic token = CacheHelper.getData(key: 'token');
    dynamic captientoken = CacheHelper.getData(key: 'Captientoken');

    print('📦 onBoarding: $onBoarding');
    print('📦 token: $token');
    print('📦 Captientoken: $captientoken');

    userToken = token;

    // ✅ Determine start screen
    Widget startWidget;
    if (onBoarding != null) {
      if (captientoken != null) {
        startWidget = const SplashScreen(screen: CaptainLayoutScreen());
      } else if (token != null) {
        startWidget = const SplashScreen(screen: LayoutScreen());
      } else {
        startWidget = const SplashScreen(screen: SelectedScreen());
      }
    } else {
      startWidget = const SplashScreen(screen: OnboardingScreen());
    }

    runApp(MyApp(startWidget: startWidget));
  } catch (e, stack) {
    print('💥 Error during initialization: $e');
    print(stack);
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PassengerCubit()
            ..getAllOffers()
            ..getActivities()
            ..getUserData(),
        ),
        BlocProvider(
          create: (context) => MapsCubit(
            MapsRepository(PlacesWebservices()),
          ),
        ),
        BlocProvider(
          create: (context) => LocalizationCubit()..loadLanguage('en'),
        ),
        BlocProvider(
          create: (context) =>
              CaptainGetDriverReservationCubit()..getCaptainDriverReservation(),
        ),
        BlocProvider(create: (context) => CaptainCancelReservationOfferCubit()),
        BlocProvider(
          create: (context) =>
              CaptainGetReservationCubit()..getCaptainReservation(),
        ),
        BlocProvider(
          create: (context) => CaptainGetMessageCubit()..getCaptainMessage(),
        ),
        BlocProvider(create: (context) => CaptainMakeReservationOfferCubit()),
        BlocProvider(create: (context) => DriverSetCurrentLocationCubit()),
        BlocProvider(
          create: (context) =>
              DriverGetReservationOfferCubit()..getCaptainOffer(),
        ),
        BlocProvider(
          create: (context) => CaptainGetRequestsCubit()..getCaptainRequests(),
        ),
        BlocProvider(
          create: (context) => CaptainGetOfferCubit()..getCaptainRideOffer(),
        ),
        BlocProvider(
          create: (context) =>
              CaptainGetActiveRideCubit()..getCaptainActiveRides(),
        ),
        BlocProvider(create: (context) => CaptainMakeOfferCubit()),
        BlocProvider(create: (context) => SetArriveRideCubit()),
        BlocProvider(create: (context) => SetRideCompleteCubit()),
        BlocProvider(create: (context) => CaptainCancelOfferCubit()),
        BlocProvider(create: (context) => CaptainCancelRideOfferCubit()),
        BlocProvider(create: (context) => CameraModelCubit()),
      ],
      child: BlocBuilder<LocalizationCubit, Map<String, String>>(
        builder: (context, localizedStrings) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            scaffoldMessengerKey: snackbarKey,
            debugShowCheckedModeBanner: false,
            title: 'WAY',
            theme: ThemeData(
              fontFamily: 'Noto',
              scaffoldBackgroundColor: AppColor.backGroundColor,
            ),
            locale: Locale(
              context.read<LocalizationCubit>().currentLanguage,
            ),
            home: startWidget,
          );
        },
      ),
    );
  }
}
