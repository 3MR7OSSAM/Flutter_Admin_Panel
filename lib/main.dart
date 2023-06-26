import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_admin_panel/inter_screen/orders_screen.dart';
import 'package:grocery_admin_panel/models/user_model.dart';
import 'package:grocery_admin_panel/screens/login_screen.dart';
import 'package:grocery_admin_panel/screens/main_screen.dart';
import 'package:grocery_admin_panel/screens/register_scrren.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'consts/theme_data.dart';
import 'inter_screen/order_data.dart';
import 'providers/dark_theme_provider.dart';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('user_box');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyC-zk932otC06hgiAwmPNYXsQiznagNsi8',
          appId: '1:941214125824:web:8630133e051eee7cfb2de5',
          messagingSenderId: '941214125824',
          projectId: 'grocery-app-192ae',
          storageBucket: 'grocery-app-192ae.appspot.com'));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    var userBox = Hive.box<UserModel>('user_box');
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: ModalProgressHUD(
                inAsyncCall: true,
                child: Container(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  'An error has been occurred ${snapshot.error}',
                ),
              ),
            ),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) {
                return themeChangeProvider;
              },
            ),

          ],
          child: Consumer<DarkThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Grocery',
                theme: Styles.themeData(themeProvider.getDarkTheme, context),
                home: userBox.isEmpty ? const RegisterScreen():const LoginScreen(),
              );
            },
          ),
        );
      },
    );
  }
}
