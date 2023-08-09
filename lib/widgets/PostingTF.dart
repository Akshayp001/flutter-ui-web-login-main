import 'package:flutter/material.dart';

class TFposting extends StatelessWidget {
  String hintText;

  TextEditingController controller;

  TFposting({required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width > 600
        ? 600
        : MediaQuery.of(context).size.width;
    return TextField(
      maxLines: 20,
      minLines: 1,
      controller: controller,
      style: TextStyle(color: Colors.white60),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
            color: Colors.white70,
            fontSize: (width < 350 ? 350 : width) * 0.028),
        filled: true,
        // fillColor: Colors.blueGrey.shade50,
        fillColor: Colors.transparent,
        labelStyle:
            TextStyle(fontSize: MediaQuery.of(context).size.height * 0.03),
        contentPadding: EdgeInsets.only(left: 30, bottom: 15),
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.white54),
        //   borderRadius: BorderRadius.circular(15),
        // ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orangeAccent.shade200),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
