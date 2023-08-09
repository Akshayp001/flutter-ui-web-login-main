import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TFnormAuth extends StatelessWidget {
  String hintText;
  TextEditingController controller;

  TFnormAuth({required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    var maxlen=0;
    if (hintText == "Enter Mobile No.") {
      maxlen = 10;
    }
    return maxlen==10?TextField(
      maxLength: 10,
      controller: controller,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.blueGrey.shade50,
        labelStyle: TextStyle(fontSize: 12),
        contentPadding: EdgeInsets.only(left: 30),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orangeAccent.shade200),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ):TextField(
      // maxLength: maxlen==0?30:maxlen,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.blueGrey.shade50,
        labelStyle: TextStyle(fontSize: 12),
        contentPadding: EdgeInsets.only(left: 30),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orangeAccent.shade200),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
