import 'dart:async'; // For using Timer
import 'package:captain_drive/screens/passenger/map/tracking_map.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../network/end_points.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'package:url_launcher/url_launcher.dart'; // For handling phone calls and chats

class ActiveRideScreen extends StatefulWidget {
  const ActiveRideScreen({super.key});

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startOfferCheck();
    PassengerCubit.get(context).getActiveRide();
  }

  void _startOfferCheck() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      // Fetch latest offers and request model
      PassengerCubit.get(context).getActiveRide();
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch phone')),
      );
    }
  }

  Future<void> _launchChat(String chatUrl) async {
    final Uri chatUri = Uri.parse(chatUrl);
    if (await canLaunchUrl(chatUri)) {
      await launchUrl(chatUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open chat')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PassengerCubit, PassengerStates>(
      listener: (context, state) {
        if (state is PassengerGetActiveRideError) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Error fetching ride details')),
          // );
        }
      },
      builder: (context, state) {
        var cubit = PassengerCubit.get(context).getActiveRideModel?.data;

        // if (state is PassengerGetActiveRideLoading) {
        //   return Scaffold(
        //     body: Center(child: CircularProgressIndicator()),
        //   );
        // }

        if (cubit == null) {
          return const Scaffold(
            body: Center(child: Text('No active ride found')),
          );
        }

        String statusText;
        Color statusColor;

        switch (cubit.ride?.status) {
          case 'waiting':
            statusText = 'في انتظار السائق';
            statusColor = Colors.orange;
            break;
          case 'arriving':
            statusText = 'السائق في طريقه اليك';
            statusColor = Colors.blue;
            break;
          case 'arrived':
            statusText = 'لقد وصل السائق';
            statusColor = Colors.green;
            break;
          default:
            statusText = 'الحالة غير معروفة';
            statusColor = Colors.grey;
        }

        String imageUrl =
            '$imageDomain${cubit.ride!.offer!.driver!.picture ?? ''}';

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      '! لقد تم قبول طلب رحلتك',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/Asset 11.png',
                            image: imageUrl,
                            fit: BoxFit.cover,
                          ).image,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cubit.ride!.offer!.driver!.name ??
                                  'Unknown Driver',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              cubit.ride!.offer!.driver!.rate != null
                                  ? 'Rating: ${cubit.ride!.offer!.driver!.rate}'
                                  : 'Rating: Not available',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      statusText,
                      style: TextStyle(fontSize: 18, color: statusColor),
                    ),
                    const SizedBox(height: 20),
                    statusText == 'لقد وصل السائق'
                        ? BlocConsumer<PassengerCubit, PassengerStates>(
                            listener: (context, state) {
                              if (state is PassengerSetToDestinationSuccess) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TrackingMapScreen(
                                              rideData:
                                                  state.setToDestinationModel,
                                            )));
                              }
                            },
                            builder: (context, state) => ConditionalBuilder(
                                  condition: state
                                      is! PassengerSetToDestinationLoading,
                                  builder: (context) => ElevatedButton(
                                    onPressed: () {
                                      PassengerCubit.get(context)
                                          .setToDestination();
                                    }, // Add chat functionality
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('ابدا الرحله'),
                                      ],
                                    ),
                                  ),
                                  fallback: (context) => const Center(
                                      child: CircularProgressIndicator()),
                                ))
                        : Container(),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {}, // Add chat functionality
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat),
                          SizedBox(width: 10),
                          Text('الدردشة مع السائق'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {}, // Add call functionality
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.call),
                          SizedBox(width: 10),
                          Text('اتصل بالسائق'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
