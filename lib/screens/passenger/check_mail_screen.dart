import 'package:captain_drive/core/components/constant.dart';
import 'package:captain_drive/core/components/widget.dart';
import 'package:captain_drive/screens/passenger/create_new_password_screen.dart';
import 'package:captain_drive/screens/passenger/cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../core/storage/cache_helper.dart';
import '../../core/localization/localization_cubit.dart';

import 'cubit/states.dart';

class CheckMailScreen extends StatefulWidget {
  final String email;
  const CheckMailScreen({super.key, required this.email});

  @override
  State<CheckMailScreen> createState() => _CheckMailScreenState();
}

class _CheckMailScreenState extends State<CheckMailScreen> {
  final _formKey = GlobalKey<FormState>();

  String? otp;

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

    return BlocConsumer<PassengerCubit, PassengerStates>(
      listener: (context, state) {
        if (state is SuccessCheckCodeState) {
          if (state.forgetPassword.status) {
            print('forget password success');
            showToast(
                message: state.forgetPassword.message, color: Colors.green);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateNewPasswordScreen(
                          email: widget.email,
                        )));
          } else {
            showToast(message: state.forgetPassword.message, color: Colors.red);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.backGroundColor,
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
                              focusedBorderColor: Colors.black,
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
                            ConditionalBuilder(
                              condition: state is! LoadingCheckCodeState,
                              builder: (context) => customButton(
                                  title: isArabic ? 'تاكيد' : 'Confirm',
                                  function: () {
                                    print(otp);
                                    PassengerCubit.get(context).checkCode(
                                        email: widget.email, code: otp!);
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             const CreateNewPasswordScreen()));
                                  }),
                              fallback: (context) => const Center(
                                  child: CircularProgressIndicator()),
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
    );
  }
}
