import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:login/screens/feedScreen.dart';

class loadscreen extends StatelessWidget {
  const loadscreen({super.key});

  @override

  Widget build(BuildContext context) {
    // Timer(
    //         Duration(seconds: 3),
    //             () =>
    //         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PostWidget(),)));
    return Scaffold(
      body: Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/bgLog.png"),fit: BoxFit.cover)), child: Center(child: CircularProgressIndicator(color: Colors.red,))),
    );
  }
}