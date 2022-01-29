import 'package:flutter/material.dart';

class NameCollector extends StatelessWidget {
  final Function NameSetter;
  const NameCollector({Key? key, required this.NameSetter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Enter Your Display Name"),
        TextField(
          controller: controller,
        ),
        ElevatedButton(
            onPressed: () {
              NameSetter(controller.text);
              FocusScope.of(context).unfocus();
            },
            child: Text("Use this Name ?"))
      ],
    );
  }
}
