import 'package:captain_drive/core/components/constant.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox(
      {super.key, required this.isChecked, required this.onChecked});
  final bool isChecked;
  final ValueChanged<bool> onChecked;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChecked(!isChecked);
      },
      child: AnimatedContainer(
          width: 20,
          height: 20,
          duration: const Duration(
            milliseconds: 100,
          ),
          decoration: ShapeDecoration(
            color: isChecked ? AppColor.primaryColor : const Color(0xFF48444E),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.5,
                color: isChecked ? Colors.transparent : const Color(0xFFDCDEDE),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Image.asset(
              'assets/images/check.png',
            ),
          )),
    );
  }
}
