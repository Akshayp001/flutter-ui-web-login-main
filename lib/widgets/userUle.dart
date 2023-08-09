import 'package:login/screens/UserProfile.dart';
import 'package:flutter/material.dart';

class UEL extends StatelessWidget {
  String upic;
  String uname;
  String uid;

  UEL({required this.uid, required this.uname, required this.upic});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width > 600
        ? 600
        : MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height < 860
        ? 860
        : MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return ProfileUI2(userid: uid);
        },
      )),
      child: Container(
        // height: height*0.1,
        width: width * 0.9,
        padding: EdgeInsets.symmetric(
            vertical: height * 0.015, horizontal: width * 0.04),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: (width < 350 ? 350 : width) * 0.027,
                backgroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/socialink-20b5d.appspot.com/o/instagram-background-gradient-colors_23-2147821883.avif?alt=media&token=1468dc0c-b28d-4ae8-b38d-be074758fa88'),
                child: CircleAvatar(
                  radius: (width < 350 ? 350 : width) * 0.025,
                  backgroundImage: Image.network(upic).image,
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    uname,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                ],
              ),
            ],
          ),
        ]),
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
      ),
    );
  }
}
