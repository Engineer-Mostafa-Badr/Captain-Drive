import 'package:captain_drive/business_logic/captain_auth/captain_get_profile_data_cubit/captain_get_profile_data_cubit.dart';
import 'package:captain_drive/business_logic/driver_status_cubit/driver_status_cubit.dart';
import 'package:captain_drive/core/components/constant.dart';
import 'package:captain_drive/core/components/widget.dart';
import 'package:captain_drive/data/models/captain_get_data_model/captain_get_data_model.dart';

import 'package:captain_drive/screens/captain/captain_change_password.dart';
import 'package:captain_drive/screens/captain/captain_notification_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

import '../../core/di/get_it.dart';
import '../../core/storage/cache_helper.dart';
import '../../features/auth/driver/domain/use_cases/driver_delete_account_usecase.dart';
import '../../features/auth/driver/domain/use_cases/driver_login_usecase.dart';
import '../../features/auth/driver/domain/use_cases/driver_logout_usecase.dart';
import '../../features/auth/driver/domain/use_cases/driver_sign_up_usecase.dart';
import '../../features/auth/driver/presentation/cubit/driver_auth_cubit.dart';
import '../../features/auth/driver/presentation/views/driver_login_view.dart';
import '../../core/localization/localization_cubit.dart';
import '../../features/map/driver/presentation/views/google_map_view.dart';

class CaptainProfileScreen extends StatefulWidget {
  const CaptainProfileScreen({super.key});

  @override
  State<CaptainProfileScreen> createState() => _CaptainProfileScreenState();
}

class _CaptainProfileScreenState extends State<CaptainProfileScreen> {
  CaptainGetDataModel? captainGetDataModel;

  final _controller = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    loadLanguage();
  }

  String? languageCode; // Variable to hold the language code

  Future<void> loadLanguage() async {
    languageCode = await CacheHelper.getData(key: 'languageCode') ??
        'en'; // Default to 'en' if not set
    // ignore: use_build_context_synchronously
    context.read<LocalizationCubit>().loadLanguage(languageCode!);
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = LocalizationCubit.get(context).isArabic();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DriverAuthCubit(
            loginUseCase: DriverLoginUseCase(sl()),
            signUpUseCase: DriverSignUpUseCase(sl()),
            logoutUseCase: DriverLogoutUseCase(sl()),
            deleteAccountUseCase: DriverDeleteAccountUseCase(sl()),
          ),
        ),
        BlocProvider(
          create: (context) => DriverStatusCubit(),
        ),
        BlocProvider(
          create: (context) => CaptainGetProfileDataCubit()..getCaptainData(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColor.backGroundColor,
        body: SafeArea(
          child: BlocConsumer<CaptainGetProfileDataCubit,
              CaptainGetProfileDataState>(
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
              return SingleChildScrollView(
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
                                  color: AppColor.backGroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26, // Shadow color
                                      blurRadius: 2, // Softening the shadow
                                      spreadRadius: 0.5, // Extending the shadow
                                      offset: Offset(0,
                                          0), // No offset to center the shadow
                                    ),
                                  ],
                                  border: Border.all(
                                    color:
                                        const Color.fromRGBO(189, 189, 189, 1),
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                              ),
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
                                  style: const TextStyle(
                                      color: AppColor.primaryColor),
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CaptainNotificationScreen()));
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColor.backGroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26, // Shadow color
                                      blurRadius: 2, // Softening the shadow
                                      spreadRadius: 0.5, // Extending the shadow
                                      offset: Offset(0,
                                          0), // No offset to center the shadow
                                    ),
                                  ],
                                  border: Border.all(
                                    color:
                                        const Color.fromRGBO(189, 189, 189, 1),
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.notifications_none_outlined,
                                    color: AppColor.primaryColor,
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
                          padding: const EdgeInsets.all(10),
                          child: isArabic
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            captainGetDataModel
                                                    ?.data?.user?.name ??
                                                'الاسم',
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(height: 16),
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    '${captainGetDataModel?.data?.user?.superKey ?? '***'}${captainGetDataModel?.data?.user?.uniqueId ?? '*****'}',
                                                    style: const TextStyle(
                                                      color: Color(0XFF919191),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  const Text(
                                                    ': الكود',
                                                    style: TextStyle(
                                                      color: Color(0XFF919191),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  const Text(
                                                    'ج',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Color(0XFF919191),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    '${captainGetDataModel?.data?.user?.wallet?.balance ?? 0.0}',
                                                    style: const TextStyle(
                                                      color: Color(0xFF0A8800),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const Text(
                                                    ' : رصيدك',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                              height:
                                                  8), // Add some space before the divider
                                          const Divider(
                                            color: Colors.black26,
                                            thickness: 1,
                                          ),
                                          isArabic
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      captainGetDataModel
                                                                  ?.data
                                                                  ?.user
                                                                  ?.vehicle
                                                                  ?.type ==
                                                              1
                                                          ? isArabic
                                                              ? "سيارة "
                                                              : "Car"
                                                          : captainGetDataModel
                                                                      ?.data
                                                                      ?.user
                                                                      ?.vehicle
                                                                      ?.type ==
                                                                  2
                                                              ? isArabic
                                                                  ? "سيارة مكيفه"
                                                                  : "Conditioned Car"
                                                              : captainGetDataModel
                                                                          ?.data
                                                                          ?.user
                                                                          ?.vehicle
                                                                          ?.type ==
                                                                      3
                                                                  ? isArabic
                                                                      ? " دراجة نارية"
                                                                      : "MotorCycle"
                                                                  : captainGetDataModel
                                                                              ?.data
                                                                              ?.user
                                                                              ?.vehicle
                                                                              ?.type ==
                                                                          4
                                                                      ? isArabic
                                                                          ? "تاكسي"
                                                                          : "Taxi"
                                                                      : captainGetDataModel?.data?.user?.vehicle?.type ==
                                                                              5
                                                                          ? isArabic
                                                                              ? 'باص'
                                                                              : "Bus"
                                                                          : "0",
                                                    ),
                                                    const Text(': السياره '),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    const Text('Vehicle : '),
                                                    Text(
                                                      captainGetDataModel
                                                                  ?.data
                                                                  ?.user
                                                                  ?.vehicle
                                                                  ?.type ==
                                                              1
                                                          ? "Car"
                                                          : captainGetDataModel
                                                                      ?.data
                                                                      ?.user
                                                                      ?.vehicle
                                                                      ?.type ==
                                                                  2
                                                              ? "Conditioned Car"
                                                              : captainGetDataModel
                                                                          ?.data
                                                                          ?.user
                                                                          ?.vehicle
                                                                          ?.type ==
                                                                      3
                                                                  ? "Motor Cycle"
                                                                  : captainGetDataModel
                                                                              ?.data
                                                                              ?.user
                                                                              ?.vehicle
                                                                              ?.type ==
                                                                          4
                                                                      ? "Taxi"
                                                                      : captainGetDataModel?.data?.user?.vehicle?.type ==
                                                                              5
                                                                          ? "Bus"
                                                                          : "0",
                                                    ),
                                                  ],
                                                ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              RatingStars(
                                                value: captainGetDataModel
                                                        ?.data?.user?.rate ??
                                                    0.0,
                                                // onValueChanged: (v) {
                                                //   setState(() {
                                                //     captainGetDataModel
                                                //         ?.data?.user?.rate = v;
                                                //   });
                                                // },
                                                starBuilder: (index, color) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: color,
                                                ),
                                                starCount: 5,
                                                starSize: 20,
                                                valueLabelRadius: 10,
                                                maxValue: 5,
                                                starSpacing: 2,
                                                maxValueVisibility:
                                                    false, // Hide max value
                                                valueLabelVisibility:
                                                    false, // Hide value label
                                                animationDuration:
                                                    const Duration(
                                                        milliseconds: 1000),
                                                valueLabelPadding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 1,
                                                  horizontal: 8,
                                                ),
                                                valueLabelMargin:
                                                    const EdgeInsets.only(
                                                        right: 8),
                                                starOffColor:
                                                    const Color(0xffe7e8ea),
                                                starColor:
                                                    const Color(0xFFEE6501),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: ClipOval(
                                        child: captainGetDataModel
                                                    ?.data?.user?.picture !=
                                                null
                                            ? Image.network(
                                                "https://captain-drive.webbing-agency.com/storage/app/public/${captainGetDataModel?.data?.user?.picture}",
                                                fit: BoxFit.fill,
                                              )
                                            : Image.asset(
                                                'assets/images/image.png'),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: ClipOval(
                                        child: captainGetDataModel
                                                    ?.data?.user?.picture !=
                                                null
                                            ? Image.network(
                                                "https://captain-drive.webbing-agency.com/storage/app/public/${captainGetDataModel?.data?.user?.picture}",
                                                fit: BoxFit.fill,
                                              )
                                            : Image.asset(
                                                'assets/images/photo.png'),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            captainGetDataModel
                                                    ?.data?.user?.name ??
                                                'Name',
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              const Text(
                                                'id : ',
                                                style: TextStyle(
                                                  color: Color(0XFF919191),
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                '${captainGetDataModel?.data?.user?.superKey ?? '***'}${captainGetDataModel?.data?.user?.uniqueId ?? '*****'}',
                                                style: const TextStyle(
                                                  color: Color(0XFF919191),
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              const Text(
                                                'your balance : ',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                '${captainGetDataModel?.data?.user?.wallet?.balance ?? 0.0}',
                                                style: const TextStyle(
                                                  color: Color(0xFF0A8800),
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const Text(
                                                'EGP',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0XFF919191),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                              height:
                                                  8), // Add some space before the divider
                                          const Divider(
                                            color: Colors.black26,
                                            thickness: 1,
                                          ),
                                          Row(
                                            children: [
                                              const Text('Vehicle : '),
                                              Text(
                                                captainGetDataModel?.data?.user
                                                            ?.vehicle?.type ==
                                                        1
                                                    ? "Car"
                                                    : captainGetDataModel
                                                                ?.data
                                                                ?.user
                                                                ?.vehicle
                                                                ?.type ==
                                                            2
                                                        ? "Conditioned Car"
                                                        : captainGetDataModel
                                                                    ?.data
                                                                    ?.user
                                                                    ?.vehicle
                                                                    ?.type ==
                                                                3
                                                            ? "Motor Cycle"
                                                            : captainGetDataModel
                                                                        ?.data
                                                                        ?.user
                                                                        ?.vehicle
                                                                        ?.type ==
                                                                    4
                                                                ? "Taxi"
                                                                : captainGetDataModel
                                                                            ?.data
                                                                            ?.user
                                                                            ?.vehicle
                                                                            ?.type ==
                                                                        5
                                                                    ? "Bus"
                                                                    : "0",
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              RatingStars(
                                                value: captainGetDataModel
                                                        ?.data?.user?.rate ??
                                                    0.0,
                                                // onValueChanged: (v) {
                                                //   setState(() {
                                                //     captainGetDataModel
                                                //         ?.data?.user?.rate = v;
                                                //   });
                                                // },
                                                starBuilder: (index, color) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: color,
                                                ),
                                                starCount: 5,
                                                starSize: 20,
                                                valueLabelRadius: 10,
                                                maxValue: 5,
                                                starSpacing: 2,
                                                maxValueVisibility:
                                                    false, // Hide max value
                                                valueLabelVisibility:
                                                    false, // Hide value label
                                                animationDuration:
                                                    const Duration(
                                                        milliseconds: 1000),
                                                valueLabelPadding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 1,
                                                  horizontal: 8,
                                                ),
                                                valueLabelMargin:
                                                    const EdgeInsets.only(
                                                        right: 8),
                                                starOffColor:
                                                    const Color(0xffe7e8ea),
                                                starColor:
                                                    const Color(0xFFEE6501),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 36,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CaptainChangePasswordScreen()));
                        },
                        child: Container(
                          width: double.infinity,
                          height: 45,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEAEAEA),
                            border: Border(
                              bottom:
                                  BorderSide(color: Colors.black12, width: 2.0),
                              top:
                                  BorderSide(color: Colors.black12, width: 2.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      isArabic
                                          ? 'تغيير كلمة المرور'
                                          : 'Change Password',
                                      style: const TextStyle(
                                          color: Color(0xFF222222),
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 35,
                                  height: 30,
                                  child: Center(
                                    child: Image.asset(
                                        'assets/images/right_arrow.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      BlocConsumer<DriverStatusCubit, DriverStatusState>(
                        listener: (context, state) {
                          if (state is DriverStatusSuccess) {
                            if (state.driverStatusModel.status!) {
                            } else {
                              print(state.driverStatusModel.message);
                              showToast(
                                message: state.driverStatusModel.message!,
                                color: Colors.red,
                              );
                            }
                            if (state is DriverStatusFailure) {
                              showToast(
                                message: state.driverStatusModel.message!,
                                color: Colors.red,
                              );
                            }
                          }
                        },
                        builder: (context, state) {
                          var cubit = DriverStatusCubit.get(context);

                          bool isOnline =
                              captainGetDataModel?.data?.user?.status ==
                                  'online';

                          return Container(
                            width: double.infinity,
                            height: 45,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEAEAEA),
                              border: Border(
                                bottom: BorderSide(
                                    color: Colors.black12, width: 2.0),
                                top: BorderSide(
                                    color: Colors.black12, width: 2.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        isArabic ? 'حالة' : 'Status',
                                        style: const TextStyle(
                                          color: Color(0xFF222222),
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: AdvancedSwitch(
                                      controller: _controller,
                                      activeColor: Colors.green,
                                      inactiveColor: Colors.grey,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      width: 45,
                                      height: 20,
                                      enabled: true,
                                      disabledOpacity: 0.5,
                                      initialValue: isOnline,
                                      onChanged: (value) {
                                        String newStatus =
                                            value ? 'online' : 'offline';

                                        cubit.driverStatus(status: newStatus);

                                        _controller.value = value;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 149,
                      ),
                      BlocConsumer<DriverAuthCubit, DriverAuthState>(
                        listener: (context, state) {
                          if (state is DriverLogoutSuccess) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LoginCaptainScreen(),
                              ),
                            );
                            CacheHelper.removeData(
                              key: 'Captientoken',
                            );
                            CacheHelper.removeData(key: 'email');
                            //  else {
                            //   print(state.captainLogOutModel.message);
                            //   showToast(
                            //     message: state.captainLogOutModel.message,
                            //     color: Colors.red,
                            //   );
                            // }
                            // if (state is DriverLogOutFailure) {
                            //   showToast(
                            //     message: state.captainLogOutModel.message,
                            //     color: Colors.red,
                            //   );
                            // }
                          }
                        },
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () {
                              CacheHelper.removeData(key: 'Captientoken')
                                  .then((value) {
                                if (value) {
                                  print(userToken);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginCaptainScreen()));
                                }
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              height: 58,
                              decoration: BoxDecoration(
                                color: const Color(0xFFED5454),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  isArabic ? 'تسجيل الخروج' : 'Logout',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
