import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/providers/dark_theme_provider.dart';
import 'package:grocery_admin_panel/screens/login_screen.dart';
import 'package:grocery_admin_panel/services/utils.dart';
import 'package:grocery_admin_panel/widgets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../inter_screen/all_products.dart';
import '../inter_screen/orders_screen.dart';
import '../screens/main_screen.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color drawerColor = themeState.getDarkTheme ?  const Color(0xFF1a1f3c):Colors.white;
    return Drawer(
      backgroundColor: drawerColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset(
              "assets/images/main_logo.png",
            ),
          ),
          DrawerListTile(
            title: "Main",
            press: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MainScreen(),
                ),
              );
            },
            icon: Icons.home_filled,
          ),
          DrawerListTile(
            title: "View all product",
            press: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const ProductScreen()));
            },
            icon: Icons.store,
          ),
          DrawerListTile(
            title: "View all order",
            press: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const OrderScreen()));
            },
            icon: IconlyBold.bag_2,
          ),
          SwitchListTile(
              title: const Text('Theme'),
              secondary: Icon(themeState.getDarkTheme
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined),
              value: theme,
              onChanged: (value) {
                setState(() {
                  themeState.setDarkTheme = value;
                });
              }),
         SizedBox(height: MediaQuery.of(context).size.height * 0.45,),
          // DrawerListTile(
          //   title: "Settings",
          //   press: () {
          //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> OrderScreen()));
          //   },
          //   icon: IconlyBold.setting,
          // ),
          DrawerListTile(
            title: "Sign out",
            press: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
            },
            icon: IconlyBold.logout,
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.press,
    required this.icon,
  }) : super(key: key);

  final String title;
  final VoidCallback press;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;

    return ListTile(
        onTap: press,
        horizontalTitleGap: 0.0,
        leading: Icon(
          icon,
          size: 18,
        ),
        title: TextWidget(
          text: title,
          color: color,
        ));
  }
}
