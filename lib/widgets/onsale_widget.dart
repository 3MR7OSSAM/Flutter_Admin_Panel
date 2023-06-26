import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class onSaleWidget extends StatefulWidget {
  onSaleWidget({Key? key, this.onChanged}) : super(key: key);

  final Function(String)? onChanged;
  @override
  State<onSaleWidget> createState() => _onSaleWidgetState();
}

class _onSaleWidgetState extends State<onSaleWidget> {
  bool showTextForm = false;
  bool isOnSale = false;
  TextEditingController _onSaleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.local_offer_outlined, color: Colors.blue),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showTextForm = !showTextForm;
                    isOnSale = !isOnSale;
                  });
                },
                child: const Text(
                  'Sale Price',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Visibility(
                  visible: showTextForm,
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                    ],
                    keyboardType: TextInputType.number,
                    controller: _onSaleController,
                    onChanged: widget.onChanged,
                    decoration: InputDecoration(
                      hintText: '\$',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.blue.withOpacity(0.6)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              // Other RadioButton options...
            ],
          )
        ],
      ),
    );
  }
}
