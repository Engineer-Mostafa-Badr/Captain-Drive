import 'dart:io';

import 'package:captain_drive/business_logic/captain_auth/sign_up_captain_cubit/sign_up_captain_cubit.dart';
import 'package:captain_drive/screens/captain/captain_layout_screen.dart';
import 'package:captain_drive/screens/captain/chat/domain/repos/auth_repo.dart';
import 'package:captain_drive/screens/captain/chat/manager/firebase_sign_up_cubit/firebase_sign_up_cubit.dart';
import 'package:captain_drive/screens/captain/chat/services/get_it_service.dart';
import 'package:captain_drive/screens/captain/status_and_gender_check.dart';
import 'package:captain_drive/shared/local/cach_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../components/constant.dart';
import '../../../components/widget.dart';
import '../../localization/localization_cubit.dart';
import 'Login_captain_screen.dart';
import 'custom_image_picker_function.dart';

class SignUpCaptainScreen extends StatefulWidget {
  const SignUpCaptainScreen({super.key, required this.vehicleType});
  final String vehicleType;

  @override
  State<SignUpCaptainScreen> createState() => _SignUpCaptainScreenState();
}

class _SignUpCaptainScreenState extends State<SignUpCaptainScreen> {
  // final TextEditingController nameTextController = TextEditingController();

  // final TextEditingController phoneTextController = TextEditingController();

  final TextEditingController emailTextController = TextEditingController();

  // final TextEditingController confirmPasswordTextController =
  //     TextEditingController();

  // final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  late String name,
      email,
      phone,
      addPhone,
      status = '',
      password,
      confirmPassword,
      gender = '',
      nationalId,
      model,
      color,
      platesNumber;

  late File frontNationalId,
      backNationalId,
      driverLicenseFront,
      driverLicenseBack,
      vehicleFront,
      vehicleBack,
      criminalRecord;

  File? picture;

  late bool isChecked = false;
  bool obscureText = true;

  bool isSignUpSuccess = false;
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
          create: (context) => SignUpCaptainCubit(),
        ),
        BlocProvider(
          create: (context) => FirebaseSignUpCubit(
            getIt<AuthRepo>(),
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: backGroundColor,
        body: BlocConsumer<SignUpCaptainCubit, SignUpCaptainState>(
          listener: (context, state) {
            if (state is SignUpCaptainSuccess) {
              if (state.signUpCaptainModel.status) {
                CacheHelper.saveData(
                        key: 'Captientoken',
                        value: state.signUpCaptainModel.data?.token)
                    .then((value) {
                  CaptienToken = state.signUpCaptainModel.data?.token;
                  print(CaptienToken);

                  setState(() {
                    isSignUpSuccess = true;
                  });
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CaptainLayoutScreen()));
                });
              } else {
                print(state.signUpCaptainModel.message);
                print('تاكد من البيانات المدخله');
                showToast(
                  message: state.signUpCaptainModel.message,
                  color: Colors.red,
                );
              }
              if (state is SignUpCaptainFailure) {
                showToast(
                  message: state.signUpCaptainModel.message,
                  color: Colors.red,
                );
              }
            }
          },
          builder: (context, state) {
            return BlocConsumer<FirebaseSignUpCubit, FirebaseSignUpState>(
              listener: (context, state) {
                // if (state is FirebaseSignUpSuccess && isSignUpSuccess) {
                //   CacheHelper.saveData(
                //       key: 'name', value: state.userEntity.name);
                //   CacheHelper.saveData(
                //       key: 'email', value: state.userEntity.email);
                //   CacheHelper.saveData(
                //       key: 'uId', value: state.userEntity.email)
                //       .then((value) {
                //     userEmail = state.userEntity.email;
                //
                //     print(userEmail);
                //     print(state.userEntity.uId);
                //
                //     Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const CaptainLayoutScreen()),
                //     );
                //   });
                // }
                //
                // if (state is FirebaseSignUpFailure) {
                //   showToast(
                //     message: state.message,
                //     color: Colors.red,
                //   );
                // }
              },
              builder: (context, state) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ModalProgressHUD(
                    inAsyncCall: state is SignUpCaptainLoading,
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
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    Text(
                                      isArabic ? 'سجل' : 'Sign up',
                                      style: const TextStyle(
                                          fontSize: 40, fontFamily: 'inter200'),
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
                                        name = value!;
                                      },
                                      decoration: InputDecoration(
                                        hintText: isArabic ? 'الاسم' : 'Name ',
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
                                        phone = value!;
                                      },
                                      decoration: InputDecoration(
                                        hintText: isArabic
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
                                        addPhone = value!;
                                      },
                                      decoration: InputDecoration(
                                        hintText: isArabic
                                            ? 'رقم هاتف آخر'
                                            : 'Another Phone Number',
                                        hintStyle: TextStyle(
                                            color: Colors.grey[600],
                                            fontFamily: 'inter200'),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
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
                                        nationalId = value!;
                                      },
                                      decoration: InputDecoration(
                                        hintText: isArabic
                                            ? 'رقم البطاقه الشخصيه'
                                            : 'National Id',
                                        hintStyle: TextStyle(
                                            color: Colors.grey[600],
                                            fontFamily: 'inter200'),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
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
                                        model = value!;
                                      },
                                      decoration: InputDecoration(
                                        hintText: isArabic
                                            ? 'نوع السيارة'
                                            : 'Vehicle Model',
                                        hintStyle: TextStyle(
                                            color: Colors.grey[600],
                                            fontFamily: 'inter200'),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
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
                                        color = value!;
                                      },
                                      decoration: InputDecoration(
                                        hintText: isArabic
                                            ? 'لون السيارة'
                                            : 'Vehicle Color',
                                        hintStyle: TextStyle(
                                            color: Colors.grey[600],
                                            fontFamily: 'inter200'),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
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
                                        platesNumber = value!;
                                      },
                                      decoration: InputDecoration(
                                        hintText: isArabic
                                            ? 'رقم اللوحات'
                                            : 'Plates Number',
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
                                        email = value!;
                                      },
                                      decoration: InputDecoration(
                                        hintText: isArabic
                                            ? 'البريد الإلكتروني'
                                            : 'Email',
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
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      decoration: InputDecoration(
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
                                        hintText: isArabic
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
                                        confirmPassword = value!;
                                      },
                                      obscureText: obscureText,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      decoration: InputDecoration(
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
                                        hintText: isArabic
                                            ? 'تأكيد كلمة المرور'
                                            : 'Confirm Password',
                                        hintStyle: TextStyle(
                                            color: Colors.grey[600],
                                            fontFamily: 'inter200'),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    isArabic
                                        ? const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '(من الأمام والخلف)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10),
                                              ),
                                              Text(
                                                'البطاقه الشخصيه',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          )
                                        : const Row(
                                            children: [
                                              Text(
                                                'National id card ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                '(from the front and the back)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10),
                                              ),
                                            ],
                                          ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        CustomImagePickerFunction(
                                          onImageSelected: (data) {
                                            setState(() {
                                              frontNationalId = data;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        CustomImagePickerFunction(
                                          onImageSelected: (data) {
                                            setState(() {
                                              backNationalId = data;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    isArabic
                                        ? const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '(من الأمام والخلف)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10),
                                              ),
                                              Text(
                                                'رخصة القيادة',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          )
                                        : const Row(
                                            children: [
                                              Text(
                                                'Driver license ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                '(from the front and the back)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10),
                                              ),
                                            ],
                                          ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        CustomImagePickerFunction(
                                          onImageSelected: (data) {
                                            setState(() {
                                              driverLicenseFront = data;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        CustomImagePickerFunction(
                                          onImageSelected: (data) {
                                            setState(() {
                                              driverLicenseBack = data;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    isArabic
                                        ? const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '(من الأمام والخلف)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10),
                                              ),
                                              Text(
                                                'السياره',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          )
                                        : const Row(
                                            children: [
                                              Text(
                                                'Vehicle ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                '(from the front and the back)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10),
                                              ),
                                            ],
                                          ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        CustomImagePickerFunction(
                                          onImageSelected: (data) {
                                            setState(() {
                                              vehicleFront = data;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        CustomImagePickerFunction(
                                          onImageSelected: (data) {
                                            setState(() {
                                              vehicleBack = data;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    isArabic
                                        ? const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                'السجل الجنائي',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              )
                                            ],
                                          )
                                        : const Row(
                                            children: [
                                              Text(
                                                'Criminal record ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomImagePickerFunction(
                                          onImageSelected: (data) {
                                            setState(() {
                                              criminalRecord = data;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    isArabic
                                        ? const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                'أضف صورة لك',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              )
                                            ],
                                          )
                                        : const Row(
                                            children: [
                                              Text(
                                                'Add a picture of you ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomImagePickerFunction(
                                          onImageSelected: (data) {
                                            setState(() {
                                              picture = data;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    isArabic
                                        ? const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                'الحالة',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              )
                                            ],
                                          )
                                        : const Row(
                                            children: [
                                              Text(
                                                'Status',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey[400],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                StatusAndGenderCheck(
                                                  option: 'Married',
                                                  selectedValue: status,
                                                  onSelected: (value) {
                                                    setState(() {
                                                      status = value;
                                                    });
                                                  },
                                                ),
                                                const SizedBox(width: 10),
                                                Text(isArabic
                                                    ? 'متزوج'
                                                    : 'Married'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey[400],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                StatusAndGenderCheck(
                                                  option: 'Single',
                                                  selectedValue: status,
                                                  onSelected: (value) {
                                                    setState(() {
                                                      status = value;
                                                    });
                                                  },
                                                ),
                                                const SizedBox(width: 10),
                                                Text(isArabic
                                                    ? 'أعزب'
                                                    : 'Single'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                      ],
                                    ),
                                    const SizedBox(height: 20),

                                    // Gender Row
                                    Row(
                                      children: [
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey[400],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                StatusAndGenderCheck(
                                                  option: 'Male',
                                                  selectedValue: gender,
                                                  onSelected: (value) {
                                                    setState(() {
                                                      gender = value;
                                                    });
                                                  },
                                                ),
                                                const SizedBox(width: 10),
                                                Text(isArabic ? 'ذكر' : 'Male'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey[400],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                StatusAndGenderCheck(
                                                  option: 'Female',
                                                  selectedValue: gender,
                                                  onSelected: (value) {
                                                    setState(() {
                                                      gender = value;
                                                    });
                                                  },
                                                ),
                                                const SizedBox(width: 10),
                                                Text(isArabic
                                                    ? 'أنثى'
                                                    : 'Female'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 70,
                                    ),
                                    customButton(
                                      title: isArabic ? 'سجل' : 'Sign Up',
                                      function: () {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();

                                          // Check if the user has selected an image (picture is not null)
                                          if (picture == null) {
                                            // Show an alert to the user or set a validation error
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(isArabic
                                                      ? 'يرجى تحميل الصورة'
                                                      : 'Please upload a picture')),
                                            );
                                            return;
                                          }

                                          // Proceed with sign-up if all fields are valid
                                          SignUpCaptainCubit.get(context)
                                              .driverSignUp(
                                            context: context,
                                            name: name,
                                            email: email,
                                            phone: phone,
                                            addPhone: addPhone,
                                            status: status,
                                            nationalId: nationalId,
                                            gender: gender,
                                            password: password,
                                            confirmPassword: confirmPassword,
                                            picture: picture!,
                                            nationalFront: frontNationalId,
                                            nationalBack: backNationalId,
                                            driverLFront: driverLicenseFront,
                                            driverLBack: driverLicenseBack,
                                            vehicleFront: vehicleFront,
                                            vehicleBack: vehicleBack,
                                            criminalRecord: criminalRecord,
                                            type: widget.vehicleType,
                                            model: model,
                                            color: color,
                                            platesNumber: platesNumber,
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
                                                              const LoginCaptainScreen()));
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
                                              const Text(
                                                  'هل لديك حساب بالفعل؟'),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                  'Already Have Account ?'),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const LoginCaptainScreen()));
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
                                                    'Login',
                                                    style: TextStyle(
                                                      color: primaryColor,
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
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// class CustomPicImageFunction extends StatefulWidget {
//   final Function(File)? onImageSelected;
//   const CustomPicImageFunction({
//     super.key,
//     this.onImageSelected,
//   });
//
//   @override
//   State<CustomPicImageFunction> createState() => _CustomPicImageFunctionState();
// }
//
// class _CustomPicImageFunctionState extends State<CustomPicImageFunction> {
//   File? _image;
//
//   Future<void> _uploadImageToFirebase() async {
//     if (_image == null) return;
//
//     // Create a unique file name
//     final fileName = Uuid().v4() + path.extension(_image!.path);
//
//     // Upload image to Firebase Storage
//     final storageRef = FirebaseStorage.instance
//         .ref()
//         .child('user_profile_pics')
//         .child(fileName);
//
//     try {
//       final uploadTask = storageRef.putFile(_image!);
//       final snapshot = await uploadTask.whenComplete(() {});
//       final downloadUrl = await snapshot.ref.getDownloadURL();
//
//       // Update Firestore with the new image URL
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         final userDocRef =
//         FirebaseFirestore.instance.collection('users').doc(user.uid);
//         final docSnapshot = await userDocRef.get();
//
//         // Check if the document exists, create it if not
//         if (!docSnapshot.exists) {
//           await userDocRef.set({
//             'profileImageUrl': downloadUrl, // Add initial data if needed
//           });
//         } else {
//           // Update the existing document
//           await userDocRef.update({
//             'profileImageUrl': downloadUrl,
//           });
//         }
//
//         // Save the image URL locally if needed
//         CacheHelper.saveData(key: 'profileImageUrl', value: downloadUrl);
//
//         // Optionally, you can pass the downloadUrl to the callback
//         widget.onImageSelected?.call(_image!);
//       }
//     } catch (e) {
//       print('Error uploading image: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         await _pickImageFromGallery();
//         if (_image == null) return;
//         await _uploadImageToFirebase();
//       },
//       child: CustomPicImage(
//         image: _image,
//       ),
//     );
//   }
//
//   Future<void> _pickImageFromGallery() async {
//     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (image == null) return;
//
//     setState(() {
//       _image = File(image.path);
//     });
//   }
// }
//
// class CustomPicImage extends StatelessWidget {
//   const CustomPicImage({
//     super.key,
//     required File? image,
//   }) : _image = image;
//
//   final File? _image;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Stack(
//           children: [
//             if (_image != null)
//               Container(
//                 height: 100,
//                 width: 150,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.grey[400],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Image.file(
//                     _image!,
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//               ),
//             if (_image == null)
//               Container(
//                 height: 100,
//                 width: 150,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.grey[400],
//                 ),
//                 child: Icon(
//                   Icons.add_circle,
//                   color: Colors.grey[700],
//                 ),
//               ),
//           ],
//         ),
//       ],
//     );
//   }
// }
