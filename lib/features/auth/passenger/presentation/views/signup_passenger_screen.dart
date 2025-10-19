import 'package:captain_drive/features/home/passenger/presentation/views/layout_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/components/constant.dart';
import '../../../../../core/components/widget.dart';
import '../../../../../core/di/get_it.dart';
import '../../../../../core/localization/localization_cubit.dart';
import '../../../../../core/storage/cache_helper.dart';
import '../../domain/use_cases/passenger_delete_account_usecase.dart';
import '../../domain/use_cases/passenger_login_usecase.dart';
import '../../domain/use_cases/passenger_logout_usecase.dart';
import '../../domain/use_cases/passenger_signup_usecase.dart';
import '../cubit/passenger_auth_cubit.dart';
import 'Login_passenger_screen.dart';

class SignUpPassengerScreen extends StatefulWidget {
  const SignUpPassengerScreen({super.key});

  @override
  State<SignUpPassengerScreen> createState() => _SignUpPassengerScreenState();
}

class _SignUpPassengerScreenState extends State<SignUpPassengerScreen> {
  final TextEditingController nameTextController = TextEditingController();

  final TextEditingController phoneTextController = TextEditingController();

  final TextEditingController emailTextController = TextEditingController();

  final TextEditingController confirmPasswordTextController =
      TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  String? name, email, phone, gender, password, confirmPassword;

  String? languageCode; // Variable to hold the language code

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
            if (state is PassengerAuthSuccess ||
                state is PassengerLogInSuccess) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LayoutScreen()));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
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
                              languageCode == 'ar' ? 'سجل' : 'Sign Up',
                              style: const TextStyle(
                                  fontSize: 45, fontFamily: 'inter200'),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            TextFormField(
                              textAlign:
                                  isArabic ? TextAlign.end : TextAlign.start,
                              onSaved: (value) {
                                name = value!;
                              },
                              decoration: InputDecoration(
                                hintText:
                                    languageCode == 'ar' ? 'الاسم' : 'Name',
                                hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: 'inter200'),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              textAlign:
                                  isArabic ? TextAlign.end : TextAlign.start,
                              onSaved: (value) {
                                phone = value!;
                              },
                              decoration: InputDecoration(
                                hintText: languageCode == 'ar'
                                    ? 'رقم التليفون'
                                    : 'Phone Number',
                                hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: 'inter200'),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              textAlign:
                                  isArabic ? TextAlign.end : TextAlign.start,
                              onSaved: (value) {
                                email = value!;
                              },
                              decoration: InputDecoration(
                                hintText:
                                    languageCode == 'ar' ? 'الايميل' : 'Email',
                                hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: 'inter200'),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              textAlign:
                                  isArabic ? TextAlign.end : TextAlign.start,
                              onSaved: (value) {
                                password = value!;
                              },
                              decoration: InputDecoration(
                                hintText: languageCode == 'ar'
                                    ? 'كلمه المرور'
                                    : 'Password',
                                hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: 'inter200'),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              textAlign:
                                  isArabic ? TextAlign.end : TextAlign.start,
                              onSaved: (value) {
                                confirmPassword = value!;
                              },
                              decoration: InputDecoration(
                                hintText: languageCode == 'ar'
                                    ? 'تاكيد كلمه المرور'
                                    : 'Confirm Password',
                                hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: 'inter200'),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            MaleOrFemaleDropDown(
                              arabic: languageCode == 'ar',
                              onGenderSelected: (value) {
                                setState(() {
                                  gender = value;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 70,
                            ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Container(
                            //         height: 1,
                            //         color: Colors.grey[400],
                            //       ),
                            //     ),
                            //     const SizedBox(
                            //       width: 10,
                            //     ),
                            //      Text(
                            //       languageCode == 'ar' ? 'او' :'Or',
                            //       style: TextStyle(
                            //           fontFamily: 'inter200', fontSize: 20),
                            //     ),
                            //     const SizedBox(
                            //       width: 10,
                            //     ),
                            //     Expanded(
                            //       child: Container(
                            //         height: 1,
                            //         color: Colors.grey[400],
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // const SizedBox(
                            //   height: 40,
                            // ),
                            // GestureDetector(
                            //   onTap: () async {
                            //     try {
                            //       // Sign in with Google
                            //       UserCredential userCredential = await FirebaseAuthService().signInWithGoogle();
                            //
                            //       // You can use the returned userCredential for further processing, like storing user data, navigating, etc.
                            //       print("Signed in with Google: ${userCredential.user?.displayName}");
                            //
                            //       // Navigate to another screen or handle the signed-in user
                            //     } catch (e) {
                            //       // Handle errors here
                            //       print("Error signing in with Google: $e");
                            //     }
                            //   },
                            //
                            //   child: Row(
                            //     children: [
                            //       Expanded(
                            //         child: Container(
                            //           height: 60,
                            //           decoration: BoxDecoration(
                            //               borderRadius:
                            //                   BorderRadius.circular(35),
                            //               color: backGroundColor,
                            //               border: Border.all(
                            //                   color: primaryColor, width: 1)),
                            //           child: Padding(
                            //             padding: const EdgeInsets.only(
                            //                 left: 20.0, right: 20),
                            //             child: Row(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.spaceBetween,
                            //               children: [
                            //                  Text(languageCode == 'ar' ? 'سجل بجوجل' :'Login with'),
                            //                 Image.asset(
                            //                     'assets/images/icon1.png')
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       const SizedBox(
                            //         width: 20,
                            //       ),
                            //       Expanded(
                            //         child: GestureDetector(
                            //           onTap: () {},
                            //           child: Container(
                            //             height: 60,
                            //             decoration: BoxDecoration(
                            //                 borderRadius:
                            //                     BorderRadius.circular(35),
                            //                 color: backGroundColor,
                            //                 border: Border.all(
                            //                     color: primaryColor, width: 1)),
                            //             child: Padding(
                            //               padding: const EdgeInsets.only(
                            //                   left: 20.0, right: 20),
                            //               child: Row(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.spaceBetween,
                            //                 children: [
                            //                    Text(languageCode == 'ar' ? 'سجل بفيسبوك' :'Login with',style: TextStyle(fontSize: 12),),
                            //                   Image.asset(
                            //                       'assets/images/icon2.png')
                            //                 ],
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            const SizedBox(
                              height: 100,
                            ),
                            ConditionalBuilder(
                              condition: state is! PassengerAuthLoading,
                              builder: (context) => customButton(
                                  title: languageCode == 'ar'
                                      ? 'تسجيل'
                                      : 'Sign Up',
                                  function: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             YourLocationScreen()));
                                    _formKey.currentState!.save();
                                    // PassengerAuthCubit.(context)
                                    //     .userRegister(
                                    //         context: context,
                                    //         name: name!,
                                    //         email: email!,
                                    //         phone: phone!,
                                    //         password: password!,
                                    //         password_confirmation:
                                    //             confirmPassword!,
                                    //         gender: gender!);
                                  }),
                              fallback: (context) => const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            isArabic
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginPassengerScreen()));
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
                                                : 'Sign Up',
                                            style: const TextStyle(
                                              color: AppColor.primaryColor,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(languageCode == 'ar'
                                          ? 'هل لديك ايميل؟'
                                          : 'Already Have Account ?'),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(languageCode == 'ar'
                                          ? 'هل لديك ايميل؟'
                                          : 'Already Have Account ?'),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginPassengerScreen()));
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
                                                : 'Sign Up',
                                            style: const TextStyle(
                                              color: AppColor.primaryColor,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
