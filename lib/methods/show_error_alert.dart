import 'package:flutter/material.dart';
import 'package:cherry_toast/cherry_toast.dart';

void showErrorAlertBar(context,message){
  CherryToast.error(
    backgroundColor: Theme.of(context).cardColor,
    actionHandler: (){

    },
    action:  Text(message,style: const TextStyle(color: Colors.blue),),
    title: const Text(''),
    enableIconAnimation: false,
    displayTitle: false,
    animationDuration: const Duration(milliseconds: 1000),
    autoDismiss: false,
  ).show(context);
}