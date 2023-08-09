import 'dart:convert';
import 'dart:js';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/components/logoWithTitle.dart';
import 'package:login/screens/loginPage.dart';
import 'package:login/widgets/textfieldPauth.dart';

import '../authServices/config.dart';
import '../widgets/textfieldEauth.dart';
import '../widgets/textfieldNAuth.dart';
import 'feedScreen.dart';

class Register extends StatelessWidget {
  var fkey = GlobalKey<FormState>();
  late TextEditingController nameController = new TextEditingController();
  late TextEditingController phnNoController = new TextEditingController();
  late TextEditingController emailController = new TextEditingController();
  late TextEditingController passController = new TextEditingController();

  void addUdata(String uid) async {
    var regBody = {
      "name": "${nameController.text}",
      "upic":
          "https://firebasestorage.googleapis.com/v0/b/socialink-20b5d.appspot.com/o/images%2Fpanda.jpeg?alt=media&token=da6d05c5-1536-4f82-b108-a8b8a889274f",
      "dept": "DEFAULT",
      "year": 0,
      "phn": phnNoController.text.toString(),
      "email": emailController.text.trim().toString(),
      "password": passController.text.trim().toString(),
      "uid": "$uid"
    };
    try {
      var response = await http.post(Uri.parse(REGISTERUSERAPI),
          body: jsonEncode(regBody),
          headers: {"Content-Type": "application/json"});

      print("Status :" + response.body.toString());
    } catch (e) {
      print("Erroris" + e.toString());
    }
  }

  bool containsOnlyLetters(String value) {
    final regex = RegExp(r'^[a-zA-Z\s]+$');
    return regex.hasMatch(value);
  }

  Future signup(BuildContext ctx) async {
    final isValid = fkey.currentState!.validate();
    // final isEmailWithPccoe = emailController.text.endsWith("@pccoepune.org");
    // print(isEmailWithPccoe);
    final isOnlyText = containsOnlyLetters(nameController.text);
    if (!isValid) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.white54,
          // content: Text("Only Valid pccoepune.org emails are Accepted!!")));
          content: Text("Only Valid Emails are Accepted!!")));
      return;
    }
    if (!isOnlyText) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.white54,
          content: Text("Name Should Not Contain Digits..")));
      return;
    }

    if (nameController.text == '' || phnNoController.text == '') return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passController.text.trim());
      addUdata(FirebaseAuth.instance.currentUser!.uid.toString());
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.white54,
          content: Text("Account Created Successfully")));
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.white54,
          content: Text(e.toString())));
    }
  }

  ////
  Widget _formLogin(BuildContext ctx) {
    return Form(
      key: fkey,
      child: Column(
        children: [
          TFnormAuth(controller: nameController, hintText: 'Enter full name'),
          SizedBox(height: 15),
          TFnormAuth(controller: phnNoController, hintText: "Enter Mobile No."),
          SizedBox(height: 15),
          TFemailAuth(controller: emailController, hintText: 'Enter email'),
          SizedBox(height: 15),
          TFpassAuth(
            controller: passController,
            hintText: 'Enter Password',
          ),
          SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.shade100,
                  spreadRadius: 10,
                  blurRadius: 20,
                ),
              ],
            ),
            child: ElevatedButton(
              child: Container(
                  width: double.infinity,
                  height: 50,
                  child: Center(child: Text("REGISTER"))),
              onPressed: () => signup(ctx),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already Registered?"),
              SizedBox(
                width: 4,
              ),
              TextButton(
                child: Text(
                  "Login Now!",
                  style: TextStyle(color: Color.fromRGBO(2, 136, 209, 1)),
                ),
                onPressed: () {
                  Navigator.of(ctx).pushReplacement(MaterialPageRoute(
                    builder: (context) => StreamBuilder(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return PostWidget();
                        } else {
                          return LoginPage();
                        }
                      },
                    ),
                  ));
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(children: [
            Expanded(
              child: Divider(
                color: Colors.grey.shade300,
                height: 50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("Or continue with"),
            ),
            Expanded(
              child: Divider(
                color: Colors.grey.shade400,
                height: 50,
              ),
            ),
          ]),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _loginWithButton(image: 'images/google.png', isActive: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _loginWithButton({String? image, bool isActive = false}) {
    return Container(
      width: 60,
      height: 40,
      decoration: isActive
          ? BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  spreadRadius: 10,
                  blurRadius: 30,
                )
              ],
              borderRadius: BorderRadius.circular(15),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade400),
            ),
      child: Center(
          child: Container(
        decoration: isActive
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    spreadRadius: 2,
                    blurRadius: 15,
                  )
                ],
              )
            : BoxDecoration(),
        child: Image.asset(
          '$image',
          width: 25,
        ),
      )),
    );
  }

  // var user = FirebaseAuth.instance.currentUser;

  ////
  @override
  Widget build(BuildContext context) {
    // print(user!.email.toString());
    // print(user!.uid.toString());

    return Scaffold(
      // backgroundColor: Color(0xFFf5f5f5),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                // colorFilter: ColorFilter.linearToSrgbGamma(),
                image: AssetImage(
                  'assets/images/bgLog.png',
                ),
                fit: BoxFit.cover)),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.pinkAccent.withOpacity(0.5),
                                Colors.yellowAccent.withOpacity(0.5),
                                Colors.red.withOpacity(0.5)
                              ])),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 30),
                        child: Column(
                          children: [
                            SizedBox(
                              height:
                                  (MediaQuery.of(context).size.height) * 0.1,
                            ),
                            Container(
                                child: LogoWithTitle(
                                    Color.fromARGB(255, 58, 10, 10), 50)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "USER REGISTRATION",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 15),
                            Container(
                              width: 320,
                              child: _formLogin(context),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
