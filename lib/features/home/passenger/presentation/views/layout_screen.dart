import 'package:captain_drive/screens/passenger/activities_screen.dart';
import 'package:captain_drive/features/home/passenger/presentation/views/homeScreen.dart';
import 'package:captain_drive/screens/passenger/reservation/reservation_start.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/components/constant.dart';
import '../../../../../core/storage/cache_helper.dart';
import '../../../../../core/localization/localization_cubit.dart';

import '../../../../../screens/passenger/profile_screen.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadLanguage();
  }

  String? languageCode; // Variable to hold the language code

  Future<void> loadLanguage() async {
    languageCode = await CacheHelper.getData(key: 'languageCode') ??
        'en'; // Default to 'en' if not set
    // ignore: use_build_context_synchronously
    context.read<LocalizationCubit>().loadLanguage(languageCode!);
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    // Add other screens here for chat, search, activities
    const ActivitiesScreen(),
    const ReservationStart(),
    const ProfileScreen() // Add ProfileScreen
  ];

  @override
  Widget build(BuildContext context) {
    bool isArabic = LocalizationCubit.get(context).isArabic();
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: AppColor.primaryColor,
        elevation: 100,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: isArabic ? 'الرئيسيه' : 'Home'),
          BottomNavigationBarItem(
              icon: const Icon(Icons.access_time),
              label: isArabic ? 'النشاط' : 'Activities'),
          BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_month_outlined),
              label: isArabic ? 'الحجز' : 'Booking'),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: isArabic ? 'الحساب' : 'Profile'),
        ],
      ),
    );
  }
}
