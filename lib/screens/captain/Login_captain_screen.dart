import 'package:captain_drive/business_logic/captain_auth/sign_in_captain_cubit/cubit/sign_in_captain_cubit.dart';
import 'package:captain_drive/screens/captain/captain_forget_password_screen.dart';
import 'package:captain_drive/screens/captain/captain_layout_screen.dart';
import 'package:captain_drive/screens/captain/chat/domain/repos/auth_repo.dart';
import 'package:captain_drive/screens/captain/chat/manager/firebase_sign_in_cubit/firebase_sign_in_cubit.dart';
import 'package:captain_drive/screens/captain/chat/services/get_it_service.dart';
import 'package:captain_drive/shared/local/cach_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../components/constant.dart';
import '../../../components/widget.dart';
import '../../localization/localization_cubit.dart';
import 'choose_your_vehicle_screen.dart';

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

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignInCaptainCubit(),
        ),
        BlocProvider(
          create: (context) => FirebaseSignInCubit(
            getIt<AuthRepo>(),
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: backGroundColor,
        body: BlocConsumer<SignInCaptainCubit, SignInCaptainState>(
          listener: (context, state) {
            if (state is SignInCaptainSuccess) {
              if (state.captainLoginModel.status) {
                CacheHelper.saveData(
                        key: 'Captientoken',
                        value: state.captainLoginModel.data?.token)
                    .then((value) {
                  CaptienToken = state.captainLoginModel.data?.token;
                  print(CaptienToken);
                  setState(() {
                    isSignInSuccess = true;
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CaptainLayoutScreen()),
                  );

                  // context
                  //     .read<FirebaseSignInCubit>()
                  //     .signInWithEmailAndPassword(
                  //       email,
                  //       password,
                  //     );
                });
              } else {
                print(state.captainLoginModel.message);
                print('تاكد من البيانات المدخله');
                showToast(
                  message: state.captainLoginModel.message,
                  color: Colors.red,
                );
              }
              if (state is SignInCaptainFailure) {
                showToast(
                  message: state.captainLoginModel.message,
                  color: Colors.red,
                );
              }
            }
          },
          builder: (context, state) {
            // return BlocConsumer<FirebaseSignInCubit, FirebaseSignInState>(
            //   listener: (context, state) {
            //     if (state is FirebaseSignInSuccess && isSignInSuccess) {
            //       CacheHelper.saveData(
            //           key: 'name', value: state.userEntity.name);
            //       CacheHelper.saveData(
            //               key: 'email', value: state.userEntity.email)
            //           .then((value) {
            //         userEmail = state.userEntity.email;
            //         print(userEmail);
            //         Navigator.pushReplacement(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => const CaptainLayoutScreen()),
            //         );
            //       });
            //     }
            //
            //     if (state is FirebaseSignInFailure) {
            //       showToast(
            //         message: state.message,
            //         color: Colors.red,
            //       );
            //     }
            //   },
            //   builder: (context, state) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ModalProgressHUD(
                inAsyncCall: state is SignInCaptainLoading,
                progressIndicator: const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
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
                                          color: primaryColor,
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
                                          color: primaryColor,
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
                                        SignInCaptainCubit.get(context)
                                            .signInCaptain(
                                          context: context,
                                          email: email,
                                          password: password,
                                        );
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
                                                    color: primaryColor,
                                                    width:
                                                        1.0, // Adjust the width of the line as needed
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                'سجل',
                                                style: TextStyle(
                                                  color: primaryColor,
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
                                                    color: primaryColor,
                                                    width:
                                                        1.0, // Adjust the width of the line as needed
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                'Sign up',
                                                style: TextStyle(
                                                  color: primaryColor,
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
