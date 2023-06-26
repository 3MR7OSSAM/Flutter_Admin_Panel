import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/models/user_model.dart';
import 'package:grocery_admin_panel/screens/main_screen.dart';
import 'package:grocery_admin_panel/screens/pin_code_screen.dart';
import 'package:hive/hive.dart';
import '../methods/show_error_alert.dart';
import '../responsive.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscureTextForm = true;
  int index=0;
  GlobalKey<FormState> formKey = GlobalKey();
  List<UserModel>? users;
  fetchUsers(){
    var userBox = Hive.box<UserModel>('user_box');
    users = userBox.values.toList();
  }
@override
  void initState() {
    fetchUsers();
    super.initState();
  }
  String? username , password ;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: formKey,
        child: Center(
          child: Material(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            elevation: 10,
            child: SizedBox(
              width: Responsive.isDesktop(context)
                  ? size.width * 0.3
                  : size.width * 0.5,
              height: Responsive.isDesktop(context)
                  ? size.height * 0.60
                  : size.height * 0.45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/main_logo.png',
                    width: size.width * 0.15,
                  ),
                  SizedBox(
                    height: size.width * 0.01,
                  ),

                  CustomTextField(
                    hasIcon: false,
                    onChanged: (data) {
                      username = data.toLowerCase().trim();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'username is required';
                      }else {
                        return null;
                      }
                    },
                    hintText: 'User Name',
                    isNumber: false,
                  ),
                  CustomTextField(
                    hasIcon: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'password is required';
                      }
                      if (value.length < 6) {
                        return 'password should be 6 characters or more';
                      }
                      return null;
                    },
                    obscureText: obscureTextForm,
                    onTap: () {
                      setState(() {
                        obscureTextForm = !obscureTextForm;
                      });
                    },
                    onChanged: (data) {
                     try{
                       password = data.trim();
                     }catch(e){}
                    },
                    hintText: 'Password',
                    isNumber: false,
                  ),
                  TextButton(
                      onPressed: () {
                        if(username != null){
                          try{
                            UserModel user = users!.firstWhere((element) => element.userName == username);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgetPasswordScreen(
                                      pin: user.pinCode,
                                    )));
                          }catch(e){
                            showErrorAlertBar(context , 'user not found');
                          }
                        } else {
                          showErrorAlertBar(context , 'username can\'t be null');
                        }
                      },
                      child: const Text(
                        'Forget Password ?',
                        style: TextStyle(color: Colors.black),
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Background color
                      ),
                      onPressed: () {

                        final form = formKey.currentState;
                        if (form != null && form.validate()) {
                          form.save();
                          bool isUserFound = false;
                          for (UserModel user in users!) {
                            if (user.userName == username && user.password == password) {
                              isUserFound = true;
                              break;
                            }else{
                              index = index + 1;
                            }
                          }
                          if(isUserFound){
                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> const MainScreen()));
                          }else{
                            showErrorAlertBar(context , 'Incorrect username or password');
                          }
                        }
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
