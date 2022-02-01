import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:baata/Screens/home/videoinChat.dart';
import 'package:http/http.dart' as http;
import 'package:baata/Screens/home/networimage.dart';

import 'package:baata/Screens/home/viewimage.dart';
import 'package:baata/Screens/home/displayphoto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class MessagePage extends StatefulWidget {
  final String Senderuid;
  final String messageId;
  final String SenderName;
  final String Token;
  const MessagePage(
      {Key? key,
      required this.messageId,
      required this.Senderuid,
      required this.SenderName,
      required this.Token})
      : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  StreamSubscription<RemoteMessage>? listener;
  List? ChatMessages;
  String? chatState;
  ScrollController MIController = ScrollController();
  String selfUid = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController Message = TextEditingController();
  int sSindexSs = 0;

  @override
  void initState() {
    listener = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      UpdateMessagesWithId(widget.messageId);
      setState(() {});
    });
    UpdateMessagesWithId(widget.messageId);
    super.initState();
  }

  void UpdateMessagesWithId(id) async {
    Response res = await post(
        Uri.parse('http://192.168.1.69:80/getMessageFormid'),
        headers: {"jwt": widget.Token},
        body: jsonEncode({"id": id}));

    ChatMessages = jsonDecode(res.body);
    chatState = "E";
    setState(() {});
    jupmtobottom();
  }

  void StartMessaging(Map message) async {
    Response res = await post(
        Uri.parse('http://192.168.1.69:80/StartMessagingWithNewContact'),
        headers: {"jwt": widget.Token},
        body: jsonEncode(message));

    UpdateMessagesWithId(res.body);
  }

  void sendMessageToId(
      {required String id,
      required String textmessage,
      required bool isMedia}) async {
    Response res =
        await post(Uri.parse('http://192.168.1.69:80/postMessageToId'),
            headers: {"jwt": widget.Token},
            body: jsonEncode({
              "id": id,
              "Sender": selfUid,
              "messageTime": DateTime.now().millisecondsSinceEpoch,
              "MessageText": textmessage,
              "isMedia": isMedia
            }));
    UpdateMessagesWithId(id);
  }

  void displayimage(final XFile image) {
    Navigator.push(context, MaterialPageRoute(builder: (c) {
      return displayphoto(
        image: image,
        chatid: widget.messageId,
        selfuid: selfUid,
        token: widget.Token,
      );
    })).then((value) => UpdateMessagesWithId(widget.messageId));
  }

  void sendVideotoid(
      {required final String id, required final String Path}) async {
    int idx = ChatMessages!.length;
    ChatMessages!.add(
        {"Sender": selfUid, "isMedia": true, "MediaType": "Video", "up": ''});
    setState(() {});

    await Future.delayed(const Duration(milliseconds: 50));
    jupmtobottom();
    File video = File(Path);

    final http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.parse("http://192.168.1.69:80/PostVideoToId"),
    );
    final Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "jwt": widget.Token
    };
    final Map<String, Object> meta = {
      "id": id,
      "Sender": selfUid,
      "messageTime": DateTime.now().millisecondsSinceEpoch,
      "MessageText": Message.text,
      "isMedia": true,
      "MediaType": "Video"
    };
    request.fields['data'] = jsonEncode(meta);
    request.files.add(http.MultipartFile(
        'video', video.readAsBytes().asStream(), video.lengthSync(),
        filename: video.path.split("/").last.split(".").last));

    request.headers.addAll(headers);
    var res = await request.send();
    http.Response response = await http.Response.fromStream(res);
    if (response.statusCode == 200) {
      if (idx > ChatMessages!.length) {
        ChatMessages!.removeLast();
      } else {
        ChatMessages!.removeAt(idx);
      }
      setState(() {});
      UpdateMessagesWithId(id);
    }
  }

  void prompToPickImage() {
    showModalBottomSheet(
        context: context,
        builder: (con) => Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                // Pick video Camera
                contentPadding: const EdgeInsets.all(10),
                onTap: () async {
                  XFile? file = await ImagePicker().pickVideo(
                      source: ImageSource.camera,
                      maxDuration: const Duration(hours: 3));
                  if (file != null) {}
                },
                leading: const Icon(Icons.video_collection),
                title: const Text("Video"),
              ),
              ListTile(
                // Pick Image camera
                contentPadding: const EdgeInsets.all(10),
                onTap: () async {
                  XFile? file =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  if (file != null) {
                    displayimage(file);
                  }
                },
                leading: const Icon(Icons.photo),
                title: const Text("Photo"),
              ),
              ListTile(
                // Pick video Gallery
                contentPadding: const EdgeInsets.all(10),
                onTap: () async {
                  XFile? file = await ImagePicker().pickVideo(
                      source: ImageSource.gallery,
                      maxDuration: const Duration(hours: 3));
                  if (file != null) {
                    sendVideotoid(id: widget.messageId, Path: file.path);
                  }
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.video_call_sharp),
                title: const Text("Video (Gallery)"),
              ),
              ListTile(
                // Pick Image Gallery
                contentPadding: const EdgeInsets.all(10),
                onTap: () async {
                  XFile? file = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (file != null) {
                    displayimage(file);
                  }
                },
                leading: const Icon(Icons.photo),
                title: const Text("Photo (Gallery)"),
              ),
            ]));
  }

  void jupmtobottom() async {
    await Future.delayed(const Duration(milliseconds: 20));
    bool scrolled = false;
    while (
        MIController.position.pixels != MIController.position.maxScrollExtent &&
            mounted) {
      try {
        MIController.animateTo(MIController.position.maxScrollExtent,
            curve: Curves.ease, duration: const Duration(milliseconds: 10));
        await Future.delayed(const Duration(milliseconds: 20));
      } catch (e) {
        break;
      }
    }
  }

  BoxDecoration messagebubble(index) {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomRight: ChatMessages![index]['Sender'] == selfUid
              ? const Radius.circular(0)
              : const Radius.circular(20),
          bottomLeft: ChatMessages![index]['Sender'] == selfUid
              ? const Radius.circular(20)
              : const Radius.circular(0),
        ));
  }

  void DisplayHeroPhoto(index) {
    Navigator.push(context, MaterialPageRoute(builder: (c) {
      return ViewImage(
          Token: widget.Token,
          Tag: index.toString(),
          url:
              "http://192.168.1.69:80/messageimage/id=${widget.messageId}&i=$index");
    }));
  }

  @override
  void dispose() {
    listener!.cancel();
    listener = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    listener;

    double query = MediaQuery.of(context).viewInsets.bottom;
    if (query != 0) {
      MIController.jumpTo(MIController.position.maxScrollExtent);
    }
// "MediaType" Image
    return Scaffold(
        appBar: AppBar(
            title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          CircleAvatar(
            foregroundImage: NetworkImage(
                "http://192.168.1.69:80/profile/get/jwt=${widget.Token}&uid=${widget.Senderuid}"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(widget.SenderName),
          ),
        ])),
        body: chatState == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  chatState != "New" && ChatMessages != null
                      ? ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: (MediaQuery.of(context).size.height -
                                      MediaQuery.of(context)
                                          .viewInsets
                                          .bottom) -
                                  153),
                          child: ListView.builder(
                            controller: MIController,
                            itemCount: ChatMessages!.length,
                            cacheExtent: ChatMessages!.length.toDouble(),
                            itemBuilder: (BuildContext context, int index) {
                              sSindexSs = index;

                              return Row(
                                mainAxisAlignment:
                                    ChatMessages![index]['Sender'] == selfUid
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ChatMessages![index]['isMedia']
                                          ? ChatMessages![index]['MediaType'] ==
                                                  "Image"
                                              ? Container(
                                                  decoration:
                                                      messagebubble(index),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: GestureDetector(
                                                    onTap: () =>
                                                        DisplayHeroPhoto(index),
                                                    child: ConstrainedBox(
                                                        constraints:
                                                            const BoxConstraints(
                                                                maxHeight: 175,
                                                                maxWidth: 200),
                                                        child: Hero(
                                                          tag: "photo" +
                                                              index.toString(),
                                                          child: NetworkImg(
                                                            Token: widget.Token,
                                                            url:
                                                                "http://192.168.1.69:80/messageimage/id=${widget.messageId}&i=$index",
                                                          ),
                                                        )),
                                                  ),
                                                )
                                              : ChatMessages![index]
                                                      .keys
                                                      .contains("up")
                                                  ? Container(
                                                      width: 200,
                                                      height: 200,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration:
                                                          messagebubble(index),
                                                      child: Container(
                                                        color: Colors.black,
                                                        child: const Center(
                                                            child:
                                                                const CircularProgressIndicator()),
                                                      ),
                                                    )
                                                  : VideoInChat(
                                                      Token: widget.Token,
                                                      decoration:
                                                          messagebubble(index),
                                                      index: index,
                                                      messageId:
                                                          widget.messageId,
                                                    )
                                          : Container(
                                              decoration: messagebubble(index),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                  ChatMessages![index]
                                                          ['MessageText'] ??
                                                      ChatMessages![index]
                                                          ["messageText"],
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ))
                                ],
                              );
                            },
                          ),
                        )
                      : const Center(child: Text("Start  Messaging")),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              TextField(
                                style: const TextStyle(color: Colors.black),
                                controller: Message,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width -
                                              130,
                                    )),
                              ),
                              InkWell(
                                onTap: () {
                                  prompToPickImage();
                                },
                                child: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Icon(
                                    Icons.file_present_sharp,
                                    color: Colors.black87,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(30)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            splashColor: Colors.black,
                            onTap: () {
                              Message.text != ''
                                  ? sendMessageToId(
                                      id: widget.messageId,
                                      textmessage: Message.text,
                                      isMedia: false)
                                  : null;

                              Message.text = '';
                              //todo implement sendind data
                              // text will have sender_uid,Text,time, and it will retrive the new chat id and messages then ss
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(11.0),
                              child: Icon(Icons.send),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ));
  }
}
