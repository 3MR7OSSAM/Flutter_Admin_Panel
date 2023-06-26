import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/widgets/dashbord_cards.dart';

import '../responsive.dart';

class CardsGrid extends StatefulWidget {
  CardsGrid({Key? key}) : super(key: key);

  @override
  State<CardsGrid> createState() => _CardsGridState();
}

class _CardsGridState extends State<CardsGrid> {
  final titles = ['Profit', 'Products', 'Orders'];
  double profit = 0.0;
  int? products ;
  int orders = 0;
  final values = [];
  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('orders')
        .snapshots(includeMetadataChanges: true)
        .first
        .then((ordersSnapshot) {
      orders = ordersSnapshot.docs.length;
      FirebaseFirestore.instance
          .collection('products')
          .snapshots(includeMetadataChanges: true)
          .first
          .then((productsSnapshot) {
        products = productsSnapshot.docs.length;
        setState(() {
          for (int i = 0; i < ordersSnapshot.docs.length; i++) {
            profit += ordersSnapshot.docs[i]['total_price'] ?? 0.0;
          }
        });
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    if(products == null){
      return const Padding(
        padding: EdgeInsets.all(50),
        child: CircularProgressIndicator(),
      );
    }else{
      values.clear();
      values.add(profit.toString());
      values.add(products.toString());
      values.add(orders.toString());
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: titles.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio:
          Responsive.isDesktop(context) ? 3 : 2.9,
          crossAxisSpacing: 10,
          crossAxisCount: Responsive.isDesktop(context)
              ? 3
              : Responsive.isTablet(context)
              ? 2
              : 1,
        ),
        itemBuilder: (context, index) {
          return DashBordCards(
            title: titles[index],
            value: index == 0 ? '\$ ${values[index]}' : values[index],
          );
        },
      );
    }
  }
}
