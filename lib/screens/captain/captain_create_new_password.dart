import 'package:captain_drive/business_logic/captain_auth/captain_create_new_password_cubit/captain_create_new_password_cubit.dart';
import 'package:captain_drive/components/constant.dart';
import 'package:captain_drive/components/widget.dart';
import 'package:captain_drive/screens/captain/captain_password_changed_successfully_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../localization/localization_cubit.dart';
import '../../shared/local/cach_helper.dart';

class CaptainCreateNewPasswordScreen extends StatefulWidget {
  final String email;
  const CaptainCreateNewPasswordScreen({super.key, required this.email});

  @override
  State<CaptainCreateNewPasswordScreen> createState() =>
      _CaptainCreateNewPasswordScreenState();
}

class _CaptainCreateNewPasswordScreenState
    extends State<CaptainCreateNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  late String password, confirmPassword;

  bool obscureText = true;

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
      create: (context) => CaptainCreateNewPasswordCubit(),
      child: Scaffold(
        backgroundColor: backGroundColor,
        body: BlocConsumer<CaptainCreateNewPasswordCubit,
            CaptainCreateNewPasswordState>(
          listener: (context, state) {
            if (state is CaptainCreateNewPasswordSuccess) {
              if (state.captainCreateNewPasswordModel.status) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const CaptainPasswordChangedSuccessfullyScreen(),
                  ),
                );
              } else {
                print(state.captainCreateNewPasswordModel.message);
                print('تاكد من البيانات المدخله');
                showToast(
                  message: state.captainCreateNewPasswordModel.message,
                  color: Colors.red,
                );
              }
              if (state is CaptainCreateNewPasswordFailure) {
                showToast(
                  message: state.captainCreateNewPasswordModel.message,
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
                                    ? 'إنشاء كلمة مرور جديدة'
                                    : 'Create New \nPassword',
                                style: const TextStyle(
                                    fontSize: 30, fontFamily: 'inter200'),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                isArabic
                                    ? 'يجب أن تكون هذه كلمة المرور مختلفة عن كلمة المرور الأخيرة الخاصة بك.'
                                    : 'this password should be different from \nyour last password.',
                                style: const TextStyle(
                                  color: Color(0xFF919191),
                                  fontFamily: 'inter600',
                                ),
                                textAlign: TextAlign.center,
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
                                  password = value!;
                                },
                                obscureText: obscureText,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
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
                                  ),
                                  hintText: isArabic
                                      ? 'كلمه مرور جديده'
                                      : 'New Password',
                                  hintStyle: TextStyle(
                                      color: Colors.grey[600],
                                      fontFamily: 'inter200'),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This field is required';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  confirmPassword = value!;
                                },
                                obscureText: obscureText,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
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
                                  ),
                                  hintText: isArabic
                                      ? 'تأكيد كلمه المرور'
                                      : 'Confirm password',
                                  hintStyle: TextStyle(
                                      color: Colors.grey[600],
                                      fontFamily: 'inter200'),
                                ),
                              ),
                              const SizedBox(
                                height: 192,
                              ),
                              customButton(
                                  title: isArabic ? 'حفظ' : 'Save',
                                  function: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             const CaptainPasswordChangedSuccessfullyScreen()));

                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      CaptainCreateNewPasswordCubit.get(context)
                                          .createNewPassword(
                                        context: context,
                                        email: widget.email,
                                        password: password,
                                        confirmPassword: confirmPassword,
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
