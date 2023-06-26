import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/widgets/orders_grid.dart';
import 'package:grocery_admin_panel/widgets/side_menu.dart';
import '../responsive.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const SideMenu(),
        body: Builder(
          builder: (context) => SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Responsive.isDesktop(context))
                  const Expanded(
                    child: SideMenu(),
                  ),
                 Expanded(
                  flex: 5,
                  child: OrderGrid(isMain: false,),
                ),
              ],
            ),
          ),
        ));
  }
}
