// import 'package:captain_drive/screens/passenger/map/map_screen.dart';
// import 'package:flutter/material.dart';
//
// import 'chat_screen.dart';
//
// class DriverListScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text("Best Drivers for This Ride"),
//         backgroundColor: Colors.blue,
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(16),
//         children: [
//           buildDriverCard(
//               'Tarek Amir', 30, '4.8', '2.3 km away', '12 min', context),
//           buildDriverCard(
//               'Tarek Amir', 23, '4.6', '2.1 km away', '10 min', context),
//           buildDriverCard(
//               'Tarek Amir', 20, '4.4', '2.4 km away', '13 min', context),
//         ],
//       ),
//     );
//   }
//
//   Widget buildDriverCard(String name, int fare, String rating, String distance,
//       String time, BuildContext context) {
//     return Column(
//       children: [
//         Card(
//           margin: EdgeInsets.only(bottom: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Column(
//             children: [
//               ListTile(
//                 contentPadding: EdgeInsets.all(16),
//                 leading: CircleAvatar(
//                     radius: 30,
//                     backgroundImage: NetworkImage(
//                         'https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg?w=996&t=st=1720603095~exp=1720603695~hmac=f670936f21936d0f0ebebab4cfcfc8459e87ee04c2750e08879f806ef2b41c87')),
//                 title: Text(name),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('$rating ⭐ | $distance | $time'),
//                     Text('Fare: $fare.00 EGP'),
//                   ],
//                 ),
//                 trailing: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=>MapScreen()));
//                     // Handle the request button action
//                   },
//                   child: Text('accept'),
//                 ),
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => ChatUserDetailsScreen()));
//                       },
//                       icon: Icon(Icons.chat)),
//                   IconButton(onPressed: () {}, icon: Icon(Icons.call)),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
