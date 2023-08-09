import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/Models/postModel.dart';

import '../Models/userModel.dart';
import '../authServices/config.dart';
import '../constants.dart';
import '../widgets/EditprofDets.dart';
import '../widgets/PostELe.dart';

class ProfileUI2 extends StatefulWidget {
  String userid;

  // loginController controller;
  ProfileUI2({required this.userid});

  // String profileUrl;
  // String name;
  // ProfileUI2({required this.name, required this.profileUrl});

  @override
  State<ProfileUI2> createState() => _ProfileUI2State();
}

class _ProfileUI2State extends State<ProfileUI2> {
 

  List<PostEle> posts = [];
    void updateParentState() {
    setState(() {
      getPostApi();
    });
  }
  Future<void> getPostApi() async {
    var data;
    final response = await http
        .get(Uri.parse("$USER_PROFILE_POSTS_API"+widget.userid.toString()));

    final uresponse = await http
        .get(Uri.parse("https://important-snaps-yak.cyclic.app/users"));
    // print(response.body.toString());
    // print(response.body.length);
    // print(response[0]);
    setState(() {
      data = jsonDecode(response.body.toString());
      var udata = jsonDecode(uresponse.body.toString());
      // print(data.length);
      var len = data.length;
      // for(Map i in data){

      // }
      posts = [];
      for (int i = 0; i < len; i++)
        posts.add(PostEle(
          updateParentState: updateParentState,
            pid: data[i]["_id"],
            uid: data[i]["userId"],
            imgInBytes: null,
            isLiked: data[i]["isLiked"],
            avatrImg: udata.firstWhere(
              (element) => element["uid"] == data[i]["userId"],
            )["upic"],
            caption: data[i]["caption"],
            date: data[i]["dt"],
            postImg: data[i]["img"],
            uname: udata.firstWhere(
              (element) => element["uid"] == data[i]["userId"],
            )["name"]));
    });
  }

  late UModel profileCardUserData;
  getUserData() async {
    final response = await http.get(Uri.parse("${URL}users/${widget.userid}"));
    final data = jsonDecode(response.body.toString());
    // final data = datae.firstWhere(
    //   (element) => element["uid"] == widget.userid.toString(),
    // );
    print(data.toString());
    profileCardUserData = UModel(
        dept: data["dept"],
        name: data["name"],
        email: data["email"],
        password: data["password"],
        phn: data["phn"],
        uid: data["uid"],
        upic: data["upic"],
        year: data["year"]);
    print(profileCardUserData.name);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    profileCardUserData = UModel(
        dept: "",
        email: "",
        name: "",
        password: "",
        phn: 0,
        uid: "",
        upic: "",
        year: 0);
    getUserData();
    posts = [];
    getPostApi();
    super.initState();
  }

  String caption =
      'An Instagram caption is a written description or explanation about an Instagram photo to provide more context. Instagram captions can include emojis, hashtags, and tags. Here’s an example of a caption on Instagram';

  String postDate = '23/05/2023';

  String username = 'Akshayp001';

  String url =
      'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=465&q=80';

  @override
  Widget build(BuildContext context) {
    // GoogleSignInAccount? gacc = controller.googleAccount.value;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          flexibleSpace: GestureDetector(
              onTap: () => initState(),
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.bottomRight,
                          colors: [
                    Colors.purple.withOpacity(0.5),
                    Colors.deepPurple.withOpacity(0.5),
                    Colors.lightBlue.withOpacity(0.5)
                  ])))),
          title: Text(
            "PROFILE",
            style: TextStyle(letterSpacing: 1),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/probg.jpg'),
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.white12, BlendMode.lighten))),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                profileCardUserData.upic.toString()),
                            fit: BoxFit.cover)),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 2),
                        ),
                        alignment: Alignment(0.0, 2.5),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              // gacc!.photoUrl.toString()
                              profileCardUserData.upic.toString()),
                          radius: 60.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        // gacc!.displayName.toString(),
                        profileCardUserData.name.toString(),
                        style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.blueGrey.shade300,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w400),
                      ),

                      //details edit button
                      widget.userid == FirebaseAuth.instance.currentUser!.uid
                          ? Container(
                              child: IconButton(
                                icon: Icon(
                                  Icons.mode_edit_outlined,
                                  size: 25,
                                  color: Colors.deepOrange,
                                ),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) {
                                    return profeditDialog(
                                      userData: profileCardUserData,
                                    );
                                  },
                                ).then((value) => Future.delayed(Duration(seconds: 1)).then((value) => initState())),
                              ),
                            )
                          : SizedBox.shrink()
                    ],
                  ),
                  Text(
                    profileCardUserData.uid.toString(),
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white60,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    profileCardUserData.dept.toString(),
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white60,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Card(
                  //     margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  //     elevation: 2.0,
                  //     child: Padding(
                  //         padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  //         child: Text(
                  //           "Skill Sets",
                  //           style: TextStyle(
                  //               letterSpacing: 2.0, fontWeight: FontWeight.w300),
                  //         ))),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  Text(
                    year(profileCardUserData.year),
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white60,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w300),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "Posts",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  posts.length.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "Likes",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "2000",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children:posts.reversed.toList()
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
