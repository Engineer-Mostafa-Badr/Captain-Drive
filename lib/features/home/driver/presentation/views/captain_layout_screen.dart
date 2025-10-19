import 'package:captain_drive/screens/captain/captain_accepted_reservation.dart';
import 'package:captain_drive/screens/captain/captain_activities_screen.dart';
import 'package:captain_drive/screens/captain/captain_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/components/constant.dart';
import '../../../../../core/localization/localization_cubit.dart';
import '../../../../../core/storage/cache_helper.dart';
import 'captain_home_screen.dart';

class CaptainLayoutScreen extends StatefulWidget {
  const CaptainLayoutScreen({super.key});

  @override
  State<CaptainLayoutScreen> createState() => _CaptainLayoutScreenState();
}

class _CaptainLayoutScreenState extends State<CaptainLayoutScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CaptainHomeScreen(),
    // Add other screens here for chat, search, activities
    // const CaptainReservationView(),
    const CaptainAcceptedReservation(),
    const CaptainActivitiesScreen(),
    const CaptainProfileScreen(),
    // const ProfileScreen() // Add ProfileScreen
  ];

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
              icon: const Icon(Icons.calendar_month_outlined),
              label: isArabic ? 'الحجز' : 'Booking'),
          // BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: const Icon(Icons.access_time),
              label: isArabic ? 'النشاط' : 'Activities'),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: isArabic ? 'الحساب' : 'Profile'),
        ],
      ),
    );
  }
}
