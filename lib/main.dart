import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login/DB/db.dart';
import 'package:login/DB/dbcreds.dart';
import 'package:login/screens/UserProfile.dart';
import 'package:login/screens/feedScreen.dart';
import 'package:login/screens/loginPage.dart';
import 'package:login/screens/registerPage.dart';
import 'package:login/screens/tweetPost.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyC4CitzJWLTGav0ZW2ErE_MnUe3KDCuU3Q',
          appId: '1:566311134748:web:d5e703c69b49bddaf5a1d9',
          messagingSenderId: '566311134748',
          projectId: 'socialink-20b5d',
          storageBucket: 'gs://socialink-20b5d.appspot.com'));
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      title: 'Flutter Login Web',
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PostWidget();
          } else {
            return Register();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
