import 'package:flutter/material.dart';

class TFemailAuth extends StatefulWidget {
  String hintText;
  TextEditingController controller = new TextEditingController();

  TFemailAuth({required this.controller, required this.hintText});
  @override
  State<TFemailAuth> createState() => _TFemailAuthState();
}

class _TFemailAuthState extends State<TFemailAuth> {
  late bool isShowPass;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isShowPass = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) => value!=null && value.length<6?'Min 6 characters req..':null,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
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
