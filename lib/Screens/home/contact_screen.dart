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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.orange,
                    ),
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.black54),
                            hintText: "  Search Your Contacts"),
                        controller: SearchController,
                      ),
                    ),
                  ],
                ),
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
                      .startsWith(SearchController.text.toLowerCase())) {
                String Phonenumber = ContactList![index]
                    .phones
                    .elementAt(0)
                    .number
                    .replaceAll(" ", "");
                if (!Phonenumber.startsWith("+91")) {
                  Phonenumber = "+91" + Phonenumber;
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
          title: const Text("Start Messaging"),
        ),
        body: Column(children: const [
          LinearProgressIndicator(),
          Center(
            child: Text("Fetching Your Contacts"),
          )
        ]),
      );
    }
  }
}
