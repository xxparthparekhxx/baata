import 'package:baata/Screens/profile/contactCollector.dart';
import 'package:baata/Screens/profile/entername.dart';
import 'package:baata/Screens/profile/pfpselect.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class newUserDataCollector extends StatefulWidget {
  User profile;
  final Function updater;
  newUserDataCollector({Key? key, required this.profile, required this.updater})
      : super(key: key);

  @override
  newUserDataCollectorState createState() => newUserDataCollectorState();
}

class newUserDataCollectorState extends State<newUserDataCollector> {
  String? Name;

  nameSetter(name) {
    setState(() {
      Name = name;
    });
  }

  PageController Contractor = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    if (Name != null) {
      Contractor.animateToPage(1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.decelerate);
    }
    return PageView(
      controller: Contractor,
      children: [
        NameCollector(NameSetter: nameSetter),
        Pfp(
            userName: Name ?? '',
            profile: widget.profile,
            controller: Contractor),
        ContactCollector(
          Updater: widget.updater,
        )
      ],
    );
  }
}
