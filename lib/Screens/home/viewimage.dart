import 'package:baata/Screens/home/networimage.dart';
import 'package:flutter/material.dart';

class ViewImage extends StatefulWidget {
  final String url;
  final String Tag;
  const ViewImage({Key? key, required this.url, required this.Tag})
      : super(key: key);

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: InteractiveViewer(
        child: Center(
          child: Hero(
            tag: "photo" + widget.Tag,
            child: NetworkImg(url: widget.url),
          ),
        ),
      ),
    );
  }
}
