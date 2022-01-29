import 'package:flutter/material.dart';

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Image.network(
              "https://memegenerator.net/img/instances/61937400/something-went-wrong.jpg")),
    );
  }
}
