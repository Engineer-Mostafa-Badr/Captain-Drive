import 'package:captain_drive/business_logic/captain_auth/captain_change_password_cubit/captain_change_password_cubit.dart';
import 'package:captain_drive/business_logic/captain_auth/captain_get_profile_data_cubit/captain_get_profile_data_cubit.dart';
import 'package:captain_drive/core/components/constant.dart';
import 'package:captain_drive/core/components/widget.dart';
import 'package:captain_drive/data/models/captain_get_data_model/captain_get_data_model.dart';
import 'package:captain_drive/screens/captain/captain_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/localization/localization_cubit.dart';
import '../../core/storage/cache_helper.dart';

class CaptainChangePasswordScreen extends StatefulWidget {
  const CaptainChangePasswordScreen({super.key});

  @override
  State<CaptainChangePasswordScreen> createState() =>
      _CaptainChangePasswordScreenState();
}

class _CaptainChangePasswordScreenState
    extends State<CaptainChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  late String oldPassword, newPassword, confirmNewPassword;

  bool obscureText = true;
  CaptainGetDataModel? captainGetDataModel;

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
          create: (context) => CaptainChangePasswordCubit(),
        ),
        BlocProvider(
          create: (context) => CaptainGetProfileDataCubit()..getCaptainData(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColor.backGroundColor,
        body: SafeArea(
          child: BlocConsumer<CaptainChangePasswordCubit,
              CaptainChangePasswordState>(
            listener: (context, state) {
              if (state is CaptainChangePasswordSuccess) {
                if (state.captainChangePasswordModel.status) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CaptainProfileScreen(),
                    ),
                  );
                } else {
                  print(state.captainChangePasswordModel.message);
                  print('تاكد من البيانات المدخله');
                  showToast(
                    message: state.captainChangePasswordModel.message,
                    color: Colors.red,
                  );
                }
                if (state is CaptainChangePasswordFailure) {
                  showToast(
                    message: state.captainChangePasswordModel.message,
                    color: Colors.red,
                  );
                }
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: autovalidateMode,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              'assets/images/left_arrow.png',
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: isArabic
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 55),
                            Text(
                              isArabic
                                  ? 'تغيير كلمة المرور'
                                  : 'Change Password',
                              style: const TextStyle(fontSize: 28),
                            ),
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
                                  BlocConsumer<CaptainGetProfileDataCubit,
                                      CaptainGetProfileDataState>(
                                    listener: (context, state) {
                                      if (state
                                          is CaptainGetProfileDataSuccess) {
                                        if (state.captainGetDataModel.status!) {
                                          setState(() {
                                            captainGetDataModel =
                                                state.captainGetDataModel;
                                          });
                                        } else {
                                          print(state
                                              .captainGetDataModel.message);
                                          showToast(
                                            message: state
                                                .captainGetDataModel.message!,
                                            color: Colors.red,
                                          );
                                        }
                                        if (state
                                            is CaptainGetProfileDataFailure) {
                                          showToast(
                                            message: state
                                                .captainGetDataModel.message!,
                                            color: Colors.red,
                                          );
                                        }
                                      }
                                    },
                                    builder: (context, state) {
                                      return Row(
                                        children: [
                                          SizedBox(
                                            height: 70,
                                            width: 70,
                                            child: ClipOval(
                                              child: captainGetDataModel?.data
                                                          ?.user?.picture !=
                                                      null
                                                  ? Image.network(
                                                      "https://captain-drive.webbing-agency.com/storage/app/public/${captainGetDataModel?.data?.user?.picture}",
                                                      fit: BoxFit.fill,
                                                    )
                                                  : const Icon(Icons.error),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${captainGetDataModel?.data?.user?.name}",
                                                style: const TextStyle(
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(
                                    color: Colors.black26,
                                    thickness: 1,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    isArabic
                                        ? 'كلمة المرور القديمة'
                                        : 'Old Password',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field is required';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        oldPassword = value!;
                                      },
                                      obscureText: obscureText,
                                      keyboardType:
                                          TextInputType.visiblePassword,
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
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    isArabic
                                        ? 'كلمة المرور الجديدة'
                                        : 'New Password',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field is required';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        newPassword = value!;
                                      },
                                      obscureText: obscureText,
                                      keyboardType:
                                          TextInputType.visiblePassword,
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
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    isArabic
                                        ? 'تأكيد كلمة المرور'
                                        : 'Confirm Password',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field is required';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        confirmNewPassword = value!;
                                      },
                                      obscureText: obscureText,
                                      keyboardType:
                                          TextInputType.visiblePassword,
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
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  customButton(
                                    title: isArabic ? 'تغيير' : 'Edit',
                                    function: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        CaptainChangePasswordCubit.get(context)
                                            .changePassword(
                                          context: context,
                                          oldPassword: oldPassword,
                                          newPassword: newPassword,
                                          confirmPassword: confirmNewPassword,
                                        );
                                      } else {
                                        setState(() {
                                          autovalidateMode =
                                              AutovalidateMode.always;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
