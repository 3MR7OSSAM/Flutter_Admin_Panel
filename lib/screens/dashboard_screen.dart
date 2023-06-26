import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/consts/constants.dart';
import 'package:grocery_admin_panel/inter_screen/product_upload.dart';
import 'package:grocery_admin_panel/widgets/header.dart';
import 'package:grocery_admin_panel/widgets/orders_grid.dart';
import '../widgets/cards_grid.dart';
import '../widgets/custom_button.dart';
import '../widgets/grid_products.dart';
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    double FontSize = size.width <600 ? 25 :32;

    return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(
                fct: () {
                  Scaffold.of(context).openDrawer();
                },
                isMain: true,
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
                              Row(
                                children: [
                                  CustomButon(text: 'View All',onTap: (){},icon: Icons.list_alt,),
                                  const Spacer(),
                                  CustomButon(text: 'Add New',onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProductUpload()));
                                  },icon: Icons.add,),
                                ],
                              ),
                              CardsGrid(),
                              OrderGrid(count: 3,isMain: true,),
                              Text('Last Products ',style: TextStyle(fontSize: FontSize,fontWeight: FontWeight.bold,),),
                            ],
                          ),
                          const ProductGridWidget(isMain: true,)
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
  }
}
