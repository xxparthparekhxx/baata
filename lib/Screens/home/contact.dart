import 'dart:convert';

import 'package:baata/Screens/home/newmessage.dart';
import 'package:baata/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:share_plus/share_plus.dart';

class contactTile extends StatefulWidget {
  final String Token;
  final String PhoneNumber;
  final String DisplayName;
  final String uid;
  final Function updatehome;
  const contactTile(
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
        "http://52.66.199.213:5000/status/get/jwt=${widget.Token}&uid=${widget.PhoneNumber}"));

    // print(res.body);
    // print("THIS IS RES DATA" + res.body);
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

  void inviteFunction() => Share.share(
      'check out my website https://example.com',
      subject:
          "Lets Chat on Baata It's a Fast Simple And Secure Chat App we can use to message each other for free. Get it at https://baata.ml");

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (status != null &&
            resData["name"] != null &&
            resData['uid'] != FirebaseAuth.instance.currentUser!.uid) {
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
            "${URL}contact/get/jwt=${widget.Token}&pno=${widget.PhoneNumber}"),
        onForegroundImageError: (o, e) => {},
        backgroundColor: Colors.black,
        child: Text(widget.DisplayName.length > 2
            ? widget.DisplayName.substring(0, 2)
            : widget.DisplayName),
      ),
      title: Text(widget.DisplayName),
      subtitle: Text(status == null ? widget.PhoneNumber : status!),
      trailing: isUser
          ? null
          : ElevatedButton(
              onPressed: inviteFunction, child: const Text("Invite")),
    );
  }
}
