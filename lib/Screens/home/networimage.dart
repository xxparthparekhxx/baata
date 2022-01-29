import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImg extends StatefulWidget {
  final String url;
  final String Token;
  const NetworkImg({Key? key, required this.url, required this.Token})
      : super(key: key);

  @override
  State<NetworkImg> createState() => _NetworkImgState();
}

class _NetworkImgState extends State<NetworkImg> {
  Image? image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fadeInDuration: const Duration(days: 0),
      imageUrl: widget.url,
      httpHeaders: {"jwt": widget.Token},
      // progressIndicatorBuilder: (context, url, downloadProgress) => Container(
      //     color: Colors.black,
      //     height: 175,
      //     width: 200,
      //     child:
      //         CircularProgressIndicator(value: downloadProgress.progress))
    );
  }
}
