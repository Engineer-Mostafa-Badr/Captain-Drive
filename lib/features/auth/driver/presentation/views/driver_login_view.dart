// ignore_for_file: avoid_print
import 'package:captain_drive/screens/captain/captain_forget_password_screen.dart';
import 'package:captain_drive/features/home/driver/presentation/views/captain_layout_screen.dart';
import '../../../../../core/di/get_it.dart';
import '../../../../../screens/captain/choose_your_vehicle_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:captain_drive/core/localization/localization_cubit.dart';
import '../../../../../core/storage/cache_helper.dart';
import '../../../../../core/components/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/components/widget.dart';
import 'package:flutter/material.dart';

import '../../domain/use_cases/driver_delete_account_usecase.dart';
import '../../domain/use_cases/driver_login_usecase.dart';
import '../../domain/use_cases/driver_logout_usecase.dart';
import '../../domain/use_cases/driver_sign_up_usecase.dart';
import '../cubit/driver_auth_cubit.dart';

class LoginCaptainScreen extends StatefulWidget {
  const LoginCaptainScreen({super.key});

  @override
  State<LoginCaptainScreen> createState() => _LoginCaptainScreenState();
}

class _LoginCaptainScreenState extends State<LoginCaptainScreen> {
  final TextEditingController emailTextController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  late String email, password;
  bool obscureText = true;

  bool isSignInSuccess = false;

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
      ],
      child: Scaffold(
        backgroundColor: AppColor.backGroundColor,
        body: BlocConsumer<DriverAuthCubit, DriverAuthState>(
          listener: (context, state) {
            if (state is DriverAuthSuccess) {
              Navigator.pushReplacement(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(
                    builder: (context) => const CaptainLayoutScreen()),
              );
            }
          },

          builder: (context, state) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ModalProgressHUD(
                inAsyncCall: state is DriverAuthLoading,
                progressIndicator: const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryColor,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Image.asset(
                          'assets/images/b41.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: _formKey,
                            autovalidateMode: autovalidateMode,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: isArabic
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.arrow_circle_left_outlined,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                Text(
                                  isArabic ? 'تسجيل الدخول' : 'Login',
                                  style: const TextStyle(
                                      fontSize: 35, fontFamily: 'inter200'),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                TextFormField(
                                  textAlign: isArabic
                                      ? TextAlign.end
                                      : TextAlign.start,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    email = value!;
                                  },
                                  decoration: InputDecoration(
                                    hintText: languageCode == 'ar'
                                        ? 'البريد الإلكتروني أو رقم الهاتف'
                                        : 'Email or phone number',
                                    hintStyle: TextStyle(
                                        color: Colors.grey[600],
                                        fontFamily: 'inter200'),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  textAlign: isArabic
                                      ? TextAlign.end
                                      : TextAlign.start,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    password = value!;
                                  },
                                  obscureText: obscureText,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                    // Conditionally display prefixIcon or suffixIcon based on isArabic
                                    prefixIcon: isArabic
                                        ? GestureDetector(
                                            onTap: () {
                                              obscureText = !obscureText;
                                              setState(() {});
                                            },
                                            child: obscureText
                                                ? Icon(
                                                    Icons.remove_red_eye,
                                                    color: Colors.grey[600],
                                                  )
                                                : Icon(
                                                    Icons.visibility_off,
                                                    color: Colors.grey[600],
                                                  ),
                                          )
                                        : null,

                                    suffixIcon: !isArabic
                                        ? GestureDetector(
                                            onTap: () {
                                              obscureText = !obscureText;
                                              setState(() {});
                                            },
                                            child: obscureText
                                                ? Icon(
                                                    Icons.remove_red_eye,
                                                    color: Colors.grey[600],
                                                  )
                                                : Icon(
                                                    Icons.visibility_off,
                                                    color: Colors.grey[600],
                                                  ),
                                          )
                                        : null,
                                    hintText: languageCode == 'ar'
                                        ? 'كلمة المرور'
                                        : 'Password',
                                    hintStyle: TextStyle(
                                        color: Colors.grey[600],
                                        fontFamily: 'inter200'),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: DecoratedBox(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: AppColor.primaryColor,
                                          width:
                                              1.0, // Adjust the width of the line as needed
                                        ),
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const CaptainForgetPasswordScreen()));
                                      },
                                      child: Text(
                                        isArabic
                                            ? 'هل نسيت كلمة السر'
                                            : 'Forgot Password',
                                        style: const TextStyle(
                                          color: AppColor.primaryColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                                customButton(
                                    title: isArabic ? 'تسجيل الدخول' : 'Login',
                                    function: () {
                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             const CaptainLayoutScreen()));
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        // DriverAuthCubit.get(context)
                                        //     .signInCaptain(
                                        //   context: context,
                                        //   email: email,
                                        //   password: password,
                                        // );
                                      } else {
                                        setState(() {
                                          autovalidateMode =
                                              AutovalidateMode.always;
                                        });
                                      }
                                    }),
                                const SizedBox(
                                  height: 20,
                                ),
                                isArabic
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ChooseYourVehicleScreen()));
                                            },
                                            child: const DecoratedBox(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color:
                                                        AppColor.primaryColor,
                                                    width:
                                                        1.0, // Adjust the width of the line as needed
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                'سجل',
                                                style: TextStyle(
                                                  color: AppColor.primaryColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Text('ليس لديك حساب؟'),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text('Don’t have an account?'),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ChooseYourVehicleScreen()));
                                            },
                                            child: const DecoratedBox(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color:
                                                        AppColor.primaryColor,
                                                    width:
                                                        1.0, // Adjust the width of the line as needed
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                'Sign up',
                                                style: TextStyle(
                                                  color: AppColor.primaryColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          // );
          // },
        ),
      ),
    );
  }
}
