import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../inter_screen/edit_product.dart';
import '../methods/showBtmAlert.dart';
class ProductWidget extends StatefulWidget {
  const ProductWidget({Key? key, required this.id}) : super(key: key);
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
  final String id;
}
class _ProductWidgetState extends State<ProductWidget> {
  String title = '';
  String productCat = '';
  String? imageUrl;
  double price = 0.0;
  double salePrice = 0.0;
  String unit = '';

  @override
  void initState() {
    getProductsData();
    super.initState();
  }

  Future<void> getProductsData() async {
    try {
      final DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.id)
          .get();
      if (productDoc == null) {
        return;
      } else {
        setState(() {
          title = productDoc.get('name');
          productCat = productDoc.get('category');
          imageUrl = productDoc.get('imageUrl');
          price = productDoc.get('price');
          salePrice = productDoc.get('salePrice');
          unit = productDoc.get('unit');
        });
      }
    } catch (error) {
      showBtmAlert(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            elevation: 10,
            shadowColor: Colors.black,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                //color:  const Color(0xFF1a1f3c),
              ),
              child: Row(
                children: [
                  imageUrl == null
                      ? const Image(
                      image: AssetImage('assets/images/placeholder.png'),width: 100,)
                      : Expanded(child: Image(image: NetworkImage(imageUrl!))),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth*0.45,
                        child: Text(
                          title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: constraints.maxHeight*0.12),
                          maxLines: 2,
                        ),
                      ),
                      salePrice == 0
                          ? Text(
                        '\$$price',
                        style: TextStyle(
                          color: Colors.green.withOpacity(0.9),
                          fontWeight: FontWeight.bold,
                          fontSize: constraints.maxHeight*0.15,
                        ),
                      )
                          : Row(
                        children: [
                          Text(
                            '\$$price',
                            style: TextStyle(
                              color: Colors.red.withOpacity(0.9),
                              fontWeight: FontWeight.bold,
                              fontSize: constraints.maxHeight*0.15,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Text(
                            '\$$salePrice',
                            style: TextStyle(
                                color: Colors.green.withOpacity(0.9),
                                fontWeight: FontWeight.bold,
                                fontSize: constraints.maxHeight*0.15),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  PopupMenuButton(
                      itemBuilder: (context) => [

                        PopupMenuItem(
                          child: InkWell(
                            onTap:(){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductEdit(name: title, price: price, salePrice: salePrice, unit: unit, productCat:productCat, id: widget.id, imageUrl: imageUrl,),),);
                            },
                            child: SizedBox(
                              child: Row(children: const [
                                Text('Edit',style: TextStyle(color: Colors.blue),),
                                Spacer(),
                                Icon(Icons.edit,size: 18,color: Colors.blue)
                              ], ),
                            ),
                          ),
                          value: 1,
                        ),
                        PopupMenuItem(
                            child: Row(
                              children: const [
                                Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                                Spacer(),
                                Icon(Icons.delete_sweep_outlined,size: 18,color: Colors.red,)
                              ],
                            ),
                            value: 2,
                            onTap: () {
                              setState(() {
                                FirebaseFirestore.instance
                                    .collection('products')
                                    .doc(widget.id)
                                    .delete();
                              });
                            }),

                      ])
                ],
              ),
            ),
          ),
        );
      },

    );
  }
}
