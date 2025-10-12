import 'dart:io';

import 'package:captain_drive/components/constant.dart';
import 'package:captain_drive/components/widget.dart';
import 'package:captain_drive/network/end_points.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../localization/localization_cubit.dart';
import '../../shared/local/cach_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final TextEditingController recipientNameTextController =
      TextEditingController();
  final TextEditingController recipientPhoneController =
      TextEditingController();
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController codeTextController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final TextEditingController numberOfAccountController =
      TextEditingController();
  final TextEditingController numberOfOrderController = TextEditingController();

  List<String> listOfAccount = [
    'المعلومات الشخصيه',
    'تغيير كلمه المرور',
    'الحسابات المشار اليها',
    'حذف الحساب',
  ];

  late String selectedList;

  final ImagePicker _picker = ImagePicker();
  File? image;

  @override
  void initState() {
    super.initState();
    passengerCubit.get(context).getUserData();
    loadLanguage();
  }

  String? languageCode; // Variable to hold the language code

  Future<void> loadLanguage() async {
    languageCode = await CacheHelper.getData(key: 'languageCode') ??
        'en'; // Default to 'en' if not set
    context.read<LocalizationCubit>().loadLanguage(languageCode!);
  }

  final _formKey = GlobalKey<FormState>();

  Dio dio = Dio(BaseOptions(
    baseUrl: 'https://captain-drive.webbing-agency.com/api/',
    receiveDataWhenStatusError: true,
  ));
  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  // Function to upload the picked image along with additional data
  Future<void> updateUserData(
    File image, {
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      String filename = image.path.split('/').last;
      FormData formData = FormData.fromMap({
        "name": name,
        "email": email,
        'phone': phone,
        "picture": await MultipartFile.fromFile(
          image.path,
          filename: filename,
          contentType: MediaType('image', 'png'),
        ),
      });

      Response response = await dio.post(
        "user/update",
        data: formData,
        options: Options(
          headers: {
            "accept": "*/*",
            'Authorization': 'Bearer $userToken',
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Handle success
        showToast(
          message: "Image uploaded successfully",
          color: Colors.green,
        );
      } else {
        // Handle failure
        showToast(
          message: "Failed to upload image: ${response.statusCode}",
          color: Colors.red,
        );
      }
    } catch (e) {
      // Handle errors
      print("Image uploading error: $e");
      showToast(
        message: "Failed to upload image: $e",
        color: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = LocalizationCubit.get(context).isArabic();

    return BlocProvider(
      create: (context) => passengerCubit()..getUserData(),
      child: BlocConsumer<passengerCubit, PassengerStates>(
        listener: (context, state) {
          if (state is SuccessUpdateState) {
            if (state.updateModel.status) {
              print('update success');
              showToast(
                  message: state.updateModel.message, color: Colors.green);
              //Navigator.push(context, MaterialPageRoute(builder: (context)=>LayoutScreen()));
            } else {
              showToast(message: state.updateModel.message, color: Colors.red);
            }
          }
        },
        builder: (context, state) {
          var cubit = passengerCubit.get(context);
          var userModel = cubit.userModel;

          return Form(
            key: _formKey,
            child: Scaffold(
              backgroundColor: backGroundColor,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //personalInformation(state,context),
                        const SizedBox(height: 55),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back_ios)),
                            Text(
                              isArabic ? 'المعلومات الشخصيه' : 'Profile',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  image != null
                                      ? CircleAvatar(
                                          radius: 35,
                                          backgroundImage: FileImage(image!),
                                        )
                                      : CircleAvatar(
                                          backgroundImage: userModel
                                                      ?.data.picture !=
                                                  null
                                              ? NetworkImage(imageDomain +
                                                      userModel!.data.picture!)
                                                  as ImageProvider<Object>?
                                              : const AssetImage(
                                                      'assets/images/photo.png')
                                                  as ImageProvider<Object>?,
                                          radius: 35,
                                        ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        passengerCubit
                                                .get(context)
                                                .userModel
                                                ?.data
                                                .name
                                                .toString() ??
                                            'loading..',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap:
                                            _pickImage, // Call _pickImage when tapping to change the image
                                        child: Container(
                                          width: 150,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF488AD7),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Center(
                                            child: Text(
                                              isArabic
                                                  ? 'تغير الصوره'
                                                  : 'Change The Picture',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),
                              const Divider(
                                color: Colors.black26,
                                thickness: 1,
                              ),

                              Column(
                                crossAxisAlignment: isArabic
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(isArabic ? 'الايميل' : 'Email'),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    alignment: isArabic
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    width: double.infinity,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: Colors.black54,
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        userModel?.data.email ?? 'loading...',
                                        style: const TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              Column(
                                crossAxisAlignment: isArabic
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(isArabic ? 'رقم التليفون' : 'phone'),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    alignment: isArabic
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    width: double.infinity,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: Colors.black54,
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        userModel?.data.phone ?? 'loading...',
                                        style: const TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Edit First Name and Last Name Fields

                              Container(
                                width: double.infinity,
                                height: 1,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: isArabic
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Text(
                                    isArabic
                                        ? 'تعديل المعلومات الشخصيه'
                                        : 'Edit personal information',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 20,
                              ),
                              customFormField(
                                title: isArabic ? 'الاسم المستخدم' : 'Name',
                                name: nameTextController,
                                error: isArabic
                                    ? 'ادخل الاسم المستخدم'
                                    : 'Enter your name',
                              ),
                              customNoValidateFormField(
                                  title: isArabic ? 'رقم التليفون' : 'phone',
                                  name: phoneController),
                              emailFormField(
                                title: isArabic ? 'البريد الالكتروني' : 'Email',
                                email: emailController,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ConditionalBuilder(
                                    condition: state is! LoadingUpdateState,
                                    builder: (context) => customButton(
                                        title: isArabic ? 'تعديل' : 'Edit',
                                        function: () {
                                          // Call updateUserData to update user information
                                          passengerCubit
                                              .get(context)
                                              .updateProfile(
                                                image,
                                                name: nameTextController.text,
                                                email: emailController.text,
                                                phone: phoneController.text,
                                              );
                                        }),
                                    fallback: (context) => const Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                ],
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

  Widget personalInformation(state, context) {
    var cubit = passengerCubit.get(context);
    var userModel = cubit.userModel;

    if (userModel == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'المعلومات الشخصيه',
              style: TextStyle(fontSize: 16, fontFamily: 'NotoBold'),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                image != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(image!),
                      )
                    : CircleAvatar(
                        backgroundImage: userModel.data.picture != null
                            ? NetworkImage(domain + userModel.data.picture!)
                                as ImageProvider<Object>?
                            : const AssetImage('assets/images/man.png')
                                as ImageProvider<Object>?,
                        radius: 50,
                      ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      passengerCubit
                          .get(context)
                          .userModel!
                          .data
                          .name
                          .toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap:
                          _pickImage, // Call _pickImage when tapping to change the image
                      child: Container(
                        width: 120,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ButtonfColor,
                        ),
                        child: const Center(
                          child: Text(
                            'تغيير الصوره',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('الايميل'),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.black54,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      userModel.data.email,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('رقم التليفون'),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.black54,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      userModel.data.phone,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(
                              text:
                                  'https://play.google.com/store/apps/details?id=com.suquha.app&pcampaignid=web_share'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم نسخ اللينك')),
                          );
                        },
                        icon: const Icon(Icons.copy, color: primaryColor)),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('لينك الابليكيشن'),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.black54,
                      )),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Expanded(
                        child: Text(
                      'https://play.google.com/store/apps/details?id=com.suquha.app&pcampaignid=web_share',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black54),
                    )),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[400],
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'تعديل المعلومات الشخصيه',
              style: TextStyle(fontSize: 16, fontFamily: 'NotoBold'),
            ),
            const SizedBox(
              height: 20,
            ),
            customFormField(
              title: 'الاسم المستخدم',
              name: nameTextController,
              error: 'ادخل الاسم المستخدم',
            ),
            customNoValidateFormField(
                title: 'رقم التليفون', name: phoneController),
            emailFormField(
              title: 'البريد الالكتروني',
              email: emailController,
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConditionalBuilder(
                  condition: state is! LoadingUpdateState,
                  builder: (context) => GestureDetector(
                    onTap: () {
                      // Call updateUserData to update user information
                      if (_formKey.currentState!.validate()) {
                        passengerCubit.get(context).updateProfile(
                              image,
                              name: nameTextController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                            );
                      }
                    },
                    child: Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: ButtonfColor,
                      ),
                      child: const Center(
                        child: Text(
                          'تعديل المعلومات',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  fallback: (context) =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
