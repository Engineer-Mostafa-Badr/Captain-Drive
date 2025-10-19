import 'package:captain_drive/business_logic/captain_auth/captain_check_mail_cubit/captain_check_mail_cubit.dart';
import 'package:captain_drive/core/components/constant.dart';
import 'package:captain_drive/core/components/widget.dart';
import 'package:captain_drive/screens/captain/captain_create_new_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../core/localization/localization_cubit.dart';
import '../../core/storage/cache_helper.dart';

class CaptainCheckMail extends StatefulWidget {
  final String email;
  const CaptainCheckMail({super.key, required this.email});

  @override
  State<CaptainCheckMail> createState() => _CaptainCheckMailState();
}

class _CaptainCheckMailState extends State<CaptainCheckMail> {
  final _formKey = GlobalKey<FormState>();

  late String otp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Load saved language code from SharedPreferences
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

    return BlocProvider(
      create: (context) => CaptainCheckMailCubit(),
      child: Scaffold(
        backgroundColor: AppColor.backGroundColor,
        body: BlocConsumer<CaptainCheckMailCubit, CaptainCheckMailState>(
          listener: (context, state) {
            if (state is CaptainCheckMailSuccess) {
              if (state.captainCheckMailModel.status) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CaptainCreateNewPasswordScreen(
                      email: widget.email,
                    ),
                  ),
                );
              } else {
                print(state.captainCheckMailModel.message);
                print('تاكد من البيانات المدخله');
                showToast(
                  message: state.captainCheckMailModel.message,
                  color: Colors.red,
                );
              }
              if (state is CaptainCheckMailFailure) {
                showToast(
                  message: state.captainCheckMailModel.message,
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
                                    ? 'تحقق من بريدك الإلكتروني'
                                    : 'Check Your \nMail',
                                style: const TextStyle(
                                    fontSize: 25, fontFamily: 'inter200'),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                isArabic
                                    ? 'لقد أرسلنا الكود إلى'
                                    : 'we have sent code to',
                                style: const TextStyle(
                                  color: Color(0xFF919191),
                                  fontFamily: 'inter600',
                                ),
                              ),
                              Text(
                                widget.email,
                                style: const TextStyle(
                                  color: AppColor.primaryColor,
                                  fontFamily: 'inter600',
                                ),
                              ),
                              const SizedBox(
                                height: 64,
                              ),
                              OtpTextField(
                                numberOfFields: 4,
                                fieldWidth: 75,
                                enabledBorderColor: const Color(0xFF919191),
                                focusedBorderColor: AppColor.primaryColor,
                                cursorColor: AppColor.primaryColor,
                                showFieldAsBox: false,
                                onSubmit: (String code) {
                                  setState(() {
                                    otp = code;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 192,
                              ),
                              customButton(
                                  title: isArabic ? 'تاكيد' : 'Confirm',
                                  function: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             const CaptainCreateNewPasswordScreen()));
                                    CaptainCheckMailCubit.get(context)
                                        .checkMail(
                                      email: widget.email,
                                      otp: otp,
                                      context: context,
                                    );
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
