import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'constant.dart';

Widget customButton({required String title, required var function}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: function,
        child: Container(
          width: 220,
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), color: primaryColor),
          child: Center(
              child: Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          )),
        ),
      ),
    ],
  );
}

Widget customMapButton({
  required String title,
  required var function,
  required Color color,
  required double width,
  required double height,
  bool enabled = true,
}) {
  return GestureDetector(
    onTap: enabled ? function : null,
    child: Container(
      width: width,
      height: height,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(30), color: color),
      child: Center(
          child: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      )),
    ),
  );
}

Widget customCaptainHomeButton({required String title, required var function}) {
  return GestureDetector(
    onTap: function,
    child: Container(
      width: 293,
      height: 43,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: primaryColor),
      child: Center(
          child: Text(
        title,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      )),
    ),
  );
}

Widget customBoardingButton({
  required String title,
  required var function,
}) {
  return GestureDetector(
    onTap: function,
    child: Container(
      width: 92,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: onBoardingColor,
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            color: Color.fromRGBO(209, 209, 209, 1),
          ),
        ),
      ),
    ),
  );
}

Widget customBoldText({required String title}) {
  return Text(
    title,
    style: const TextStyle(fontSize: 23, fontFamily: 'NotoBold'),
  );
}

Widget phoneFormField({required TextEditingController phone}) {
  return Column(
    children: [
      const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'رقم الهاتف',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 45,
        child: Row(
          children: [
            Container(
              width: 80,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: borderFieldColor),
                  left: BorderSide(color: borderFieldColor),
                  bottom: BorderSide(color: borderFieldColor),
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(
                        10)), // Optional: Adjust border radius as needed
              ),
              child: Center(
                child: DropdownButton<String>(
                  value: "+20", // Default country code
                  onChanged: (String? newValue) {
                    // Implement logic to change the country code
                  },
                  items: <String>["+20", "+1", "+44"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
                  }).toList(),
                  style: const TextStyle(
                      color: Colors.black), // Set text color to black
                  underline: Container(), // Hide underline
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderFieldColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderFieldColor),
                  ),
                ),
                cursorColor: primaryColor,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "ادخل رقم الهاتف";
                  }
                  return null;
                },
                onChanged: (value) {
                  value = phone.text;
                },
                controller: phone,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget nameFormField(
    {required String title, required TextEditingController name}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 45,
        child: TextFormField(
          textAlignVertical: TextAlignVertical.top,
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderFieldColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderFieldColor)),
            // border: OutlineInputBorder(),
          ),
          cursorColor: primaryColor,
          controller: name,
          validator: (value) {
            if (value!.isEmpty) {
              return "ادخل كلمه المرور";
            }
            return null;
          },
          onChanged: (value) {
            value = name.text;
          },
        ),
      ),
    ],
  );
}

Widget customFormField(
    {required String title,
    required TextEditingController name,
    required String error}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 45,
        child: TextFormField(
          textAlignVertical: TextAlignVertical.top,
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderFieldColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderFieldColor)),
            // border: OutlineInputBorder(),
          ),
          cursorColor: primaryColor,
          controller: name,
          validator: (value) {
            if (value!.isEmpty) {
              return error;
            }
            return null;
          },
          onChanged: (value) {
            value = name.text;
          },
        ),
      ),
      const SizedBox(
        height: 10,
      ),
    ],
  );
}

Widget customNoValidateFormField({
  required String title,
  required TextEditingController name,
}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 45,
        child: TextFormField(
          textAlignVertical: TextAlignVertical.top,
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderFieldColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderFieldColor)),
            // border: OutlineInputBorder(),
          ),
          cursorColor: primaryColor,
          controller: name,
          onChanged: (value) {
            value = name.text;
          },
        ),
      ),
      const SizedBox(
        height: 10,
      ),
    ],
  );
}

Widget emailFormField(
    {required String title, required TextEditingController email}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 45,
        child: TextFormField(
          textAlignVertical: TextAlignVertical.top,
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderFieldColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderFieldColor)),
            // border: OutlineInputBorder(),
          ),
          cursorColor: primaryColor,
          controller: email,
          validator: (value) {
            if (value!.isEmpty) {
              return "ادخل الايميل الخاص بك";
            }
            final bool isValid = EmailValidator.validate(value);
            if (!isValid) {
              return "ادخلت ايميل خطا";
            }
            return null;
          },
          onChanged: (value) {
            value = email.text;
          },
        ),
      ),
    ],
  );
}

Widget passwordFormField({
  required String title,
  required TextEditingController password,
  bool isPassword = true,
  var suffixPressed,
  IconData icon = Icons.visibility_outlined,
}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 45,
        child: TextFormField(
          textAlignVertical: TextAlignVertical.top,
          obscureText: isPassword,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: borderFieldColor)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: borderFieldColor)),
            // border: OutlineInputBorder(),
            prefixIcon: GestureDetector(
                onTap: suffixPressed,
                child: Icon(
                  icon,
                  color: Colors.black,
                )),
          ),
          cursorColor: primaryColor,
          controller: password,
          validator: (value) {
            if (value!.isEmpty) {
              return "ادخل الباسورد الخاص بك ";
            }
            return null;
          },
          onChanged: (value) {
            value = password.text;
          },
        ),
      ),
    ],
  );
}

Widget customTextButton({
  required String title,
  required var function,
}) {
  return TextButton(
      onPressed: function,
      child: Text(
        title,
        style: const TextStyle(
          color: textButtonColor,
        ),
      ));
}

void showToast({
  required String message,
  required Color color,
  // required String text,
  // required state
}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 20);

class MaleOrFemaleDropDown extends StatefulWidget {
  final Function(String) onGenderSelected;
  final bool arabic;
  const MaleOrFemaleDropDown(
      {super.key, required this.onGenderSelected, required this.arabic});

  @override
  State<MaleOrFemaleDropDown> createState() => _CustomReportLostDropDownState();
}

class _CustomReportLostDropDownState extends State<MaleOrFemaleDropDown> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xFFEAEAEA),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFB6B4B9),
            width: 2.0,
          ),
          right: BorderSide(
            color: Color(0xFFB6B4B9),
            width: 2.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton<String>(
              hint: Text(widget.arabic ? 'النوع' : 'Gender'),
              borderRadius: BorderRadius.circular(16),
              dropdownColor: Colors.white,
              value: selectedOption,
              icon: const Icon(
                Icons.arrow_drop_down,
                size: 40,
              ),
              onChanged: (data) {
                setState(() {
                  selectedOption = data;
                  widget.onGenderSelected(selectedOption!);
                });
              },
              items: <String>[
                widget.arabic ? 'ذكر' : 'Male',
                widget.arabic ? 'انثي' : 'Female'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Text(value),
                      const SizedBox(
                        width: 10,
                      ),
                      value == 'Male'
                          ? const Icon(Icons.male)
                          : const Icon(Icons.female),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDropDown extends StatefulWidget {
  final Function(String) onTypeSelected;

  const ProfileDropDown({super.key, required this.onTypeSelected});

  @override
  State<ProfileDropDown> createState() => _ProfileDropDownState();
}

class _ProfileDropDownState extends State<ProfileDropDown> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xFFDFDFDF),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFB6B4B9),
            width: 2.0,
          ),
          right: BorderSide(
            color: Color(0xFFB6B4B9),
            width: 2.0,
          ),
          left: BorderSide(
            color: Color(0xFFB6B4B9),
            width: 2.0,
          ),
          top: BorderSide(
            color: Color(0xFFB6B4B9),
            width: 2.0,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButton<String>(
            hint: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text('Options'),
            ),
            borderRadius: BorderRadius.circular(16),
            dropdownColor: Colors.white,
            value: selectedOption,
            icon: const Icon(
              Icons.arrow_drop_down,
              size: 40,
            ),
            onChanged: (data) {
              setState(() {
                selectedOption = data;
                widget.onTypeSelected(selectedOption!);
              });
            },
            items: <String>[
              'Profile Information',
              'Change Password',
              'Report Captain'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    Text(value),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
