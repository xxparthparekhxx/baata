import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Auth with ChangeNotifier {
  FirebaseAuth instance;
  String? token = '';

  Auth(this.instance) {
    Timer.periodic(const Duration(minutes: 30), (e) async {
      token = await instance.currentUser?.getIdToken();
    });
    instance.authStateChanges().listen((event) async {
      token = await instance.currentUser?.getIdToken();
    });
  }
}
