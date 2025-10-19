import 'package:captain_drive/core/components/constant.dart';
import 'package:captain_drive/core/localization/localization_cubit.dart';
import '../../../driver/presentation/views/driver_login_view.dart';
import '../../../../../core/storage/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../passenger/presentation/views/Login_passenger_screen.dart';

class SelectedScreen extends StatefulWidget {
  const SelectedScreen({super.key});

  @override
  SelectedScreenState createState() => SelectedScreenState();
}

class SelectedScreenState extends State<SelectedScreen> {
  @override
  Widget build(BuildContext context) {
    LocalizationCubit.get(context).isArabic();

    return BlocBuilder<LocalizationCubit, Map<String, String>>(
        builder: (context, localizedStrings) {
      Locale currentLocale = Localizations.localeOf(context);
      bool isArabic = currentLocale.languageCode == 'ar';

      context.read<LocalizationCubit>();

      return Scaffold(
        backgroundColor: AppColor.primaryColor,
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
                      const LanguageSwitcherContainer(),
                      const SizedBox(
                        height: 100,
                      ),
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
            String newLanguage =
                context.read<LocalizationCubit>().currentLanguage == 'en'
                    ? 'ar'
                    : 'en';
            context.read<LocalizationCubit>().loadLanguage(newLanguage);
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
