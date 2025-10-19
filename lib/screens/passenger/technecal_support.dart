import 'package:captain_drive/screens/passenger/cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/components/constant.dart';
import '../../core/storage/cache_helper.dart';
import '../../core/localization/localization_cubit.dart';

import 'cubit/cubit.dart';

class TechenecalSupportScreen extends StatefulWidget {
  const TechenecalSupportScreen({super.key});

  @override
  State<TechenecalSupportScreen> createState() =>
      _TechenecalSupportScreenState();
}

class _TechenecalSupportScreenState extends State<TechenecalSupportScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch numbers admin when the screen initializes
    PassengerCubit.get(context).getNumbersAdmin();
    loadLanguage();
  }

  String? languageCode;

  Future<void> loadLanguage() async {
    languageCode = await CacheHelper.getData(key: 'languageCode') ??
        'en'; // Default to 'en' if not set
    context.read<LocalizationCubit>().loadLanguage(languageCode!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PassengerCubit, PassengerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = PassengerCubit.get(context);
        var numbersList = cubit.getNumbersAdminModel?.data.numbers ?? [];
        bool isArabic = LocalizationCubit.get(context).isArabic();

        return Scaffold(
          backgroundColor: AppColor.backGroundColor,
          body: ConditionalBuilder(
            condition: state is! PassengerGetNumbersAdminLoading,
            builder: (context) => SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          isArabic ? 'الدعم الفني' : 'Technical Support',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),

                    // Display the list of references
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: numbersList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        var number = numbersList[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                _launchURL(number.reference);
                              },
                              child: Text(
                                number.reference,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
