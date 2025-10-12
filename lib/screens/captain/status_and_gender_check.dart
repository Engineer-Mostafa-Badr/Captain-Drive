import 'package:flutter/material.dart';
import 'custom_check_box.dart';

class StatusAndGenderCheck extends StatefulWidget {
  final ValueChanged<String> onSelected;
  final String selectedValue;
  final String option;

  const StatusAndGenderCheck({
    super.key,
    required this.onSelected,
    required this.selectedValue,
    required this.option,
  });

  @override
  State<StatusAndGenderCheck> createState() => _StatusAndGenderCheckState();
}

class _StatusAndGenderCheckState extends State<StatusAndGenderCheck> {
  @override
  Widget build(BuildContext context) {
    bool isChecked = widget.selectedValue == widget.option;

    return CustomCheckBox(
      isChecked: isChecked,
      onChecked: (value) {
        widget.onSelected(widget.option);
      },
    );
  }
}
