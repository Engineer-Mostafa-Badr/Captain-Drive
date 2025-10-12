import 'package:captain_drive/components/widget.dart';
import 'package:captain_drive/screens/passenger/authintaction/Login_passenger_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/constant.dart';
import '../../localization/localization_cubit.dart';
import '../../shared/local/cach_helper.dart';

class PasswordChangedSuccessfullyScreen extends StatefulWidget {
  const PasswordChangedSuccessfullyScreen({super.key});

  @override
  State<PasswordChangedSuccessfullyScreen> createState() =>
      _PasswordChangedSuccessfullyScreenState();
}

class _PasswordChangedSuccessfullyScreenState
    extends State<PasswordChangedSuccessfullyScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadLanguage();
  }

  String? languageCode; // Variable to hold the language code

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
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  'assets/images/b41.png',
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 250,
                      ),
                      Container(
                        height: 411,
                        width: 347,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFFE2E2E2),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26, // Shadow color
                              blurRadius: 5, // Softening the shadow
                              spreadRadius: 0.5, // Extending the shadow
                              offset: Offset(
                                  0, 0), // No offset to center the shadow
                            ),
                          ],
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Big Circle
                            Positioned(
                              top: -91, // Half of the big circle's height
                              left: (347 - 182) / 2, // Center horizontally
                              child: Container(
                                width: 182,
                                height: 182,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFB5C3DD),
                                ),
                              ),
                            ),
                            // Small Circle
                            Positioned(
                              top: -75, // Adjust accordingly for visual appeal
                              left: (347 - 149) / 2, // Center horizontally
                              child: Container(
                                width: 149,
                                height: 149,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF3A68BF),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/check.png',
                                    width: 46,
                                    height: 36,
                                  ),
                                ),
                              ),
                            ),
                            // Centered Text
                            Center(
                              child: Text(
                                isArabic
                                    ? 'تم تغيير كلمة المرور بنجاح'
                                    : 'Password Changed Successfully',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5E5E5E),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // Button at the bottom
                            Positioned(
                              bottom: 20,
                              left: (320 - 200) / 2, // Center horizontally
                              child: SizedBox(
                                width: 225, // Adjust as needed
                                child: customButton(
                                  title: isArabic
                                      ? ' تسجيل الدخول'
                                      : 'Back to Login',
                                  function: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPassengerScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
