import 'package:flutter/material.dart';

class CustomButon extends StatelessWidget {
  CustomButon({Key? key, this.onTap, required this.text, this.icon, this.color}) : super(key: key);
  VoidCallback? onTap;
  final IconData? icon;
  String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    var  size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: color ?? Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          height: 40,
              child :Center(
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon,color: Colors.white,),
                          Text(
                            text,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
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
