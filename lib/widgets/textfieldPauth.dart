import 'package:flutter/material.dart';

class TFpassAuth extends StatefulWidget {
  String hintText;
  TextEditingController controller = new TextEditingController();

  TFpassAuth({required this.controller, required this.hintText});
  @override
  State<TFpassAuth> createState() => _TFpassAuthState();
}

class _TFpassAuthState extends State<TFpassAuth> {
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
      obscureText: !isShowPass,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              isShowPass = !isShowPass;
            });
          },
          child: Icon(
            !isShowPass ? Icons.visibility : Icons.visibility_off_outlined,
            color: Colors.grey,
          ),
        ),
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
