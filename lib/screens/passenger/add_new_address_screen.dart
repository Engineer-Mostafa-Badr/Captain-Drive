import 'package:captain_drive/components/constant.dart';
import 'package:captain_drive/components/widget.dart';
import 'package:flutter/material.dart';
import 'layout_screen.dart';

class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LayoutScreen()));
                        },
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.black,
                          size: 30,
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Adding new Address',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'inter700',
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Country',
                        hintStyle: TextStyle(
                            color: Colors.grey[600], fontFamily: 'inter200'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'City',
                        hintStyle: TextStyle(
                            color: Colors.grey[600], fontFamily: 'inter200'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'New Address',
                        hintStyle: TextStyle(
                            color: Colors.grey[600], fontFamily: 'inter200'),
                      ),
                    ),
                    const Spacer(),
                    customButton(
                      title: 'Save',
                      function: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LayoutScreen()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Future<Position> _determinePosition() async {
//   bool serviceEnabled;
//   LocationPermission permission;
//
//   // Check if location services are enabled
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     // Location services are not enabled, don't continue
//     return Future.error('Location services are disabled.');
//   }
//
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       // Permissions are denied, don't continue
//       return Future.error('Location permissions are denied');
//     }
//   }
//
//   if (permission == LocationPermission.deniedForever) {
//     // Permissions are denied forever, handle appropriately
//     return Future.error(
//         'Location permissions are permanently denied, we cannot request permissions.');
//   }
//
//   // When permissions are granted, get the current position
//   return await Geolocator.getCurrentPosition();
// }
}
