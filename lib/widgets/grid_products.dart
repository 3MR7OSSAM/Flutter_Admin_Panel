import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/widgets/product_widget.dart';

import '../responsive.dart';

class ProductGridWidget extends StatelessWidget {
  const ProductGridWidget({
    Key? key, required this.isMain,
  }) : super(key: key);
  final bool isMain;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').orderBy('createdAt',descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(70),
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: isMain ? snapshot.data!.docs.length > 3 ? 3 : snapshot.data!.docs.length : snapshot.data!.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: Responsive.isMobile(context)? 3.2:Responsive.isTablet(context)?2.6 :2.7,
                    crossAxisSpacing: 10,
                    crossAxisCount: Responsive.isDesktop(context)
                        ? 3
                        : Responsive.isTablet(context)
                            ? 2
                            : 1,
                  ),
                  itemBuilder: (context, index) {

                    return ProductWidget(id: snapshot.data!.docs[index]['id'],);
                  });
            } else {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text('Your store is empty'),
                ),
              );
            }
          }
          return const Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          );
        },
      ),
    );
  }
}
