import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:samagam_hack/services/user-type-db.dart';

import '../auth.dart';
import '../position_for_stack_in_sign_in_page.dart';
import '../textfield_for_auth_pages.dart';

class SignIn_Page extends StatefulWidget {
 final Function toggleView;
  SignIn_Page({required this.toggleView});

  @override
  _SignIn_PageState createState() => _SignIn_PageState();
}

class _SignIn_PageState extends State<SignIn_Page> {
  int activeIndex = 0;
  String? password;
  String? email;
  String? error_for_email;
  String? error_for_password;
  final AuthService _auth = AuthService();

  late Timer _timer;

  final _formKey = GlobalKey<FormState>();

  void updateEmailFieldValue(String newValue) {
    setState(() {
      email = newValue;
    });
  }

  void updatePasswordFieldValue(String newValue) {
    setState(() {
      password = newValue;
    });
  }



  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          activeIndex++;

          if (activeIndex == 4) activeIndex = 0;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 250,
                  child: Stack(children: [
                    Positioned_for_Auth_Pages(
                      opacity: (activeIndex == 0) ? 1 : 0,
                      image_for_page:
                      'https://ouch-cdn2.icons8.com/As6ct-Fovab32SIyMatjsqIaIjM9Jg1PblII8YAtBtQ/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNTg4/LzNmMDU5Mzc0LTky/OTQtNDk5MC1hZGY2/LTA2YTkyMDZhNWZl/NC5zdmc.png',
                    ),
                    Positioned_for_Auth_Pages(
                        opacity: (activeIndex == 1) ? 1 : 0,
                        image_for_page:
                        'https://ouch-cdn2.icons8.com/vSx9H3yP2D4DgVoaFPbE4HVf6M4Phd-8uRjBZBnl83g/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNC84/MzcwMTY5OS1kYmU1/LTQ1ZmEtYmQ1Ny04/NTFmNTNjMTlkNTcu/c3Zn.png'),
                    Positioned_for_Auth_Pages(
                        opacity: (activeIndex == 2) ? 1 : 0,
                        image_for_page:
                        'https://ouch-cdn2.icons8.com/fv7W4YUUpGVcNhmKcDGZp6pF1-IDEyCjSjtBB8-Kp_0/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvMTUv/ZjUzYTU4NDAtNjBl/Yy00ZWRhLWE1YWIt/ZGM1MWJmYjBiYjI2/LnN2Zw.png'),
                    Positioned_for_Auth_Pages(
                        opacity: activeIndex == 3 ? 1 : 0,
                        image_for_page:
                        'https://ouch-cdn2.icons8.com/AVdOMf5ui4B7JJrNzYULVwT1z8NlGmlRYZTtg1F6z9E/rs:fit:784:767/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvOTY5/L2NlMTY1MWM5LTRl/ZjUtNGRmZi05MjQ3/LWYzNGQ1MzhiOTQ0/Mi5zdmc.png'),
                  ]),
                ),
                SizedBox(
                  height: 40,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextField_for_Auth(
                        labelText: 'Email',
                        hintText: 'Email or Username',
                        iconss: Iconsax.user,
                        onValueChanged: updateEmailFieldValue,
                        validationFunction: (String? val) {
                          if (val==null || val.isEmpty)
                          {
                          return "Enter a valid email";}
                          else
                          {

                            return null;}
                        },
                      ),
                      // Text('$error_for_email'),
                      SizedBox(
                        height: 20,
                      ),
                      TextField_for_Auth(
                        labelText: 'Password',
                        hintText: 'Password',
                        iconss: Iconsax.key,
                        onValueChanged: updatePasswordFieldValue,
                        validationFunction: (String? val) {
                          if (val==null || val.length<6)
                          { return "Password should be of atleast 6 characteres";}
                          else{

                            return null;
                          }

                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),


                      // Text('$error_for_password'),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  onPressed: () {

                    if(_formKey.currentState?.validate()??false) {

                      _auth.loginInWithEmailAndPassword(email!, password!);
                    }

                  },
                  height: 45,
                  color: Colors.black,
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400),
                    ),
                    TextButton(
                      onPressed: () {
                       widget.toggleView();
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
