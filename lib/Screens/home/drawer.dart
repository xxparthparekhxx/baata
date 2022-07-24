import 'dart:async';
import 'package:baata/Screens/home/contact_screen.dart';
import 'package:baata/Screens/profile/update_profile.dart';
import 'package:baata/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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
  String? Name;
  String? JWTToken;

  void getToken() async {
    JWTToken = await widget.user.getIdToken();

    GetName();
    if (mounted) setState(() {});
    Timer.periodic(const Duration(hours: 1), (timer) async {
      JWTToken = await widget.user.getIdToken();
      setState(() {});
    });
  }

  void GetName() async {
    Response res = await post(Uri.parse("${URL}profile/Getname"),
        headers: {"jwt": JWTToken!});
    Name = res.body;
    setState(() {});
  }

  NetworkImage? image;
  @override
  void initState() {
    getToken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ConstrainedBox(
              constraints: const BoxConstraints(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          foregroundImage: JWTToken != null
                              ? NetworkImage(
                                  "${URL}contact/get/jwt=${JWTToken!}&pno=${widget.user.phoneNumber}")
                              : null,
                        ),
                        InkWell(
                            onTap: () {
                              if (widget.ct == ThemeMode.light) {
                                widget.ThemeSetter(ThemeMode.dark);
                              } else if (widget.ct == ThemeMode.dark) {
                                widget.ThemeSetter(ThemeMode.light);
                              } else if (widget.ct == ThemeMode.system) {
                                var brightness =
                                    MediaQuery.of(context).platformBrightness;

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
                                    ? const Icon(Icons.wb_sunny)
                                    : const Icon(Icons.nightlight_round)
                                : widget.ct == ThemeMode.light
                                    ? const Icon(Icons.wb_sunny)
                                    : const Icon(Icons.nightlight)),
                      ],
                    ),
                  ),
                  // Row()
                ],
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Name != null ? Text("Hello! " + Name!) : const Text(''),
              )
            ],
          ),
          ListTile(
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (c) {
              return ContactSelector(
                updatehome: widget.updatehome,
              );
            })).then((value) => widget.updatehome()),
            leading: const Icon(Icons.contacts_rounded),
            title: const Text("Contacts"),
          ),
          ListTile(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (c) {
              return UpdatePfp(
                Name: Name!,
                user: widget.user,
                JWT: JWTToken!,
              );
            })).then(
                (value) => {imageCache.clear(), imageCache.clearLiveImages()}),
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
          ),
          ElevatedButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: const Text("Logout"))
        ],
      ),
    );
  }
}
