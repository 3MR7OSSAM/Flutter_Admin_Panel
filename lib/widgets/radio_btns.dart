import 'package:flutter/material.dart';

class RadioBtn extends StatefulWidget {
  final ValueChanged<int> onChanged;

  RadioBtn({Key? key, required this.onChanged}) : super(key: key);

  @override
  _RadioBtnState createState() => _RadioBtnState();
}

class _RadioBtnState extends State<RadioBtn> {
  int? _selectedValue =1;

  @override
  Widget build(BuildContext context) {
    final options = [
      {"label": "KG", "value": 1},
      {"label": "Piece", "value": 2},
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((option) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<int>(
              activeColor: Colors.blue,
              focusColor: Colors.blue,
              value: int.parse(option['value'].toString()),
              groupValue: _selectedValue,
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
                widget.onChanged(value!);
              },
            ),
            Text(option['label'].toString()),
          ],
        );
      }).toList(),
    );
  }
}
