import 'dart:async';
import 'dart:convert';

import 'package:baata/Screens/home/drawer.dart';
import 'package:baata/Screens/home/messagePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UserHome extends StatefulWidget {
  User user;
  final Function ThemeSetter;
  final ThemeMode ct;

  UserHome(
      {Key? key,
      required this.user,
      required this.ThemeSetter,
      required this.ct})
      : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  List? MessageList;
  String? token;
  String? newinitialId;
  void FetchuserMessages() async {
    token = await widget.user.getIdToken();
    http.Response res = await http.get(Uri.parse(
        "http://192.168.1.69:5000/profile/getMessage/metadata/jwt=$token"));
    MessageList = jsonDecode(res.body);
    setState(() {});
  }

  void getToken() async {
    token = await widget.user.getIdToken();
    setState(() {});
    Timer.periodic(Duration(hours: 1), (timer) async {
      token = await widget.user.getIdToken();
      setState(() {});
    });
  }

  void updateMessagingToken() async {
    String messagingtoken = await messaging.getToken() ?? "";
    http.Response res = await http.post(
        Uri.parse("http://192.168.1.69:5000/profile/SetFmcToken"),
        body: jsonEncode({"Fmc": messagingtoken}),
        headers: {"jwt": token!});
    print(messagingtoken);
  }

  @override
  void initState() {
    getToken();
    updateMessagingToken();
    // TODO: implement initState
    FetchuserMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      FetchuserMessages();
    });
    return Scaffold(
      drawer: Drawer(
          child: CustomDrawer(
        user: widget.user,
        ThemeSetter: widget.ThemeSetter,
        ct: widget.ct,
      )),
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.search_sharp),
          ),
        ],
      ),
      body: MessageList == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ListView.builder(
                itemCount: MessageList!.length,
                itemBuilder: (context, index) {
                  String sender = MessageList![index]['u1'] == widget.user.uid
                      ? MessageList![index]['u2']
                      : MessageList![index]['u1'];
                  String senderName =
                      MessageList![index]['u1'] == widget.user.uid
                          ? MessageList![index]['n2']
                          : MessageList![index]['n1'];
                  String UserNumber =
                      MessageList![index]['u1'] == widget.user.uid ? "1" : "2";
                  DateTime DT = DateTime.parse(
                      MessageList![index]['lastMessageTime'].toString());
                  String Time = DateFormat("h:mma").format(DT);
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (c) {
                          return MessagePage(
                            messageId: MessageList![index]['_id'],
                            Senderuid: sender,
                            SenderName: senderName,
                            Token: token!,
                          );
                        })).then((value) => FetchuserMessages());
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.black,
                                  foregroundImage: NetworkImage(
                                      "http://192.168.1.69:5000/profile/get/jwt=$token&uid=$sender"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    senderName,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(Time),
                                if (MessageList![index]['unReadMessages']
                                        ['u' + UserNumber] !=
                                    0)
                                  Text(MessageList![index]['unReadMessages']
                                          ['u' + UserNumber]
                                      .toString()),
                              ],
                            )
                          ]),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
