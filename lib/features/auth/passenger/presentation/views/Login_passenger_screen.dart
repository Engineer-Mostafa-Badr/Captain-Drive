import 'package:captain_drive/screens/passenger/forget_password_screen.dart';
import 'package:captain_drive/features/home/passenger/presentation/views/layout_screen.dart';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/components/constant.dart';
import '../../../../../core/components/widget.dart';
import '../../../../../core/di/get_it.dart';
import '../../../../../core/localization/localization_cubit.dart';
import '../../../../../core/storage/cache_helper.dart';
import '../../../auth_selector/presentation/views/select_auth_type_view.dart';
import '../../domain/use_cases/passenger_delete_account_usecase.dart';
import '../../domain/use_cases/passenger_login_usecase.dart';
import '../../domain/use_cases/passenger_logout_usecase.dart';
import '../../domain/use_cases/passenger_signup_usecase.dart';
import '../cubit/passenger_auth_cubit.dart';
import 'signup_passenger_screen.dart';

class LoginPassengerScreen extends StatefulWidget {
  const LoginPassengerScreen({super.key});

  @override
  State<LoginPassengerScreen> createState() => _LoginPassengerScreenState();
}

class _LoginPassengerScreenState extends State<LoginPassengerScreen> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  String? email, password;

  String? languageCode; // Variable to hold the language code

  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    // Load saved language code from SharedPreferences
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    languageCode = await CacheHelper.getData(key: 'languageCode') ??
        'en'; // Default to 'en' if not set
    context.read<LocalizationCubit>().loadLanguage(languageCode!);
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = LocalizationCubit.get(context).isArabic();

    return BlocProvider(
      create: (context) => PassengerAuthCubit(
        loginUseCase: PassengerLoginUseCase(sl()),
        signUpUseCase: PassengerSignUpUseCase(sl()),
        logoutUseCase: PassengerLogoutUseCase(sl()),
        deleteAccountUseCase: PassengerDeleteAccountUseCase(sl()),
      ),
      child: Scaffold(
        backgroundColor: AppColor.backGroundColor,
        body: BlocConsumer<PassengerAuthCubit, PassengerAuthState>(
          listener: (context, state) {
            if (state is PassengerAuthSuccess) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LayoutScreen()));
            }

            if (state is PassengerAuthFailure) {
              showToast(
                message: state.message,
                color: Colors.red,
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: isArabic
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SelectedScreen()));
                                    },
                                    icon: const Icon(
                                      Icons.arrow_circle_left_outlined,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 50),
                              Text(
                                languageCode == 'ar'
                                    ? 'تسجيل الدخول'
                                    : 'Login', // Localization
                                style: const TextStyle(
                                    fontSize: 45, fontFamily: 'inter200'),
                              ),
                              const SizedBox(height: 40),
                              TextFormField(
                                textAlign:
                                    isArabic ? TextAlign.end : TextAlign.start,
                                controller: emailTextController,
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
                              const SizedBox(height: 20),
                              TextFormField(
                                textAlign:
                                    isArabic ? TextAlign.end : TextAlign.start,
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
                              const SizedBox(height: 30),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgetPasswordScreen()));
                                },
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
                                  child: Text(
                                    languageCode == 'ar'
                                        ? 'نسيت كلمة المرور'
                                        : 'Forgot Password',
                                    style: const TextStyle(
                                      color: AppColor.primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 50),
                              const SizedBox(height: 60),
                              ConditionalBuilder(
                                condition: state is! PassengerAuthLoading,
                                builder: (context) => customButton(
                                  title: languageCode == 'ar'
                                      ? 'تسجيل الدخول'
                                      : 'Login',
                                  function: () {
                                    _formKey.currentState!.save();
                                    // PassengerAuthCubit.get(context).userLogin(
                                    //   context: context,
                                    //   email: email!,
                                    //   password: password!,
                                    // );
                                  },
                                ),
                                fallback: (context) => const Center(
                                    child: CircularProgressIndicator()),
                              ),
                              const SizedBox(height: 20),
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
                                                        const SignUpPassengerScreen()));
                                          },
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
                                            child: Text(
                                              languageCode == 'ar'
                                                  ? 'سجل'
                                                  : 'Sign up',
                                              style: const TextStyle(
                                                color: AppColor.primaryColor,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(languageCode == 'ar'
                                            ? 'ليس لديك حساب؟'
                                            : 'Don’t have an account?'),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(languageCode == 'ar'
                                            ? 'ليس لديك حساب؟'
                                            : 'Don’t have an account?'),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SignUpPassengerScreen()));
                                          },
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
                                            child: Text(
                                              languageCode == 'ar'
                                                  ? 'سجل'
                                                  : 'Sign up',
                                              style: const TextStyle(
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
            );
          },
        ),
      ),
    );
  }
}
