import '../../../auth/auth_selector/presentation/views/select_auth_type_view.dart';
import '../../../../core/localization/localization_cubit.dart';
import 'package:captain_drive/core/components/constant.dart';
import '../../../../core/storage/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

final PageController _pageController = PageController();

class OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationCubit, Map<String, String>>(
      builder: (context, localizedStrings) {
        Localizations.localeOf(context);

        final cubit = context.read<LocalizationCubit>();
        final localizedStrings = cubit.state;
        final List<String> titles = [
          localizedStrings['onboarding_title_1'] ?? '',
          localizedStrings['onboarding_title_2'] ?? '',
          localizedStrings['onboarding_title_3'] ?? '',
          localizedStrings['onboarding_title_4'] ?? '',
        ];

        final List<String> descriptions = [
          localizedStrings['onboarding_description_1'] ?? '',
          localizedStrings['onboarding_description_2'] ?? '',
          localizedStrings['onboarding_description_3'] ?? '',
          localizedStrings['onboarding_description_4'] ?? '',
        ];

        final List<String> images = [
          'assets/images/onb1.png',
          'assets/images/onb2.png',
          'assets/images/onb3.png',
          'assets/images/people.png',
        ];

        return Scaffold(
          backgroundColor: AppColor.primaryColor,
          body: PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            itemCount: titles.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPage(
                title: titles[index],
                description: descriptions[index],
                image: images[index],
                pageNumber: _currentPage,
              );
            },
          ),
        );
      },
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final int pageNumber;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.pageNumber,
  });
  @override
  Widget build(BuildContext context) {
    final localizedStrings = context.watch<LocalizationCubit>().state;
    bool isArabic = LocalizationCubit.get(context).isArabic();
    return Stack(
      children: [
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment:
                isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const LanguageSwitcherContainer(), // Add the language switcher here
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        submit(context);
                      },
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Text(
                          localizedStrings['skip'] ?? 'Skip',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          textAlign:
                              isArabic ? TextAlign.right : TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 350,
                    height: 300,
                    child: Image.asset(
                      image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  description,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIndicator(pageNumber == 0),
                    const SizedBox(width: 10),
                    _buildIndicator(pageNumber == 1),
                    const SizedBox(width: 10),
                    _buildIndicator(pageNumber == 2),
                    const SizedBox(width: 10),
                    _buildIndicator(pageNumber == 3),
                  ],
                ),
              ),
              const Spacer(),
              pageNumber == 3
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: GestureDetector(
                        onTap: () {
                          if (pageNumber == 3) {
                            submit(context);
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white),
                          child: Center(
                            child: Text(
                              localizedStrings['start'] ?? 'Start',
                              style: const TextStyle(fontSize: 20),
                              textAlign:
                                  isArabic ? TextAlign.right : TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: GestureDetector(
                        onTap: () {
                          // ignore: avoid_print
                          print(isArabic);
                          if (pageNumber == 3) {
                            submit(context);
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white),
                          child: Center(
                            child: Text(
                              localizedStrings['next'] ?? 'Next',
                              style: const TextStyle(fontSize: 20),
                              textAlign:
                                  isArabic ? TextAlign.right : TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Container _buildIndicator(bool isSelected) {
    return Container(
      width: isSelected ? 20 : 18, // Adjust width based on selection
      height: isSelected ? 20 : 18, // Height of inner circle
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        color:
            isSelected ? Colors.white : const Color.fromRGBO(164, 164, 164, 1),
      ),
    );
  }
}

void submit(context) {
  CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
    if (value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SelectedScreen()),
      );
    }
  });
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
