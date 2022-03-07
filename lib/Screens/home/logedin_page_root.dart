import 'package:baata/Screens/home/contact_screen.dart';
import 'package:baata/Screens/home/user_home.dart';
import 'package:baata/Screens/profile/newuserprofiledetails.dart';
import 'package:baata/Settings/manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class loggedinPage extends StatefulWidget {
  final User profile;
  final uManager Settings;
  final Function ThemeSetter;
  final ThemeMode ct;
  final Function updatehome;
  const loggedinPage(
      {Key? key,
      required this.profile,
      required this.Settings,
      required this.ThemeSetter,
      required this.ct,
      required this.updatehome})
      : super(key: key);
  @override
  State<loggedinPage> createState() => _loggedinPageState();
}

class _loggedinPageState extends State<loggedinPage> {
  UserStates? data;

  void updateState() {
    setState(() {});
    Navigator.of(context).push(MaterialPageRoute(builder: (c) {
      return ContactSelector(
        updatehome: widget.updatehome,
      );
    })).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    widget.Settings.userDetails().listen((event) {
      if (event != data) {
        setState(() {
          data = event;
        });
      }
    });
    if (data == UserStates.existing) {
      return UserHome(
        user: widget.profile,
        ThemeSetter: widget.ThemeSetter,
        ct: widget.ct,
      );
    } else if (data == UserStates.newUser) {
      return Center(
        child:
            newUserDataCollector(profile: widget.profile, updater: updateState),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
