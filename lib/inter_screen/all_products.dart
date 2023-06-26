import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/widgets/side_menu.dart';
import '../consts/constants.dart';
import '../responsive.dart';
import '../widgets/grid_products.dart';
import '../widgets/header.dart';
import '../widgets/product_widget.dart';

class ProductScreen extends StatelessWidget {

  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double FontSize = size.width <600 ? 20 :28;
    return SafeArea(
        child: Scaffold(
          drawer: const SideMenu(),
          body: Builder(
          builder: (context) => SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          }, isMain: false,
                        ),
                        Text('All Products',style: TextStyle(fontSize: FontSize,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),

                        const ProductGridWidget(isMain: false)
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
