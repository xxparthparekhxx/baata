import 'package:baata/Screens/AuthScreens/AuthWidgets/connect_with_animation.dart';
import 'package:baata/Screens/AuthScreens/AuthWidgets/messageflowanimation.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  PageController ScreenMaster;
  WelcomeScreen({Key? key, required this.ScreenMaster}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "Welcome to",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Baate",
                          style: TextStyle(
                              fontSize: 32,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: const [
                    Text(
                      "Connect with",
                      style: TextStyle(fontSize: 24),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.0),
                      child: ConnectWithAmination(),
                    )
                  ],
                ),
              )
            ],
          ),
          const MessageBubbleAnimaton(),
          Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    ScreenMaster.animateToPage(1,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeIn);
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.navigate_next),
                            Text("Get Started Now"),
                            Icon(Icons.navigate_next),
                          ],
                        ),
                      ))),
              const SizedBox(
                height: 20,
              )
            ],
          )
        ],
      ),
    );
  }
}
