import 'dart:io';
import 'package:flutter/material.dart';

class CustomImagePicker extends StatelessWidget {
  const CustomImagePicker({
    super.key,
    required File? image,
  }) : _image = image;

  final File? _image;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            if (_image != null)
              Container(
                height: 100,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[400],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            if (_image == null)
              Container(
                height: 100,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[400],
                ),
                child: Icon(
                  Icons.add_circle,
                  color: Colors.grey[700],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
