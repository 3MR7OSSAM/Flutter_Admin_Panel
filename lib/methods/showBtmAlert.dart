import 'package:flutter/material.dart';
void showBtmAlert(context , String message){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Material(
          elevation: 0,
          color: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child:  Center(child: Text(message),

            ),
          ),
        ),
      ));
}