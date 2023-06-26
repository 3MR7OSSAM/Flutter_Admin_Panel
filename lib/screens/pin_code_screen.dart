import 'dart:async';
import 'package:flutter/material.dart';
import '../methods/show_error_alert.dart';
import 'package:universal_html/html.dart' as html;
import '../responsive.dart';
import '../widgets/custom_text_field.dart';
import 'main_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({Key? key, required this.pin}) : super(key: key);
  final int pin;
  @override
  State<ForgetPasswordScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ForgetPasswordScreen> {
  bool obscureTextForm = true;
  GlobalKey<FormState> formKey = GlobalKey();
  int? pinCode;
  int maxAttempts = 3;
  int currentAttempt = 0;
  bool isTimerActive = false;
  bool? enabled;
  int remainingTime = 0;
  Timer? timer;


  @override
  void initState() {
    super.initState();
    _loadAttempts();
  }

  void _loadAttempts() {
    final attempts = html.window.localStorage['attempts'];
    if (attempts != null) {
      setState(() {
        currentAttempt = int.parse(attempts);
      });
    }
  }

  void _saveAttempts() {
    html.window.localStorage['attempts'] = currentAttempt.toString();
  }

  void _startTimer() {
    isTimerActive = true;
    enabled = false ;
    remainingTime = 30;
    showErrorAlertBar(context, 'Incorrect pin. You can try again after 30 seconds.');
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime--;
        if (remainingTime <= 0) {
          isTimerActive = false;
          enabled = true ;
          timer.cancel();
        }
      });
    });
  }
  void _resetTimer() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
    setState(() {
      isTimerActive = false;
      enabled = true ;
      maxAttempts = 3;
      remainingTime = 0;
    });
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double FontSize = size.width < 600 ? 24 : 28;

    return Scaffold(
      body: Form(
        key: formKey,
        child: Center(
          child: Material(
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
                    'Forget Password',
                    style: TextStyle(
                        fontSize: FontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const Text(
                    'Enter 6 digits pin',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        decoration: TextDecoration.underline),
                  ),
                  CustomTextField(
                    isEnabled : enabled,
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
                    obscureText: obscureTextForm,
                    onTap: () {
                      setState(() {
                        obscureTextForm = !obscureTextForm;
                      });
                    },
                    onChanged: (data) {
                      try {
                        pinCode= int.parse(data.trim());
                      }catch (e){}
                    },
                    hintText: 'pin code',
                    isNumber: true,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'the 6 digit pin you entered while creating the admin account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.width * 0.01,
                  ),

                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Background color
                      ),
                      onPressed: () {
                        if (isTimerActive) {
                        } else {
                          final form = formKey.currentState;
                          if (form != null && form.validate()) {
                            form.save();
                            if (pinCode == widget.pin) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainScreen(),
                                ),
                              );
                            } else {
                              currentAttempt++;
                              _saveAttempts(); // Save the current attempts
                              if (currentAttempt >= maxAttempts) {
                                _resetTimer();
                                _startTimer();
                              } else {
                                showErrorAlertBar(context, 'Wrong pin. ');
                              }
                            }
                          }
                        }
                      },
                      child: const Padding(
                          padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Continue',
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
