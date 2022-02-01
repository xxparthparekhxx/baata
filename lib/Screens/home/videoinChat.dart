import 'dart:typed_data';

import 'package:baata/Screens/home/videoplayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VideoInChat extends StatefulWidget {
  final BoxDecoration decoration;
  final String Token;
  final int index;
  final String messageId;
  VideoInChat({
    Key? key,
    required this.decoration,
    required this.Token,
    required this.index,
    required this.messageId,
  }) : super(key: key);

  @override
  State<VideoInChat> createState() => _VideoInChatState();
}

class _VideoInChatState extends State<VideoInChat> {
  void displayvideo(final String url) {
    Navigator.push(context, MaterialPageRoute(builder: (c) {
      return VideoApp(
        Token: widget.Token,
        Url: url,
      );
    }));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        height: 200,
        padding: EdgeInsets.all(10),
        decoration: widget.decoration,
        child: GestureDetector(
            onTap: () => displayvideo(
                "http://192.168.1.69:80/messageVideo/id=${widget.messageId}&i=${widget.index}"),
            child: Container(
                color: Colors.black,
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  CachedNetworkImage(
                    imageUrl:
                        "http://192.168.1.69:80/getVidThumb/id=${widget.messageId}idx=${widget.index}",
                    httpHeaders: {"jwt": widget.Token},
                  ),
                  Icon(Icons.play_arrow_sharp)
                ]))));
  }
}
