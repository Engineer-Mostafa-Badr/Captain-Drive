import 'package:captain_drive/core/components/constant.dart';
import 'package:captain_drive/core/components/widget.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/storage/cache_helper.dart';
import '../../core/localization/localization_cubit.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
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

    return BlocProvider(
      create: (context) => PassengerCubit()..getUserData(),
      child: BlocConsumer<PassengerCubit, PassengerStates>(
        listener: (context, state) {
          if (state is SuccessChangePasswordState) {
            if (state.changePasswordModel.status) {
              print('withdraw success');
              showToast(
                  message: state.changePasswordModel.message,
                  color: Colors.green);
            } else {
              showToast(
                  message: state.changePasswordModel.message,
                  color: Colors.red);
            }
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Scaffold(
              backgroundColor: AppColor.backGroundColor,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 55),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back_ios)),
                            Text(
                              isArabic ? 'تغير كلمه السر' : 'Change Password',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 30),
                        Container(
                          width: double
                              .infinity, // Use double.infinity for full width
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                spreadRadius: 0.5,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              nameFormField(
                                title: isArabic
                                    ? 'ادخل كلمه المرور الحاليه'
                                    : 'Enter old password',
                                name: passwordController,
                              ),
                              nameFormField(
                                title: isArabic
                                    ? 'اختيار كلمه مرور جديده'
                                    : 'Enter new password',
                                name: newPasswordController,
                              ),
                              nameFormField(
                                title: isArabic
                                    ? 'تأكيد كلمه المرور'
                                    : 'Enter password Confirmation',
                                name: confirmPasswordController,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              ConditionalBuilder(
                                condition: state is! LoadingChangePasswordState,
                                builder: (context) => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    customButton(
                                        title: isArabic ? 'تعديل' : 'Edit',
                                        function: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            PassengerCubit.get(
                                                    context)
                                                .changePassword(
                                                    old_password:
                                                        passwordController.text,
                                                    password:
                                                        newPasswordController
                                                            .text,
                                                    password_confirmation:
                                                        confirmPasswordController
                                                            .text);
                                          }
                                        }),
                                  ],
                                ),
                                fallback: (context) => const Center(
                                    child: CircularProgressIndicator()),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
