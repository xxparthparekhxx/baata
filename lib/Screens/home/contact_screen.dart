import 'package:baata/Screens/home/contact.dart';
import 'package:baata/Screens/home/messagePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart';

class ContactSelector extends StatefulWidget {
  final Function updatehome;
  const ContactSelector({Key? key, required this.updatehome}) : super(key: key);

  @override
  _ContactSelectorState createState() => _ContactSelectorState();
}

class _ContactSelectorState extends State<ContactSelector> {
  TextEditingController SearchController = TextEditingController();
  List<Contact>? ContactList;
  String? idToken;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> contactFectcher() async {
    if (await FlutterContacts.requestPermission()) {
      // Get all contacts (lightly fetched)
      ContactList = await FlutterContacts.getContacts(withProperties: true);
      setState(() {});
    }
  }

  Future<void> tokenGetter() async {
    idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
  }

  @override
  void initState() {
    tokenGetter();
    contactFectcher();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ContactList != null) {
      SearchController.addListener(() => setState(() {}));
      return Scaffold(
        appBar: AppBar(
          // title: const Text("Send Your First Message"),
          actions: [
            Container(
              width: 300,
              child: TextField(
                controller: SearchController,
              ),
            )
          ],
        ),
        body: ListView.builder(
            itemCount: ContactList!.length,
            itemBuilder: (ctx, index) {
              if (ContactList![index].phones.isNotEmpty &&
                  ContactList![index]
                      .displayName
                      .toLowerCase()
                      .contains(SearchController.text.toLowerCase())) {
                String Phonenumber = ContactList![index]
                    .phones
                    .elementAt(0)
                    .number
                    .replaceAll(" ", "");
                if (!Phonenumber.startsWith("+91")) {
                  print(Phonenumber);
                  Phonenumber = "+91" + Phonenumber;
                  print(Phonenumber);
                }
                Contact cc = ContactList![index];
                return contactTile(
                  DisplayName: cc.displayName,
                  PhoneNumber: Phonenumber,
                  Token: idToken!,
                  uid: uid,
                  updatehome: widget.updatehome,
                );
              } else {
                return const SizedBox();
              }
            }),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Start Messaging"),
        ),
        body: Column(children: [
          LinearProgressIndicator(),
          Center(
            child: Text("Loading Your Contacts"),
          )
        ]),
      );
    }
  }
}
