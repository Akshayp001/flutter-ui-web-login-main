import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:login/authServices/config.dart';
import 'package:login/screens/UserProfile.dart';
import 'package:login/widgets/PostingTF.dart';
import 'package:login/widgets/commEl.dart';
import 'package:login/widgets/snackbar.dart';
import 'package:login/widgets/textfieldNAuth.dart';

import 'commentsSection.dart';

class PostEle extends StatefulWidget {
  final Function updateParentState;
  String uid;
  String pid;
  String uname;
  String postImg;
  String avatrImg;
  String caption;
  String date;
  bool isLiked;
  Uint8List? imgInBytes;

  PostEle(
      {this.imgInBytes,
      required this.updateParentState,
      required this.uid,
      required this.pid,
      required this.avatrImg,
      required this.caption,
      required this.date,
      required this.postImg,
      required this.uname,
      required this.isLiked});

  @override
  State<PostEle> createState() => _PostEleState();
}

class _PostEleState extends State<PostEle> {
  TextEditingController controller = TextEditingController();
  TextEditingController Editcontroller = TextEditingController();
  var crntuser = FirebaseAuth.instance.currentUser!.uid;

  void updateParent() {
    widget.updateParentState();
  }

  Future<void> _likePost() async {
    print("in likr");
    String url = "${URL}" + "posts/addlike/${widget.pid}/${crntuser}";
    var response;

    try {
      response = await http.post(Uri.parse(url));
      print(response);
      setState(() {
        isLiked = true;
        getLikes();
      });
    } catch (e) {}
  }

  Future<void> _unlikePost() async {
    print("in likr");
    String url = "${URL}" + "posts/removelike/${widget.pid}/${crntuser}";
    var response;

    try {
      response = await http.put(Uri.parse(url));
      print(response);
      setState(() {
        isLiked = false;
        getLikes();
      });
    } catch (e) {}
  }

  late List<String> likes;
  Future<void> getLikes() async {
    String url = "${URL}" + "posts/larr/${widget.pid}";

    try {
      final response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body.toString());
      setState(() {
        var len = data.length;
        likes = [];
        for (int i = 0; i < len; i++) {
          likes.add(data[i].toString());
        }
        isLiked = likes.contains(crntuser.toString());
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _editPost() async {
    String url = "${URL}" + "posts/edit/${widget.pid}";
    var regBody = {"caption": "${Editcontroller.text}"};
    try {
      final response = await http.put(Uri.parse(url),
          body: jsonEncode(regBody),
          headers: {"Content-Type": "application/json"});
      print("Edited Successfully");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: CsnackBar(
            snackBarColor: Colors.orange,
            snackBarIcon: Icon(
              Icons.done,
              size: 14,
            ),
            snackBarText: "Post Edited Successfully!!",
          )));
      setState(() {
        isEditEnabled = false;

        updateParent();
        // CaptionText = Editcontroller.text;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _deletePost() async {
    String url = "${URL}" + "posts/delete/${widget.pid}";
    try {
      final response = await http.delete(Uri.parse(url));
      print("Deleted Successfully");
      updateParent();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: CsnackBar(
            snackBarColor: Colors.orange,
            snackBarIcon: Icon(
              Icons.done,
              size: 14,
            ),
            snackBarText: "Post Deleted Successfully!!",
          )));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _postComment() async {
    print("in Comment");
    var regBody = {
      "content": "${controller.text}",
      "dt": "${DateTime.now()}",
      "uid": "${crntuser}"
    };
    String url = "${URL}" + "posts/${widget.pid}/comments";
    var responce;
    try {
      responce = await http.post(Uri.parse(url),
          body: jsonEncode(regBody),
          headers: {"Content-Type": "application/json"}).then((value) {
        setState(() {
          controller.clear();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: CsnackBar(
                snackBarColor: Colors.orange,
                snackBarIcon: Icon(
                  Icons.done,
                  size: 14,
                ),
                snackBarText: "Comment Added!!",
              )));
        });
      });
    } catch (e) {
      print("Erroris" + e.toString());
    }
  }

  List<commEl> comments = [];

  void _showCommentsPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return CommentsPopup(
          postid: widget.pid,
        );
      },
    ).then((value) {});
  }

  late String CaptionText;
  late bool isLiked;
  late bool isEditEnabled;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    comments = [];
    //   commEl(
    //       content:
    //           "this is commnet this is commnet this is commnet this is commnet this is commnet",
    //       dtime: DateTime.now().toString(),
    //       uname: "Akshay",
    //       upic: widget.avatrImg),
    //   commEl(
    //       content:
    //           "this is commnet this is commnet this is commnet this is commnet this is commnet",
    //       dtime: DateTime.now().toString(),
    //       uname: "Akshay",
    //       upic: widget.avatrImg),
    //   commEl(
    //       content:
    //           "this is commnet this is commnet this is commnet this is commnet this is commnet",
    //       dtime: DateTime.now().toString(),
    //       uname: "Akshay",
    //       upic: widget.avatrImg),
    //   commEl(
    //       content:
    //           "this is commnet this is commnet this is commnet this is commnet this is commnet",
    //       dtime: DateTime.now().toString(),
    //       uname: "Akshay",
    //       upic: widget.avatrImg),
    // ];
    likes = [];
    getLikes();
    isLiked = likes.contains(crntuser);
    isEditEnabled = false;
    Editcontroller.text = widget.caption;
    CaptionText = widget.caption;
  }

  @override
  Widget build(BuildContext context) {
    double imgm = MediaQuery.of(context).size.width > 600
        ? 600
        : MediaQuery.of(context).size.width;
    return Container(
      child: SizedBox(
        width: MediaQuery.of(context).size.width > 600
            ? 600
            : MediaQuery.of(context).size.width,
        child: Card(
          color: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2.0,
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfileUI2(userid: widget.uid),
                  )),
                  child: Container(
                    child: Row(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileUI2(userid: widget.uid),
                                ));
                              },
                              child: CircleAvatar(
                                maxRadius: 21,
                                backgroundImage: NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/socialink-20b5d.appspot.com/o/instagram-background-gradient-colors_23-2147821883.avif?alt=media&token=1468dc0c-b28d-4ae8-b38d-be074758fa88'),
                                minRadius: 20.5,
                                child: CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage:
                                      Image.network(widget.avatrImg).image,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  widget.uname,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  widget.date.length > 16
                                      ? widget.date.substring(0, 16)
                                      : widget.date,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        widget.uid == crntuser
                            ? Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isEditEnabled = true;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.lightGreen,
                                        size: imgm * 0.05,
                                      )),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _deletePost();
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: imgm * 0.05,
                                      )),
                                ],
                              )
                            : SizedBox(
                                width: 1,
                              )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  child: isEditEnabled
                      ? Container(
                          child: Column(children: [
                            TFnormAuth(
                                controller: Editcontroller,
                                hintText: "Write Text to Edit"),
                            SizedBox(
                              height: 5,
                            ),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    // Editcontroller.text = CaptionText;
                                    _editPost();
                                    // isEditEnabled = false;
                                  });
                                },
                                child: Text(
                                  "Done",
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: (imgm < 350 ? 350 : imgm) * 0.032,
                                  ),
                                ))
                          ]),
                        )
                      : Text(
                          widget.caption,
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: (imgm < 350 ? 350 : imgm) * 0.032,
                          ),
                        ),
                ),
                SizedBox(height: 16.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  // child: Image.network(
                  //   widget.postImg,
                  //   height: imgm * 0.75,
                  //   width: double.infinity,
                  //   fit: BoxFit.cover,
                  // ),
                  child: widget.postImg != ""
                      ? Center(
                          child: Image.network(
                            widget.postImg,
                          ),
                        )
                      : SizedBox.shrink(),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              splashColor: Colors.red.withOpacity(0.2),
                              iconSize: imgm * 0.05,
                              icon: isLiked
                                  ? Icon(
                                      Icons.favorite,
                                      color: Colors.red.shade900,
                                    )
                                  : Icon(
                                      Icons.favorite_outline_sharp,
                                      color: Colors.white,
                                    ),
                              onPressed: () {
                                setState(() {
                                  if (isLiked) {
                                    
                                    _unlikePost();
                                  } else {
                                   
                                    _likePost();
                                  }
                                });
                              },
                            ),
                            Text(
                              (likes.length - 1).toString(),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              iconSize: imgm * 0.045,
                              icon: Icon(
                                Icons.comment,
                                // color: Colors.teal.shade800,
                                color: Colors.white60,
                              ),
                              onPressed: _showCommentsPopup,
                            ),
                            Text(
                              "Tap",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                            )
                          ],
                        ),
                      ],
                    ),

                    // Container(
                    //   padding:
                    //       EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    //   decoration: BoxDecoration(
                    //       color: Colors.teal.withOpacity(0.4),
                    //       borderRadius: BorderRadius.circular(8)),
                    //   child: TextButton.icon(
                    //     onPressed: () {},
                    //     icon: Icon(Icons.comment),
                    //     label: Text('Comment'),
                    //   ),
                    // ),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Implement share logic
                      },
                      icon: Icon(
                        Icons.share,
                        color: Colors.white54,
                        size: (imgm < 350 ? 350 : imgm) * 0.035,
                      ),
                      label: Text(
                        'Share',
                        style: TextStyle(
                            fontSize: (imgm < 350 ? 350 : imgm) * 0.035,
                            color: Colors.white54),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 4,
                      child: TFposting(
                          controller: controller, hintText: 'Add a comment...'),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      flex: 1,
                      // child: InkWell(
                      //   onTap: () {},
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.teal.shade800,
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //     child: Padding(
                      //         padding: EdgeInsets.symmetric(
                      //             vertical: imgm * 0.02,
                      //             horizontal: imgm * 0.07),
                      //         child: Text("Post")),
                      //   ),
                      // ),
                      child: TextButton(
                          onPressed: _postComment,
                          child: Text(
                            "Post",
                            style: TextStyle(
                                color: Colors.white60,
                                fontSize: (imgm < 350 ? 350 : imgm) * 0.035),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
