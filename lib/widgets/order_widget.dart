import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/inter_screen/order_data.dart';
import 'package:intl/intl.dart';

import '../services/utils.dart';

class OrdersWidget extends StatelessWidget {
  const OrdersWidget({
    Key? key,
    required this.title,
    required this.unit,
    required this.userName,
    required this.imageUrl,
    required this.quantity,
    required this.totalPrice,
    required this.date, required this.address, required this.email, required this.paymentMethod,
  }) : super(key: key);

  final String title, unit, userName, imageUrl, address,email,paymentMethod;
  final double quantity, totalPrice;
  final Timestamp date;

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('MM/dd/yyyy hh:mm - a');
    final String formatted = formatter.format(date.toDate());
    final color = Utils(context).color;

    return LayoutBuilder(
      builder: (context, constraints) {
        var size = constraints.biggest;
        double fontSize = size.width < 600 ? 12 : 14;

        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>  OrderData(
                          title: title,
                          unit: unit,
                          paymentMethod: paymentMethod ,
                          userName: userName,
                          imageUrl: imageUrl,
                          quantity: quantity.toString(),
                          totalPrice: totalPrice.toString(),
                          date: formatted, address: address, email: email,
                        )));
          },
          child: Material(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            elevation: 10,
            shadowColor: Colors.black,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                //color: const Color(0xFF1a1f3c),
              ),
              child: Row(
                children: [
                  Image(image: NetworkImage(imageUrl)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          width: size.width*0.5,
                          child: Text(
                            title,
                            maxLines: 2,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width < 600 ? 18 : 28,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 3,
                          ),
                          Text.rich(
                            TextSpan(
                              style: TextStyle(fontSize: fontSize),
                              children: [
                                TextSpan(
                                  text: 'By ',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize,
                                  ),
                                ),
                                TextSpan(
                                  text: userName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            '$totalPrice\$ for $quantity $unit',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: fontSize,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            formatted,
                            style: TextStyle(
                              color: color.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              fontSize: fontSize,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  // PopupMenuButton(
                  //   itemBuilder: (context) => [
                  //     PopupMenuItem(
                  //       child: const Text('Edit'),
                  //       value: 1,
                  //       onTap: () {},
                  //     ),
                  //     PopupMenuItem(
                  //       child: const Text(
                  //         'Delete',
                  //         style: TextStyle(color: Colors.red),
                  //       ),
                  //       value: 2,
                  //       onTap: () {},
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
