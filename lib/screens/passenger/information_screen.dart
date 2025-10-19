import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/components/constant.dart';
import '../../core/storage/cache_helper.dart';
import '../../core/localization/localization_cubit.dart';

import '../../features/home/passenger/presentation/views/layout_screen.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  @override
  void initState() {
    super.initState();
    loadLanguage();
  }

  String? languageCode;

  Future<void> loadLanguage() async {
    languageCode = await CacheHelper.getData(key: 'languageCode') ?? 'en';
    context.read<LocalizationCubit>().loadLanguage(languageCode!);
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = LocalizationCubit.get(context).isArabic();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Image.asset(
                        'assets/images/people.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  isArabic ? 'WAY إرشادات مجتمع ' : 'WAY Community Guidelines',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    _buildOptionRow(
                      icon: Icons.emoji_people,
                      text: isArabic
                          ? 'السلامة واحترام الجميع'
                          : 'Safety and Respect for All',
                    ),
                    _buildOptionRow(
                      icon: Icons.thumb_up,
                      text: isArabic
                          ? 'عامل الجميع بلطف واحترام'
                          : 'Treat everyone with kindness and respect',
                    ),
                    _buildOptionRow(
                      icon: Icons.health_and_safety,
                      text: isArabic
                          ? 'ساهم في الحفاظ على سلامة الجميع'
                          : 'Contribute to maintaining everyone’s safety',
                    ),
                    _buildOptionRow(
                      icon: Icons.rule,
                      text: isArabic ? 'اتبع القوانين' : 'Follow the rules',
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LayoutScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                        backgroundColor: AppColor.primaryColor,
                      ),
                      child: Text(
                        isArabic ? 'أفهم ذلك' : 'I Understand',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionRow({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 19),
            ),
          ),
          const SizedBox(width: 10),
          Icon(icon, color: AppColor.primaryColor),
        ],
      ),
    );
  }
}
