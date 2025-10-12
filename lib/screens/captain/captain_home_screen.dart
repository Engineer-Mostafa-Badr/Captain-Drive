import 'package:captain_drive/business_logic/captain_auth/captain_get_profile_data_cubit/captain_get_profile_data_cubit.dart';
import 'package:captain_drive/business_logic/captain_get_message_cubit/captain_get_message_cubit.dart';
import 'package:captain_drive/business_logic/remove_driver_cubit/remove_driver_cubit.dart';
import 'package:captain_drive/components/constant.dart';
import 'package:captain_drive/components/widget.dart';
import 'package:captain_drive/data/models/captain_get_data_model/captain_get_data_model.dart';
import 'package:captain_drive/data/models/captain_get_message_model.dart';
import 'package:captain_drive/screens/captain/captain_map/views/google_map_view.dart';
import 'package:captain_drive/screens/captain/captain_notification_screen.dart';
import 'package:captain_drive/screens/captain/choose_your_vehicle_screen.dart';
import 'package:captain_drive/shared/local/cach_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../localization/localization_cubit.dart';

class CaptainHomeScreen extends StatefulWidget {
  const CaptainHomeScreen({super.key});

  @override
  State<CaptainHomeScreen> createState() => _CaptainHomeScreenState();
}

class _CaptainHomeScreenState extends State<CaptainHomeScreen> {
  CaptainGetDataModel? captainGetDataModel;
  CaptainGetMessageModel? captainGetMessageModel;
  bool _hasDialogBeenShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasDialogBeenShown) {
        // Call the function to check and possibly show the message
        _checkAndShowDialog(context);
      }
    });
    loadLanguage();
  }

  String? languageCode; // Variable to hold the language code

  Future<void> loadLanguage() async {
    languageCode = await CacheHelper.getData(key: 'languageCode') ??
        'en'; // Default to 'en' if not set
    context.read<LocalizationCubit>().loadLanguage(languageCode!);
  }

  Future<void> _checkAndShowDialog(BuildContext context) async {
    // Create a variable to store the result from the bloc
    CaptainGetMessageModel? messageModel;

    // Trigger the bloc to get the message
    final captainGetMessageCubit = context.read<CaptainGetMessageCubit>();
    captainGetMessageCubit
        .getCaptainMessage(); // Assuming this method triggers the state change

    // Listen to the state and capture the result
    await Future.delayed(
        const Duration(milliseconds: 500)); // Small delay to ensure state update

    final state = captainGetMessageCubit.state;
    if (state is CaptainGetMessageSuccess) {
      messageModel = state.captainGetMessageModel;
    }

    if (messageModel != null && messageModel.status) {
      setState(() {
        _hasDialogBeenShown = true;
      });
      _showDialog(context, messageModel);
    }
  }

  void _showDialog(BuildContext context, CaptainGetMessageModel messageModel) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider(
          create: (context) => RemoveDriverCubit(),
          child: BlocConsumer<RemoveDriverCubit, RemoveDriverState>(
            listener: (context, state) {
              if (state is RemoveDriverSuccess) {
                if (state.removeDriverModel.status) {
                  CacheHelper.removeDate(key: 'token').then((value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChooseYourVehicleScreen(),
                      ),
                    );
                  });
                  showToast(
                      message: state.removeDriverModel.message,
                      color: Colors.green);
                }
              } else if (state is RemoveDriverFailure) {
                showToast(message: state.message, color: Colors.red);
              }
            },
            builder: (context, state) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.all(20.0),
                backgroundColor: const Color(0xffF2F2F2),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/iconamoon_question-mark-circle.png',
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      messageModel.data?.message ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontFamily: 'PoppinsBold',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    customMapButton(
                      width: double.infinity,
                      height: 50,
                      title: 'OK',
                      color: primaryColor,
                      function: () {
                        if (messageModel.data?.status == 2) {
                          // Remove captain if status is 2
                          RemoveDriverCubit.get(context).captainRemover();
                        } else if (messageModel.data?.status == 3 ||
                            messageModel.data?.status == 4) {
                          // Close the dialog and perform any additional actions
                          Navigator.of(context).pop(); // Close the dialog
                          // Optionally, add application exit logic if required
                          SystemNavigator.pop();
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = LocalizationCubit.get(context).isArabic();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CaptainGetProfileDataCubit()..getCaptainData(),
        ),
      ],
      child:
          BlocConsumer<CaptainGetProfileDataCubit, CaptainGetProfileDataState>(
        listener: (context, state) {
          if (state is CaptainGetProfileDataSuccess) {
            if (state.captainGetDataModel.status!) {
              setState(() {
                captainGetDataModel = state.captainGetDataModel;
              });
            } else {
              print(state.captainGetDataModel.message);
              showToast(
                message: state.captainGetDataModel.message!,
                color: Colors.red,
              );
            }
            if (state is CaptainGetProfileDataFailure) {
              showToast(
                message: state.captainGetDataModel.message!,
                color: Colors.red,
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: backGroundColor,
            body: SafeArea(
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Opacity(
                      opacity: 0.3,
                      child: Image.asset(
                        'assets/images/backff.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const GoogleMapView()));
                                  },
                                  child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: backGroundColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors
                                                  .black26, // Shadow color
                                              blurRadius:
                                                  2, // Softening the shadow
                                              spreadRadius:
                                                  0.5, // Extending the shadow
                                              offset: Offset(0,
                                                  0), // No offset to center the shadow
                                            ),
                                          ],
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  189, 189, 189, 1))),
                                      child: const Center(
                                          child: Icon(
                                        Icons.location_on_outlined,
                                        color: primaryColor,
                                      ))),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  children: [
                                    Text(
                                      isArabic ? 'مكانك' : 'Location',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Text(
                                      isArabic ? 'مصر' : 'Egypt',
                                      style: const TextStyle(color: primaryColor),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: backGroundColor,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26, // Shadow color
                                          blurRadius: 2, // Softening the shadow
                                          spreadRadius:
                                              0.5, // Extending the shadow
                                          offset: Offset(0,
                                              0), // No offset to center the shadow
                                        ),
                                      ],
                                      border: Border.all(
                                          color: const Color.fromRGBO(
                                              189, 189, 189, 1))),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const CaptainNotificationScreen()));
                                    },
                                    child: const Center(
                                      child: Icon(
                                        Icons.notifications_none_outlined,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: const Color(0xFFF3F3F3),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  spreadRadius: 0.5,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    child: isArabic
                                        ? Row(
                                            children: [
                                              Text(
                                                '${captainGetDataModel?.data?.user?.wallet?.balance ?? 0.0}',
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xFF0A8800),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const Text(
                                                'ج',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                              const Spacer(),
                                              const Text(
                                                'رصيدك',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              const Text(
                                                'Your Balance',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '${captainGetDataModel?.data?.user?.wallet?.balance ?? 0.0}',
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xFF0A8800),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const Text(
                                                'EGP',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                  isArabic
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${captainGetDataModel?.data?.user?.superKey ?? '***'}${captainGetDataModel?.data?.user?.uniqueId ?? '****'}',
                                                style: const TextStyle(
                                                  color: Color(0XFF919191),
                                                ),
                                              ),
                                              const Text(
                                                ': الكود',
                                                style: TextStyle(
                                                  color: Color(0XFF919191),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Row(
                                            children: [
                                              const Text(
                                                'Code : ',
                                                style: TextStyle(
                                                  color: Color(0XFF919191),
                                                ),
                                              ),
                                              Text(
                                                '${captainGetDataModel?.data?.user?.superKey ?? '***'}${captainGetDataModel?.data?.user?.uniqueId ?? '****'}',
                                                style: const TextStyle(
                                                  color: Color(0XFF919191),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 53,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      customCaptainHomeButton(
                                        title: isArabic
                                            ? 'إعادة الشحن'
                                            : 'Recharge',
                                        function: () {},
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 110,
                          ),
                          isArabic
                              ? const Text(
                                  '! انتقل إلى الخريطة وابدأ العمل الآن',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                )
                              : const Text(
                                  'Go to Map and \nstart Work now !',
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.black),
                                ),
                          const SizedBox(
                            height: 70,
                          ),
                          customButton(
                            title: isArabic ? 'الخريطة' : 'Map',
                            function: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const GoogleMapView()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
