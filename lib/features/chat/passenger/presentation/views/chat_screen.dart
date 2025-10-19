import 'package:flutter/material.dart';

import '../../../../../core/components/constant.dart';

class ChatUserDetailsScreen extends StatefulWidget {
  const ChatUserDetailsScreen({super.key});

  @override
  State<ChatUserDetailsScreen> createState() => _ChatUserDetailsScreenState();
}

class _ChatUserDetailsScreenState extends State<ChatUserDetailsScreen> {
  final messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColor.backGroundColor,
        elevation: 0,
        titleSpacing: 0,
        title: const Row(
          children: [
            CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                    'https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg?w=996&t=st=1720603095~exp=1720603695~hmac=f670936f21936d0f0ebebab4cfcfc8459e87ee04c2750e08879f806ef2b41c87')),
            SizedBox(
              width: 20,
            ),
            Text(
              'Tarek Amir',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.call,
                color: Colors.blue,
              ))
        ],
      ),
      body: Container(
        color: AppColor.backGroundColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Text('${model.userId}'), //user
              //  Text('$uid'), //doctor

              Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return null;
                    },
                    separatorBuilder: (context, state) => const SizedBox(
                          height: 15,
                        ),
                    itemCount: 5),
              ),
              //Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.black), // Background color
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                      ),
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          //massageText = value;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          hintText: 'Enter your message here',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                      width: 10), // Spacer between TextField and Button
                  TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          Colors.blue), // Button background color
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30.0), // Rounded corners
                        ),
                      ),
                    ),
                    child: const Text(
                      'Send',
                      style: TextStyle(
                        color: Colors.white, // Button text color
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMessage() => const Align(
        alignment: AlignmentDirectional.centerStart,
        child: Material(
            elevation: 10,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              //bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Colors.teal,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Hello',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            )),
      );

  Widget buildMyMessage() => const Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Material(
            elevation: 10,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              //bottomRight: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: AppColor.primaryColor,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'وصلت؟؟',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            )),
      );
}
