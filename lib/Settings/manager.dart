import 'dart:async';
import 'dart:convert';

import 'package:baata/Settings/models/appuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

enum UserStates {
  existing,
  newUser,
}

class uManager {
  User person;
  FirebaseAuth auth;
  var Ustate;

  uManager({required this.person, required this.auth});

  Future<http.Response> rw({required String url, idtoken, body}) {
    return http.post(
      Uri.parse(url),
      headers: {"jwt": idtoken},
      body: body,
    );
  }

  Stream<UserStates> userDetails() async* {
    const String Address = 'http://192.168.1.69:80/';
    String idtoken;

    idtoken = await person.getIdToken();

    http.Response? res;
    while (res == null || res.statusCode != 200) {
      try {
        res = await rw(
          url: Address + "profile/uudetails",
          idtoken: idtoken,
        );
        await Future.delayed(Duration(seconds: 1));
      } catch (e) {}
    }

    var userdata = jsonDecode(res.body);
    if (userdata.keys.contains('name')) {
      yield UserStates.existing;
    } else {
      yield UserStates.newUser;
    }
  }
}
