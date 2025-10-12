// ignore_for_file: avoid_print

import 'package:captain_drive/firebase_options.dart';
import 'package:captain_drive/screens/captain/captain_layout_screen.dart';
import 'package:captain_drive/screens/captain/chat/services/firebase_notifications.dart';
import 'package:captain_drive/screens/captain/chat/services/get_it_service.dart';
import 'package:captain_drive/screens/onboarding/onboarding_screen.dart';
import 'package:captain_drive/screens/passenger/cubit/cubit.dart';
import 'package:captain_drive/screens/passenger/layout_screen.dart';
import 'package:captain_drive/screens/selected/selected_screen.dart';
import 'package:captain_drive/screens/splash/splash_screen.dart';
import 'package:captain_drive/shared/local/cach_helper.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'components/constant.dart';
import 'data/repository/maps_repo.dart';
import 'data/webservices/places_webservices.dart';
import 'localization/localization_cubit.dart';
import 'network/remote/dio_helper.dart';
import 'network/share/bloc_observer.dart';

void main() async {
  Bloc.observer = const SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'way_ios',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAppCheck.instance.activate(
  //   // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
  //   // argument for `webProvider`
  //   webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  //   // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
  //   // your preferred provider. Choose from:
  //   // 1. Debug provider
  //   // 2. Safety Net provider
  //   // 3. Play Integrity provider
  //   androidProvider: AndroidProvider.debug,
  //   // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
  //   // your preferred provider. Choose from:
  //   // 1. Debug provider
  //   // 2. Device Check provider
  //   // 3. App Attest provider
  //   // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
  //   appleProvider: AppleProvider.appAttest,
  // );
  DioHelper.init();
  await CacheHelper.init();
  Widget widget;
  dynamic onBoarding = CacheHelper.getData(key: 'onBoarding');
  dynamic token = CacheHelper.getData(key: 'token');
  dynamic captientoken = CacheHelper.getData(key: 'Captientoken');

  print(token);
  userToken = token;
  if (onBoarding != null) {
    if (captientoken != null) {
      widget = const SplashScreen(screen: CaptainLayoutScreen());
    } else if (token != null) {
      widget = const SplashScreen(screen: LayoutScreen());
    } else {
      widget = const SplashScreen(screen: SelectedScreen());
    }
  } else {
    widget = const SplashScreen(screen: OnboardingScreen());
  }

  print("onsoosoasosa");
  print(onBoarding);
  print(userToken);
  print(token);
  print(captientoken);

  setupGetIt();
  await FirebaseNotifications().initNotifications();

  runApp(MyApp(
    startWidget: widget,
  ));
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
            create: (context) => passengerCubit()
              ..getAllOffers()
              ..getActivities()
              ..getUserData()),
        BlocProvider<MapsCubit>(
          create: (context) => MapsCubit(
            MapsRepository(
              PlacesWebservices(), // Pass an instance of PlacesWebservices
            ), // Make sure to instantiate MapsRepository
          ),
        ),
        BlocProvider(
          create: (context) => LocalizationCubit()..loadLanguage('en'),
        ),
        BlocProvider(
          create: (context) =>
              CaptainGetDriverReservationCubit()..getCaptainDriverReservation(),
        ),
        BlocProvider(
          create: (context) => CaptainCancelReservationOfferCubit(),
        ),
        BlocProvider(
          create: (context) =>
              CaptainGetReservationCubit()..getCaptainReservation(),
        ),
        BlocProvider(
          create: (context) => CaptainGetMessageCubit()..getCaptainMessage(),
        ),
        BlocProvider(
          create: (context) => CaptainMakeReservationOfferCubit(),
        ),
        BlocProvider(
          create: (context) => DriverSetCurrentLocationCubit(),
        ),
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
        BlocProvider(
          create: (context) => CaptainMakeOfferCubit(),
        ),
        BlocProvider(
          create: (context) => SetArriveRideCubit(),
        ),
        BlocProvider(
          create: (context) => SetRideCompleteCubit(),
        ),
        BlocProvider(
          create: (context) => CaptainCancelOfferCubit(),
        ),
        BlocProvider(
          create: (context) => CaptainCancelRideOfferCubit(),
        ),
        BlocProvider(
          create: (context) => CameraModelCubit(),
        ),
      ],
      child: BlocBuilder<LocalizationCubit, Map<String, String>>(
        builder: (context, localizedStrings) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            scaffoldMessengerKey: snackbarKey,
            debugShowCheckedModeBanner: false,
            title: 'WAY',
            theme: ThemeData(
                fontFamily: 'Noto', scaffoldBackgroundColor: backGroundColor
                //primaryColor: primaryColor,
                //hintColor: threeColor,
                //primarySwatch: Colors.teal
                ),
            locale: Locale(context
                .read<LocalizationCubit>()
                .currentLanguage), // Set the locale based on the current language

            home: startWidget,
          );
        },
      ),
    );
  }
}
