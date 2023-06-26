import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/consts/constants.dart';
import 'package:grocery_admin_panel/widgets/header.dart';
import '../responsive.dart';
import '../widgets/order_widget.dart';
class OrderGrid extends StatefulWidget {
   OrderGrid({Key? key, this.count, required this.isMain }) : super(key: key);
   final int? count;
   final bool isMain;

  @override
  State<OrderGrid> createState() => _OrderGridState();
}

class _OrderGridState extends State<OrderGrid> {
  List<DocumentSnapshot>? orders;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('orders').orderBy('order_dat').get().then((snapshot) {
      setState(() {
        orders = snapshot.docs;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double FontSize = size.width <600 ? 25 :32;
    if (orders == null){

      return  const Padding(
        padding: EdgeInsets.all(50.0),

      );
    }else if (orders != null && orders!.isEmpty){

      return  Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.isMain ? 'Last Orders': 'Orders',style: TextStyle(fontSize: FontSize,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
            ),
             Padding(
              padding: EdgeInsets.all(size.height*.2),
              child: const Text('No Orders Yet :/'),
            ),
          ],
        ),
      );
    }
    else{
      orders = orders!.reversed.toList();

      return  SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              widget.isMain ? const SizedBox():Header(
                fct: () {
                  Scaffold.of(context).openDrawer();
                },
                isMain: false,
              ),
              const SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Text(widget.isMain ? 'Last Orders': 'Orders',style: TextStyle(fontSize: FontSize,fontWeight: FontWeight.bold),)
                            ],
                          ),
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:widget.count ?? orders!.length,
                            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: Responsive.isMobile(context)? 3.2:Responsive.isTablet(context)?2.6 :2.7,
                              crossAxisSpacing: 10,
                              crossAxisCount:Responsive.isDesktop(context)? 3 : Responsive.isTablet(context) ? 2  : 1,
                            ),
                            itemBuilder: (context, index) {
                              return  Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: OrdersWidget(
                                  title: orders![index]['productName'],
                                  unit: orders![index]['unit'],
                                  email : orders![index]['email'],
                                  address: orders![index]['address'],
                                  userName: orders![index]['user_name'],
                                  imageUrl: orders![index]['imageUrl'],
                                  quantity: orders![index]['quantity'],
                                  totalPrice: orders![index]['total_price'],
                                  date: orders![index]['order_dat'], paymentMethod:  orders![index]['payment_option'],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );    }
  }
}
