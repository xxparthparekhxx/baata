import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';

class ConnectWithAmination extends StatefulWidget {
  const ConnectWithAmination({Key? key}) : super(key: key);

  @override
  ConnectWithAminationState createState() => ConnectWithAminationState();
}

class ConnectWithAminationState extends State<ConnectWithAmination> {
  List<String> arr = [
    "Family",
    'Friends',
    'New-Opportunities',
    "Businesses",
    "Groups",
    "Society"
  ];
  String currentString = "";

  String get newrandomstring {
    return arr[Random().nextInt(arr.length)];
  }

  late Timer _timer;

  @override
  void initState() {
    String temp = newrandomstring;
    bool assending = true;
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        if (temp.length > currentString.length && assending) {
          currentString += temp[currentString.length];
        } else if (!assending) {
          currentString = currentString.substring(0, currentString.length - 1);
        }
        if (temp.length == currentString.length) {
          assending = false;
        } else if (currentString == '') {
          assending = true;
          temp = newrandomstring;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      currentString + "_",
      style: const TextStyle(
          color: Colors.orange, fontSize: 24, fontWeight: FontWeight.bold),
      overflow: TextOverflow.fade,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
