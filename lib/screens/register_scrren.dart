import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/screens/main_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../methods/show_error_alert.dart';
import '../models/user_model.dart';
import '../responsive.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool obscureTextForm = true;
  bool obscurePin = true;
  GlobalKey<FormState> formKey = GlobalKey();
  String? username , password ;
  int? pinCode;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double responsiveFont = size.width < 600 ? 24 : 28;

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
                    width: size.width * 0.12,
                  ),
                  SizedBox(
                    height: size.width * 0.01,
                  ),
                  Text(
                    'Create Account',
                    style: TextStyle(
                        fontSize: responsiveFont,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  CustomTextField(
                    hasIcon: false,
                    onChanged: (data) {
                      username = data.trim();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'username is required';
                      }else{
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
                       password = data.toLowerCase().trim();
                     }catch(e) {}
                    },
                    hintText: 'Password',
                    isNumber: false,
                  ),
                  CustomTextField(
                    hasIcon: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'pin code is required';
                      }
                      if (value.length < 6) {
                        return 'pin code should be at 6 numbers long';
                      }
                      return null;
                    },
                    obscureText: obscurePin,
                    onTap: () {
                      setState(() {
                        obscurePin = !obscurePin;
                      });
                    },
                    onChanged: (data) {
                     try{
                       pinCode = int.parse(data.trim());
                     }catch(e) {}
                    },
                    hintText: 'pin code',
                    isNumber: true,
                  ),
                  ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Background color
                      ),
                      onPressed: () async{
                        final form = formKey.currentState;
                        if (form != null && form.validate()) {
                          form.save();
                          try{
                            var userBox = Hive.box<UserModel>('user_box');
                            await userBox.add(UserModel(userName: username!, password: password!, pinCode: pinCode!));
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const MainScreen()));
                          }catch(e){
                            showErrorAlertBar(context , e.toString());
                          }
                        }
                      },
                      child: const Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Register',
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
