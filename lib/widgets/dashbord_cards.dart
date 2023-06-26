import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';
class DashBordCards extends StatelessWidget {
  const DashBordCards({Key? key, required this.title, required this.value}) : super(key: key);
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    var size = MediaQuery.of(context).size;
    double FontSize = size.width <600 ? 25 :32;
    return  Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        elevation: 10,
        child: SizedBox(
          width:size.width * 0.2,
          height:size.height * 0.10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: Text(title , style: TextStyle(color:color ,fontSize: FontSize , fontWeight: FontWeight.bold))),
              Flexible(child: Text(value , style: TextStyle(color:Colors.green,fontSize: FontSize,fontWeight: FontWeight.bold)))
            ],
          ),
        ),
      ),
    );
  }
}
