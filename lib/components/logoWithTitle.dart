import 'package:flutter/material.dart';

class LogoWithTitle extends StatelessWidget {
  double size;
  Color lcol;
  LogoWithTitle(this.lcol,this.size);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image(image: AssetImage("images/network.png",),),
        Image.network(
          "https://firebasestorage.googleapis.com/v0/b/socialink-20b5d.appspot.com/o/network.png?alt=media&token=76695eef-399f-44f0-9c02-9664b9db2529",
          color: lcol,
          height: size,
          width: size,
          fit: BoxFit.contain,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          "SociaLink",
          style: TextStyle(
              fontSize: size,
              fontFamily: 'MunjaaDemo',
              color: lcol,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
