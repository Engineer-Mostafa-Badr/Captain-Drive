import 'package:captain_drive/screens/captain/signup_captain_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/constant.dart';
import '../../../components/widget.dart';
import '../../localization/localization_cubit.dart';
import '../../shared/local/cach_helper.dart';

class ChooseYourVehicleScreen extends StatefulWidget {
  const ChooseYourVehicleScreen({super.key});

  @override
  State<ChooseYourVehicleScreen> createState() =>
      _ChooseYourVehicleScreenState();
}

class _ChooseYourVehicleScreenState extends State<ChooseYourVehicleScreen> {
  final TextEditingController nameTextController = TextEditingController();

  final TextEditingController phoneTextController = TextEditingController();

  final TextEditingController emailTextController = TextEditingController();

  final TextEditingController confirmPasswordTextController =
      TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String selectedCarType = 'car';
  String selectedVehicleType = "1";
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
      backgroundColor: backGroundColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.asset(
                'assets/images/b41.png',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: isArabic
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_circle_left_outlined,
                              size: 30,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        isArabic ? 'اختر سيارتك' : 'Choose Your Vehicle',
                        style: const TextStyle(fontSize: 30, fontFamily: 'inter200'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      isArabic
                          ? SelectedArabicVehicle(
                              name: 'car',
                              title:
                                  'سيارة سيدان متوسطة\n الحجم فوق عام 2000 \nيمكنها استيعاب 4 \nركاب بشكل مريح',
                              image: 'assets/images/car1.png',
                              vehicleType: "1",
                            )
                          : SelectedVehicle(
                              name: 'car',
                              title:
                                  'Average Sedan car Above\n2000 that can take 4\npassengers comfortably\n',
                              image: 'assets/images/car1.png',
                              vehicleType: "1",
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      isArabic
                          ? SelectedArabicVehicle(
                              name: 'Air-conditioned car',
                              title:
                                  'سيارة سيدان متوسطة \nالحجم فوق 2006 \nيمكنها استيعاب 4 \nركاب بشكل مريح \nمع مكيف هواء يعمل',
                              image: 'assets/images/car2.png',
                              vehicleType: "2")
                          : SelectedVehicle(
                              name: 'Air-conditioned car',
                              title:
                                  'Average Sedan car Above\n2006 that can take 4\npassengers comfortably\nwith working Air-conditioner\n',
                              image: 'assets/images/car2.png',
                              vehicleType: "2"),
                      const SizedBox(
                        height: 20,
                      ),
                      isArabic
                          ? SelectedArabicVehicle(
                              name: 'Motorcycle',
                              title:
                                  'دراجة نارية مناسبة \nللسائق المنفرد وتوفر \nالنقل السريع والسهل \nخلال حركة المرور',
                              image: 'assets/images/scooter.png',
                              vehicleType: "3")
                          : SelectedVehicle(
                              name: 'Motorcycle',
                              title:
                                  'Motorcycle suitable for solo\nrider providing fast\nand agile transport\n through traffic\n',
                              image: 'assets/images/scooter.png',
                              vehicleType: "3"),
                      const SizedBox(
                        height: 20,
                      ),
                      isArabic
                          ? SelectedArabicVehicle(
                              name: 'Taxi',
                              title:
                                  'سيارة سيدان متوسطة\n الحجم فوق عام 2000 \nيمكنها استيعاب 4 \nركاب بشكل مريح',
                              image: 'assets/images/taxi.png',
                              vehicleType: "4")
                          : SelectedVehicle(
                              name: 'Taxi',
                              title:
                                  'Average Sedan car Above\n2000 that can take 4\npassengers comfortably\n',
                              image: 'assets/images/taxi.png',
                              vehicleType: "4"),
                      const SizedBox(
                        height: 20,
                      ),
                      isArabic
                          ? SelectedArabicVehicle(
                              name: 'Bus',
                              title:
                                  'سيارة سيدان متوسطة\n الحجم فوق عام 2000 \nيمكنها استيعاب 4 \nركاب بشكل مريح',
                              image: 'assets/images/bus.png',
                              vehicleType: "5")
                          : SelectedVehicle(
                              name: 'Bus',
                              title:
                                  'Average Sedan car Above\n2000 that can take 4\npassengers comfortably\n',
                              image: 'assets/images/bus.png',
                              vehicleType: "5"),
                      const SizedBox(
                        height: 70,
                      ),
                      customButton(
                          title: isArabic ? 'اكمل' : 'Continue',
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpCaptainScreen(
                                  vehicleType: selectedVehicleType,
                                ),
                              ),
                            );
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget SelectedVehicle(
      {required String name,
      required String title,
      required String image,
      required String vehicleType}) {
    bool isSelected =
        selectedCarType == name; // Check if this car type is selected

    return GestureDetector(
      onTap: () {
        // Update the selected car type when clicked
        setState(() {
          selectedCarType = name;
          selectedVehicleType = vehicleType;
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(
              color: isSelected ? Colors.black : Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 5, // Softening the shadow
              spreadRadius: 0.5, // Extending the shadow
              offset: Offset(0, 0), // No offset to center the shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Text(
                    'Start from Age : 18',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    title,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Text(
                    'Available Driving License',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Expanded(
                child: SizedBox(child: Image.asset(image)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget SelectedArabicVehicle(
      {required String name,
      required String title,
      required String image,
      required String vehicleType}) {
    bool isSelected =
        selectedCarType == name; // Check if this car type is selected

    return GestureDetector(
      onTap: () {
        // Update the selected car type when clicked
        setState(() {
          selectedCarType = name;
          selectedVehicleType = vehicleType;
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(
              color: isSelected ? Colors.black : Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 5, // Softening the shadow
              spreadRadius: 0.5, // Extending the shadow
              offset: Offset(0, 0), // No offset to center the shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(child: Image.asset(image)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    name == 'car'
                        ? 'سيارة عادية'
                        : name == 'Air-conditioned car'
                            ? 'سيارة مكيفه'
                            : name == 'Motorcycle'
                                ? 'دراجة نارية'
                                : name == 'Taxi'
                                    ? 'تاكسي'
                                    : name == 'Bus'
                                        ? 'باص'
                                        : 'مركبة أخرى',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'ابدأ من عمر : 18',
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.end,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Text(
                    'رخصة قيادة متاحة',
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
