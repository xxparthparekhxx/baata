import 'dart:async';

import 'package:baata/Screens/home/contact_screen.dart';
import 'package:baata/Screens/home/update_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  User user;
  final ThemeMode ct;
  final Function updatehome;
  final Function ThemeSetter;

  CustomDrawer({
    Key? key,
    required this.user,
    required this.ThemeSetter,
    required this.ct,
    required this.updatehome,
  }) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Brightness? userBrightness;

  String JWTToken = '';

  void getToken() async {
    JWTToken = await widget.user.getIdToken();
    setState(() {});
    Timer.periodic(Duration(hours: 1), (timer) async {
      JWTToken = await widget.user.getIdToken();
      setState(() {});
    });
  }

  @override
  void initState() {
    getToken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.ct);
    return Column(
      mainAxisAlignment: MainAxisAlignment.values[2],
      children: [
        ConstrainedBox(
            constraints: BoxConstraints(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        foregroundImage: JWTToken != ''
                            ? NetworkImage(
                                "http://192.168.1.69:80/contact/get/jwt=$JWTToken&pno=${widget.user.phoneNumber}")
                            : null,
                      ),
                      InkWell(
                          onTap: () {
                            if (widget.ct == ThemeMode.light) {
                              widget.ThemeSetter(ThemeMode.dark);
                            } else if (widget.ct == ThemeMode.dark) {
                              widget.ThemeSetter(ThemeMode.light);
                            } else if (widget.ct == ThemeMode.system) {
                              print("editing System");
                              var brightness =
                                  MediaQuery.of(context).platformBrightness;
                              print(brightness);
                              if (brightness == Brightness.light) {
                                widget.ThemeSetter(ThemeMode.dark);
                              } else if (brightness == Brightness.dark) {
                                widget.ThemeSetter(ThemeMode.light);
                              }
                            }
                          },
                          radius: 20,
                          child: widget.ct == ThemeMode.system
                              ? MediaQuery.of(context).platformBrightness ==
                                      Brightness.light
                                  ? Icon(Icons.wb_sunny)
                                  : Icon(Icons.nightlight_round)
                              : widget.ct == ThemeMode.light
                                  ? Icon(Icons.wb_sunny)
                                  : Icon(Icons.nightlight)),
                    ],
                  ),
                ),
                Row()
              ],
            )),
        ListTile(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) {
            return ContactSelector(
              updatehome: widget.updatehome,
            );
          })).then((value) => widget.updatehome()),
          leading: Icon(Icons.contacts_rounded),
          title: Text("Contacts"),
        ),
        ListTile(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) {
            return updateName(
              Token: JWTToken,
              uid: widget.user.uid,
            );
          })),
          leading: Icon(Icons.person),
          title: Text("Profile"),
        ),
        ElevatedButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            child: const Text("Logout"))
      ],
    );
  }
}
