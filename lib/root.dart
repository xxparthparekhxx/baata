import 'package:baata/Screens/home/logedin_page_root.dart';
import 'package:baata/Screens/AuthScreens/signinpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Settings/manager.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  SharedPreferences? prefs;
  ThemeMode CurrentTheme = ThemeMode.system;
  void getSavedThemeMode() async {
    prefs = await SharedPreferences.getInstance();
    String? userTheme = prefs!.getString("CurrentTheme");

    if (userTheme == null) {
      CurrentTheme = ThemeMode.system;
    } else if (userTheme == "l") {
      CurrentTheme = ThemeMode.light;
    } else if (userTheme == 'd') {
      CurrentTheme = ThemeMode.dark;
    }
    setState(() {});
  }

  @override
  void initState() {
    getSavedThemeMode();
    super.initState();
  }

  void updateTheme(ThemeMode mode) async {
    setState(() {
      CurrentTheme = mode;
    });
    String theme = '';
    if (mode == ThemeMode.light) {
      theme = 'l';
    }
    if (mode == ThemeMode.dark) {
      theme = 'd';
    }

    await prefs!.setString("CurrentTheme", theme);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.orange,
            primaryTextTheme: const TextTheme(
                headline1: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                headline2: TextStyle(fontSize: 24, color: Colors.orange))),
        /* light theme settings */

        darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.orange,
            primaryTextTheme: const TextTheme(
                headline1: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                headline2: TextStyle(fontSize: 24, color: Colors.orange)),
            /* dark theme settings */
            appBarTheme: const AppBarTheme(
                color: Colors.orange,
                titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24))),
        themeMode: CurrentTheme,
        home: loginflow(ThemeSetter: updateTheme, ct: CurrentTheme));
  }
}

class loginflow extends StatefulWidget {
  final Function ThemeSetter;
  final ThemeMode ct;
  const loginflow({Key? key, required this.ThemeSetter, required this.ct})
      : super(key: key);

  @override
  loginflowState createState() => loginflowState();
}

class loginflowState extends State<loginflow> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? x;
  uManager? Settings;

  @override
  Widget build(BuildContext context) {
    auth.authStateChanges().listen((User? user) {
      if (user != null && x == null) {
        setState(() {
          x = user;
          Settings = uManager(person: user, auth: auth);
        });
      } else if (user == null && x != null) {
        setState(() {
          x = null;
        });
      }
    });
    return Scaffold(
        body: x != null
            ? loggedinPage(
                profile: x!,
                Settings: Settings!,
                ThemeSetter: widget.ThemeSetter,
                ct: widget.ct,
                updatehome: () {},
              )
            : SignInPage(authinstance: auth));
  }
}
