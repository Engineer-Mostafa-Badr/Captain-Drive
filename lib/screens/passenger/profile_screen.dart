import 'package:captain_drive/components/constant.dart';
import 'package:captain_drive/screens/passenger/change_password_screen.dart';
import 'package:captain_drive/screens/passenger/cubit/cubit.dart';
import 'package:captain_drive/screens/passenger/profile_information_screen.dart';
import 'package:captain_drive/screens/passenger/technecal_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../localization/localization_cubit.dart';
import '../../shared/local/cach_helper.dart';
import 'authintaction/Login_passenger_screen.dart';
import 'information_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Load saved language code from SharedPreferences
    loadLanguage();
    PassengerCubit.get(context).getUserData();
  }

  String? languageCode;
  // Variable to hold the language code
  Future<void> loadLanguage() async {
    languageCode = await CacheHelper.getData(key: 'languageCode') ??
        'en'; // Default to 'en' if not set
    context.read<LocalizationCubit>().loadLanguage(languageCode!);
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = LocalizationCubit.get(context).isArabic();

    return Scaffold(
      backgroundColor: backGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10, top: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: backGroundColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26, // Shadow color
                                  blurRadius: 2, // Softening the shadow
                                  spreadRadius: 0.5, // Extending the shadow
                                  offset: Offset(
                                      0, 0), // No offset to center the shadow
                                ),
                              ],
                              border: Border.all(
                                  color:
                                      const Color.fromRGBO(189, 189, 189, 1))),
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
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        Text(
                          isArabic ? 'مصر' : 'Egypte',
                          style: const TextStyle(color: primaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const PersonalInformationScreen()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFEAEAEA),
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
                                    ? 'المعلومات شخصية'
                                    : 'Personal Information',
                                style: const TextStyle(
                                    color: Color(0xFF222222), fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 35,
                            height: 30,
                            child: Center(
                              child:
                                  Image.asset('assets/images/right_arrow.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ChangePasswordScreen()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFEAEAEA),
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
                                    color: Color(0xFF222222), fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 35,
                            height: 30,
                            child: Center(
                              child:
                                  Image.asset('assets/images/right_arrow.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const TechenecalSupportScreen()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFEAEAEA),
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
                                isArabic ? 'الدعم الفني' : 'technical support',
                                style: const TextStyle(
                                    color: Color(0xFF222222), fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 35,
                            height: 30,
                            child: Center(
                              child:
                                  Image.asset('assets/images/right_arrow.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InformationScreen()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFEAEAEA),
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
                                    ? 'WAY ارشادات مجتمع '
                                    : 'WAY Community Guidelines',
                                style: const TextStyle(
                                    color: Color(0xFF222222), fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 35,
                            height: 30,
                            child: Center(
                              child:
                                  Image.asset('assets/images/right_arrow.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    CacheHelper.removeData(key: 'token').then((value) {
                      if (value) {
                        print(userToken);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LoginPassengerScreen()));
                      }
                    });
                    showSnackbar(
                        context, 'Successes Delete Account ', Colors.green);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFEAEAEA),
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
                                isArabic ? 'حذف الحساب' : 'Delete Account',
                                style: const TextStyle(
                                    color: Color(0xFF222222), fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 35,
                            height: 30,
                            child: Center(
                              child:
                                  Image.asset('assets/images/right_arrow.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 137,
              ),
              GestureDetector(
                onTap: () {
                  CacheHelper.removeData(key: 'token').then((value) {
                    if (value) {
                      print(userToken);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const LoginPassengerScreen()));
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
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
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackbar(BuildContext context, String message, Color? color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
