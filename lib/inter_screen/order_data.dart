import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import '../consts/constants.dart';
import '../responsive.dart';
import '../widgets/side_menu.dart';
import 'package:grocery_admin_panel/widgets/header.dart';

class OrderData extends StatelessWidget {
  const OrderData({Key? key, required this.title, required this.unit, required this.userName, required this.imageUrl, required this.quantity, required this.totalPrice, required this.date, required this.address, required this.email, required this.paymentMethod}) : super(key: key);
  final String title, unit, userName, imageUrl, quantity, totalPrice,date,address,email,paymentMethod;
  @override
  Widget build(BuildContext context) {

    var Size = MediaQuery.of(context).size;
    double FontSize = Size.width < 600 ? 11 : 18;
    return SafeArea(
      child: Scaffold(
        drawer: const SideMenu(),
        body: Builder(
          builder: (context) => SafeArea(
            child: Row(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // We want this side menu only for large screen
                if (Responsive.isDesktop(context))
                  const Expanded(
                    child: SideMenu(),
                  ),
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      children: [
                        Header(
                          fct: () {
                            Scaffold.of(context).openDrawer();
                          },
                          isMain: false,
                        ),
                        Container(
                          width: Size.width * 0.75,
                          height: Size.height * 0.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.grey.withOpacity(0.3)),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Orders Details',
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.all(Size.width*.03),
                                    child: FancyShimmerImage(imageUrl:imageUrl,boxFit: BoxFit.contain,width: Size.width*.25,height:Size.height*0.3 ,),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      Text(
                                        'Title : $title',
                                        style:  TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: FontSize,
                                        ),
                                      ),
                                       const SizedBox(height: 8),
                                      Text(
                                        'By : $userName',
                                        style:  TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: FontSize,
                                        ),
                                      ),
                                       Text(
                                        'Email : $email',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: FontSize,
                                        ),
                                      ),
                                       Text(
                                        'Address : $address',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: FontSize,
                                        ),
                                      ),
                                      Text(
                                        'Order Date :  $date ',
                                        style:  TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: FontSize,
                                        ),
                                      ),
                                      Text(
                                        'Payment :  $paymentMethod ',
                                        style:  TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: FontSize,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Center(
                                        child: Text(
                                          'Total : $totalPrice\$ for $quantity $unit',
                                          style:  TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: FontSize,
                                            decoration: TextDecoration.underline
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
