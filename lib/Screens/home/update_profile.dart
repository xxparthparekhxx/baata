import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class updateName extends StatefulWidget {
  final String Token;
  final String uid;

  updateName({Key? key, required this.Token, required this.uid})
      : super(key: key);

  @override
  State<updateName> createState() => _updateNameState();
}

class _updateNameState extends State<updateName> {
  final TextEditingController nameController = TextEditingController();
  void updateName(Name) async {
    http.post(Uri.parse("http://192.168.1.69:80/updatename"),
        body: jsonEncode({}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "Enter A new name"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child:
                      ElevatedButton(onPressed: () {}, child: Text("Submit")),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
