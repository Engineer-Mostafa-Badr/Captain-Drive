import 'package:captain_drive/components/constant.dart';
import 'package:captain_drive/components/widget.dart';
import 'package:captain_drive/screens/passenger/authintaction/Login_passenger_screen.dart';
import 'package:captain_drive/screens/passenger/check_mail_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../localization/localization_cubit.dart';
import '../../shared/local/cach_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

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

    return BlocConsumer<passengerCubit, PassengerStates>(
      listener: (context, state) {
        if (state is SuccessForgetPasswordState) {
          if (state.forgetPassword.status) {
            print('forget password success');
            showToast(
                message: state.forgetPassword.message, color: Colors.green);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CheckMailScreen(
                          email: emailController.text,
                        )));
          } else {
            showToast(message: state.forgetPassword.message, color: Colors.red);
          }
        }
      },
      builder: (context, state) {
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPassengerScreen()));
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
                              isArabic
                                  ? 'هل نسيت كلمة السر'
                                  : 'Forget \nPassword',
                              style: const TextStyle(
                                  fontSize: 35, fontFamily: 'inter200'),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              isArabic
                                  ? 'اكتب عنوان بريدك الإلكتروني الذي قمت بتسجيل الدخول إليه في المرة الأولى التي تستخدم فيها التطبيق'
                                  : 'Type your email address that you have \nloggied in at your first time using the app',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF919191),
                                fontFamily: 'inter600',
                              ),
                            ),
                            const SizedBox(
                              height: 64,
                            ),
                            emailFormField(
                                email: emailController,
                                title:
                                    isArabic ? 'البريد الالكتروني' : "Email"),

                            const SizedBox(
                              height: 192,
                            ),
                            ConditionalBuilder(
                              condition: state is! LoadingForgetPasswordState,
                              builder: (context) => customButton(
                                  title: isArabic ? 'ارسال الكود' : 'Send code',
                                  function: () {
                                    if (_formKey.currentState!.validate()) {
                                      passengerCubit
                                          .get(context)
                                          .askForgetPassword(
                                              email: emailController.text);
                                    }
                                  }),
                              fallback: (context) =>
                                  const Center(child: CircularProgressIndicator()),
                            ),
                            // TextFormField(
                            //   onSaved: (value) {
                            //     email = value!;
                            //   },
                            //   decoration: InputDecoration(
                            //     hintText: isArabic?'الايميل':'Email',
                            //     hintStyle: TextStyle(
                            //         color: Colors.grey[600],
                            //         fontFamily: 'inter200'),
                            //   ),
                            // ),

                            const SizedBox(
                              height: 20,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     GestureDetector(
                            //       onTap: () {
                            //         // Navigator.push(
                            //         //     context,
                            //         //     MaterialPageRoute(
                            //         //         builder: (context) =>
                            //         //             SignUpPassengerScreen()));
                            //       },
                            //       child: DecoratedBox(
                            //         decoration: BoxDecoration(
                            //           border: Border(
                            //             bottom: BorderSide(
                            //               color: primaryColor,
                            //               width:
                            //                   1.0, // Adjust the width of the line as needed
                            //             ),
                            //           ),
                            //         ),
                            //         child: GestureDetector(
                            //           onTap: () {
                            //             Navigator.pushReplacement(
                            //                 context,
                            //                 MaterialPageRoute(
                            //                     builder: (context) =>
                            //                         const LoginPassengerScreen()));
                            //           },
                            //           child: Text(
                            //             'Go Back',
                            //             style: TextStyle(
                            //               color: primaryColor,
                            //               fontSize: 18,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
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
    );
  }
}
