import 'package:captain_drive/components/constant.dart';
import 'package:captain_drive/components/widget.dart';
import 'package:captain_drive/screens/passenger/password_changed_successfully_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../localization/localization_cubit.dart';
import '../../shared/local/cach_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final String email;
  const CreateNewPasswordScreen({super.key, required this.email});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? password, confirmPassword;
  bool obscureText1 = true;
  bool obscureText2 = true;

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
        if (state is SuccessForgetPasswordState) {
          if (state.forgetPassword.status) {
            print('forget password success');
            showToast(
                message: state.forgetPassword.message, color: Colors.green);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const PasswordChangedSuccessfullyScreen()));
          } else {
            showToast(message: state.forgetPassword.message, color: Colors.red);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: backGroundColor,
          body: SizedBox(
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
                      child: SingleChildScrollView(
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
                            Column(
                              crossAxisAlignment: isArabic
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                customBoldText(
                                    title: isArabic
                                        ? 'انشئ كلمه مرور جديده'
                                        : 'Create a new password'),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: isArabic
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      isArabic
                                          ? 'كلمه المرور الجديده'
                                          : 'New Password',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
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
                                  controller: newPasswordController,
                                  obscureText: obscureText1,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                    // Conditionally display prefixIcon or suffixIcon based on isArabic
                                    prefixIcon: isArabic
                                        ? GestureDetector(
                                            onTap: () {
                                              obscureText1 = !obscureText1;
                                              setState(() {});
                                            },
                                            child: obscureText1
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
                                              obscureText1 = !obscureText1;
                                              setState(() {});
                                            },
                                            child: obscureText1
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
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: isArabic
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      isArabic
                                          ? 'تأكيد كلمه المرور'
                                          : 'Confirm password',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
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
                                  controller: confirmPasswordController,
                                  obscureText: obscureText2,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                    // Conditionally display prefixIcon or suffixIcon based on isArabic
                                    prefixIcon: isArabic
                                        ? GestureDetector(
                                            onTap: () {
                                              obscureText2 = !obscureText2;
                                              setState(() {});
                                            },
                                            child: obscureText2
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
                                              obscureText2 = !obscureText2;
                                              setState(() {});
                                            },
                                            child: obscureText2
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
                                  height: 20,
                                ),
                                const SizedBox(
                                  height: 150,
                                ),
                                ConditionalBuilder(
                                  condition:
                                      state is! LoadingForgetPasswordState,
                                  builder: (context) => customButton(
                                      title: isArabic ? 'حفظ' : 'Save',
                                      function: () {
                                        if (_formKey.currentState!.validate()) {
                                          print(newPasswordController.text);
                                          print(confirmPasswordController.text);
                                          PassengerCubit.get(context)
                                              .newPassword(
                                                  email: widget.email,
                                                  password:
                                                      newPasswordController
                                                          .text,
                                                  password_confirmation:
                                                      confirmPasswordController
                                                          .text);
                                        }
                                      }),
                                  fallback: (context) => const Center(
                                      child: CircularProgressIndicator()),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
