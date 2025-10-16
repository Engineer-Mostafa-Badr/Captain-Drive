import 'package:captain_drive/screens/passenger/authintaction/Login_passenger_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../localization/localization_cubit.dart';
import '../../shared/local/cach_helper.dart';
import '../captain/Login_captain_screen.dart';

class SelectedScreen extends StatefulWidget {
  const SelectedScreen({super.key});

  @override
  _SelectedScreenState createState() => _SelectedScreenState();
}

class _SelectedScreenState extends State<SelectedScreen> {
  // // Add the isArabic method here
  // bool isArabic(BuildContext context) {
  //   return Localizations.localeOf(context).languageCode == 'ar';
  // }

  @override
  Widget build(BuildContext context) {
    bool isArabic = LocalizationCubit.get(context).isArabic();

    return BlocBuilder<LocalizationCubit, Map<String, String>>(
        builder: (context, localizedStrings) {
      Locale currentLocale = Localizations.localeOf(context);
      bool isArabic = currentLocale.languageCode ==
          'ar'; // Check if the current locale is Arabic

      // Get localized text based on the current language
      final cubit = context.read<LocalizationCubit>();
      final localizedStrings = cubit.state;

      return Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                'assets/images/b3.png',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: isArabic
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      const LanguageSwitcherContainer(), // Add the language switcher here

                      const SizedBox(
                        height: 100,
                      ),

                      // Using Directionality for text alignment and direction handling
                      Directionality(
                        textDirection:
                            isArabic ? TextDirection.rtl : TextDirection.ltr,
                        child: Text(
                          context
                                  .read<LocalizationCubit>()
                                  .translate('please_select') ??
                              'Please Select:',
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Directionality(
                        textDirection:
                            isArabic ? TextDirection.rtl : TextDirection.ltr,
                        child: Text(
                          context
                                  .read<LocalizationCubit>()
                                  .translate('select_choice') ??
                              'Select one of the choices to transfer you to the next page.',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        height: 200,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginCaptainScreen()));
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Directionality(
                              textDirection: isArabic
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              child: Text(
                                context
                                        .read<LocalizationCubit>()
                                        .translate('captain') ??
                                    'Captain',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginPassengerScreen()));
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Directionality(
                              textDirection: isArabic
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              child: Text(
                                context
                                        .read<LocalizationCubit>()
                                        .translate('passenger') ??
                                    'Passenger',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class LanguageSwitcherContainer extends StatelessWidget {
  const LanguageSwitcherContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationCubit, Map<String, String>>(
      builder: (context, localizedStrings) {
        bool isArabic = context.read<LocalizationCubit>().isArabic();
        String currentLanguage = isArabic ? 'AR' : 'EN';

        return GestureDetector(
          onTap: () async {
            // Toggle language between Arabic and English
            String newLanguage =
                context.read<LocalizationCubit>().currentLanguage == 'en'
                    ? 'ar'
                    : 'en';
            // Load new language in the LocalizationCubit
            context.read<LocalizationCubit>().loadLanguage(newLanguage);

            // Save the new language preference using CacheHelper
            await CacheHelper.saveData(key: 'languageCode', value: newLanguage);
          },
          child: Row(
            children: [
              const Icon(
                Icons.language,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                currentLanguage,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
