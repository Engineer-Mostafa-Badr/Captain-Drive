import 'package:captain_drive/core/components/constant.dart';
import 'package:captain_drive/main.dart';
import 'package:captain_drive/screens/passenger/notification_screen.dart';
import 'package:flutter/material.dart';

class SnackBarManager {
  static bool _isSnackBarVisible = false;

  static void showSnackBarNotification(String? message) {
    if (_isSnackBarVisible) {
      return;
    }

    _isSnackBarVisible = true;

    SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.up,
      margin: EdgeInsets.only(
        bottom:
            MediaQuery.of(navigatorKey.currentState!.context).size.height - 245,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: GestureDetector(
        onTap: () {
          Navigator.push(
            navigatorKey.currentState!.context,
            MaterialPageRoute(
              builder: (context) => const NotificationScreen(),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          child: Container(
            color: AppColor.primaryColor,
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "$message",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              maxLines: 2,
            ),
          ),
        ),
      ),
      duration: const Duration(seconds: 3),
    );

    snackbarKey.currentState?.showSnackBar(snackBar).closed.then((_) {
      _isSnackBarVisible = false;
    });
  }
}
