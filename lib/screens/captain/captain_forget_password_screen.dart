// ignore_for_file: avoid_print

import '../../business_logic/captain_auth/captain_forget_password_cubit/captain_forget_password_cubit.dart';
import 'package:captain_drive/screens/captain/captain_check_mail.dart';
import 'package:captain_drive/components/constant.dart';
import 'package:captain_drive/components/widget.dart';
import '../../localization/localization_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/local/cach_helper.dart';
import 'package:flutter/material.dart';

class CaptainForgetPasswordScreen extends StatefulWidget {
  const CaptainForgetPasswordScreen({super.key});

  @override
  State<CaptainForgetPasswordScreen> createState() =>
      _CaptainForgetPasswordScreenState();
}

class _CaptainForgetPasswordScreenState
    extends State<CaptainForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  late String email;

  @override
  void initState() {
    super.initState();
    loadLanguage();
  }

  String? languageCode; // Variable to hold the language code

  Future<void> loadLanguage() async {
    languageCode = await CacheHelper.getData(key: 'languageCode') ?? 'en';
    // ignore: use_build_context_synchronously
    context.read<LocalizationCubit>().loadLanguage(languageCode!);
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = LocalizationCubit.get(context).isArabic();
    return BlocProvider(
      create: (context) => CaptainForgetPasswordCubit(),
      child: Scaffold(
        backgroundColor: backGroundColor,
        body: BlocConsumer<CaptainForgetPasswordCubit,
            CaptainForgetPasswordState>(
          listener: (context, state) {
            if (state is CaptainForgetPasswordSuccess) {
              if (state.captainForgetPasswordModel.status) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CaptainCheckMail(
                            email: email,
                          )),
                );
              } else {
                print(state.captainForgetPasswordModel.message);
                print('تاكد من البيانات المدخله');
                showToast(
                  message: state.captainForgetPasswordModel.message,
                  color: Colors.red,
                );
              }
              if (state is CaptainForgetPasswordFailure) {
                showToast(
                  message: state.captainForgetPasswordModel.message,
                  color: Colors.red,
                );
              }
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
                        'assets/images/b4.png',
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
                              TextFormField(
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
                                  hintText:
                                      isArabic ? 'البريد الالكتروني' : 'Email',
                                  hintStyle: TextStyle(
                                      color: Colors.grey[600],
                                      fontFamily: 'inter200'),
                                ),
                              ),
                              const SizedBox(
                                height: 150,
                              ),
                              customButton(
                                  title: isArabic ? 'ارسال الكود' : 'Send code',
                                  function: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             const CaptainCheckMail()));
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      CaptainForgetPasswordCubit.get(context)
                                          .userForgetPassword(
                                        context: context,
                                        email: email,
                                      );
                                    } else {
                                      setState(() {
                                        autovalidateMode =
                                            AutovalidateMode.always;
                                      });
                                    }
                                  }),
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
