import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class MyDropdown extends StatefulWidget {
  const MyDropdown({Key? key, required this.onChanged}) : super(key: key);
  final ValueChanged<String> onChanged;

  @override
  _MyDropdownState createState() => _MyDropdownState();


}

class _MyDropdownState extends State<MyDropdown> {
  String dropdownValue = 'vegetable';

  @override
  Widget build(BuildContext context) {

    return DropdownButton<String>(
      dropdownColor:
      Theme.of(context).scaffoldBackgroundColor,
      focusColor:
      Theme.of(context).scaffoldBackgroundColor,
      value: dropdownValue,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
        widget.onChanged(newValue!);
      },
      items: <String>[
        "vegetable",
        "Fruits",
        "Spices",
        "Herbs",
        "Nuts",
        "Grains",
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

