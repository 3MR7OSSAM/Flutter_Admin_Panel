import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/inter_screen/orders_screen.dart';
import 'package:grocery_admin_panel/widgets/side_menu.dart';
import 'package:provider/provider.dart';

import '../inter_screen/product_upload.dart';
import '../responsive.dart';
import 'dashboard_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              const Expanded(
                flex: 5,
                child: DashboardScreen(),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
