import 'package:flutter/material.dart';
import 'AuthWidgets/countrycodeslist.dart' as c;

class CountrySelect extends StatefulWidget {
  final Function CountryListTile;
  const CountrySelect({Key? key, required this.CountryListTile})
      : super(key: key);

  @override
  State<CountrySelect> createState() => _CountrySelectState();
}

class _CountrySelectState extends State<CountrySelect> {
  TextEditingController country_Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var ss = MediaQuery.of(context).size;
    country_Controller.addListener(() => setState(() {}));
    return SizedBox(
      height: ss.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: ss.width,
            height: ss.height * 0.9 - MediaQuery.of(context).viewInsets.bottom,
            child: ListView.builder(
              reverse: true,
              itemBuilder: (ctx, idx) {
                final Map<String, String> Data = c.COUNTRY_EXTENSIONS[idx];
                if (Data['name']!
                        .toLowerCase()
                        .startsWith(country_Controller.text.toLowerCase()) ||
                    country_Controller.text == '') {
                  return widget.CountryListTile(Data, ss, true);
                } else {
                  return const SizedBox();
                }
              },
              itemCount: c.COUNTRY_EXTENSIONS.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: country_Controller,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(3),
                  border: InputBorder.none,
                  hintText: " Search for your country"),
            ),
          )
        ],
      ),
    );
  }
}
