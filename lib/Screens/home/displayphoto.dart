import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class displayphoto extends StatefulWidget {
  XFile image;
  String chatid;
  String selfuid;
  String token;
  displayphoto(
      {Key? key,
      required this.image,
      required this.chatid,
      required this.selfuid,
      required this.token})
      : super(key: key);

  @override
  State<displayphoto> createState() => _displayphotoState();
}

class _displayphotoState extends State<displayphoto> {
  TextEditingController Message = TextEditingController();
  File? imageFile;
  @override
  void initState() {
    imageFile = File(widget.image.path);
    super.initState();
  }

  void sendImagetoid({required String id, required File Image}) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://192.168.1.69:5000/PostImageToId"),
    );
    Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "jwt": widget.token
    };
    Map<String,Object> meta = {
          "id": id,
          "Sender": widget.selfuid,
          "messageTime": DateTime.now().millisecondsSinceEpoch,
          "MessageText": Message.text,
          "isMedia": true,
          "MediaType": "Image"
        };
    request.fields['data'] = jsonEncode(meta);
    request.files.add(http.MultipartFile(
        'image', Image.readAsBytes().asStream(), Image.lengthSync(),
        filename: ''));
    

    request.headers.addAll(headers);
    var res = await request.send();
    http.Response response = await http.Response.fromStream(res);
    if(response.statusCode == 200){
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: widget.image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Resize your image',
            toolbarColor: Colors.orange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false
            showCropGrid: false
            ),
        iosUiSettings: const IOSUiSettings(
          title: 'Resize Your Image',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {});
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7 -
                      MediaQuery.of(context).viewInsets.bottom -
                      20),
              child: Center(
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () {
                          _cropImage();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.crop,
                            size: 50,
                          ),
                        ))
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
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
                              SizedBox(width: 10),
                              TextField(
                                style: TextStyle(color: Colors.black),
                                controller: Message,
                                decoration: InputDecoration(
                                    hintText: "Message",
                                    hintStyle: TextStyle(color: Colors.black12),
                                    border: InputBorder.none,
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width -
                                              130,
                                    )),
                              ),
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
                              sendImagetoid(
                                  id: widget.chatid, Image: imageFile!);

                              //todo implement sendind data
                              // text will have sender_uid,Text,time, and it will retrive the new chat id and messages then ss
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Icon(Icons.send),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
