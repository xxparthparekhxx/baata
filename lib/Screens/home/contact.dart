import 'dart:convert';

import 'package:baata/Screens/home/newmessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class contactTile extends StatefulWidget {
  String Token;
  String PhoneNumber;
  String DisplayName;
  String uid;
  Function updatehome;
  contactTile(
      {Key? key,
      required this.DisplayName,
      required this.PhoneNumber,
      required this.Token,
      required this.uid,
      required this.updatehome})
      : super(key: key);

  @override
  _contactTileState createState() => _contactTileState();
}

class _contactTileState extends State<contactTile> {
  bool isUser = false;
  String? status;
  var resData;

  void getStatus() async {
    Response res = await get(Uri.parse(
        "http://192.168.1.69:80/status/get/jwt=${widget.Token}&uid=${widget.PhoneNumber}"));

    print(res.body);
    print("THIS IS RES DATA" + res.body);
    if (res.body != "Not Found" && mounted) {
      resData = jsonDecode(res.body);
      status = resData!['status'];
      isUser = true;
      if (resData['name'] == null) isUser = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    getStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (status != null &&
            resData["name"] != null &&
            resData['uid'] != FirebaseAuth.instance.currentUser!.uid) {
          print(resData);
          Navigator.push(context, MaterialPageRoute(builder: (c) {
            return newMessageStart(
              Token: widget.Token,
              data: resData,
              updatehome: widget.updatehome,
            );
          }));
        }
      },
      leading: CircleAvatar(
        radius: 40,
        foregroundImage: NetworkImage(
            "http://192.168.1.69:80/contact/get/jwt=${widget.Token}&pno=${widget.PhoneNumber}"),
        onForegroundImageError: (o, e) => print('notFound'),
        backgroundColor: Colors.black,
        child: Text(widget.DisplayName.substring(0, 2)),
      ),
      title: Text(widget.DisplayName),
      subtitle: Text(status == null ? widget.PhoneNumber : status!),
      trailing: isUser
          ? null
          : ElevatedButton(onPressed: () {}, child: Text("Invite")),
    );
  }
}
