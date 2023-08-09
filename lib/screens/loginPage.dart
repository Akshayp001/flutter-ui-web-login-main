import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/components/logoWithTitle.dart';
import 'package:login/screens/UserProfile.dart';
import 'package:login/screens/registerPage.dart';
import 'package:login/widgets/snackbar.dart';
import 'package:login/widgets/textfieldPauth.dart';

import '../widgets/textfieldNAuth.dart';
import 'feedScreen.dart';

class LoginPage extends StatelessWidget {
  late TextEditingController emailController = new TextEditingController();
  late TextEditingController passController = new TextEditingController();

  var _fkey = GlobalKey<FormState>();

  Future signIn() async {
    final isValid = _fkey.currentState!.validate();
    if (!isValid) return;
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim());
  }

  ////
  Widget _formLogin(BuildContext ctx) {
    return Form(
      key: _fkey,
      child: Column(
        children: [
          TFnormAuth(controller: emailController, hintText: 'Enter Email'),
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
                  child: Center(
                      child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ))),
              onPressed: () async {
                print("${emailController.text}\n${passController.text}");
                try {
                  bool eror = false;
                  await signIn().onError((error, stackTrace) {
                    eror = true;
                    return ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        content: CsnackBar(
                          snackBarColor: Colors.orange,
                          snackBarIcon: Icon(Icons.error_outline),
                          snackBarText: error.toString(),
                        )));
                  });
                  // print("ok inside sign in");

                  if (!eror) {
                    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        content: CsnackBar(
                          snackBarColor: Colors.orange,
                          snackBarIcon: Icon(Icons.error_outline),
                          snackBarText: "Logged In Successfully",
                        )));
                  }
                } catch (e) {
                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      content: CsnackBar(
                        snackBarColor: Colors.orange,
                        snackBarIcon: Icon(Icons.error_outline),
                        snackBarText: e.toString(),
                      )));
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
                onPrimary: Colors.orangeAccent,
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
              Text("Not Registered?"),
              SizedBox(
                width: 4,
              ),
              TextButton(
                child: Text(
                  "Register Now!",
                  style: TextStyle(color: Colors.lightBlue.shade700),
                ),
                onPressed: () {
                  Navigator.of(ctx).pushReplacement(MaterialPageRoute(
                    builder: (context) => StreamBuilder(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return PostWidget();
                        } else {
                          return Register();
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
              _loginWithButton(
                  image: 'images/google.png', isActive: true, ctx: ctx),
            ],
          ),
        ],
      ),
    );
  }

  Widget _loginWithButton(
      {String? image, bool isActive = false, required BuildContext ctx}) {
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
        child: InkWell(
          // onTap: () {
          //   // lController.login();
          // },
          onTap: signInwithGoogle,
          child: Image.asset(
            '$image',
            width: 25,
          ),
        ),
      )),
    );
  }

  ////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFf5f5f5),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/bgLog.png',
                ),
                fit: BoxFit.cover)
            // gradient: LinearGradient(
            //     begin: Alignment.centerLeft,
            //     end: Alignment.bottomRight,
            //     colors: [
            //   Colors.pinkAccent.shade100,
            //   Colors.amberAccent.shade100,
            //   Colors.orange.shade200
            // ])
            ),
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
                            Colors.amberAccent.withOpacity(0.5),
                            Colors.orange.withOpacity(0.5)
                          ])),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 30),
                    child: Column(
                      children: [
                        SizedBox(
                          height: (MediaQuery.of(context).size.height) * 0.1,
                        ),
                        Container(
                          child: LogoWithTitle(
                              Color.fromARGB(255, 58, 10, 10), 50),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "USER LOGIN",
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
    );
  }
}

signInwithGoogle() async {
  GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  GoogleSignInAuthentication? googleauth = await googleUser?.authentication;

  AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleauth?.accessToken,
    // idToken: googleauth?.idToken,
  );

  UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
}
