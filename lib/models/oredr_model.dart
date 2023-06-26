import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
class OrderModel with ChangeNotifier {
  final String productId, orderId, userId, userName, imageUrl,productName ,price,unit;

  final double orderTotal;
  final int quantity;
  final Timestamp orderDate;
  OrderModel({
    required this.productName,
    required this.orderTotal,
    required this.productId,
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.orderDate,
    required this.unit,
  });
}
