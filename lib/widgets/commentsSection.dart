import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:login/widgets/commEl.dart';

import '../authServices/config.dart';

class CommentsPopup extends StatefulWidget {
  // List of comments to display
  final String postid;

  CommentsPopup({required this.postid});

  @override
  State<CommentsPopup> createState() => _CommentsPopupState();
}

class _CommentsPopupState extends State<CommentsPopup> {
  late List<commEl> comments;
  Future<void> getCommentsApi() async {
    var data;
    String url = "${URL}posts/${widget.postid}/comments";
    print("urlis ::" + url);
    final response = await http.get(Uri.parse(url));

    final uresponse = await http
        .get(Uri.parse("https://important-snaps-yak.cyclic.app/users"));
    // print(response.body.toString());
    // print(response.body.length);
    // print(response[0]);
    setState(() {
      
      data = jsonDecode(response.body.toString());
      var udata = jsonDecode(uresponse.body.toString());
      print(data.toString());
      var len = data.length;
      // for(Map i in data){

      // }
      comments = [];
      for (int i = 0; i < len; i++) {
        print("checkis:: " + i.toString());
        comments.add(commEl(
            content: data[i]["content"],
            dtime: data[i]["dt"],
            uname: udata.firstWhere(
              (element) => element["uid"] == data[i]["uid"],
            )["name"],
            upic: udata.firstWhere(
              (element) => element["uid"] == data[i]["uid"],
            )["upic"]));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    comments = [];
    getCommentsApi();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width > 600
        ? 600
        : MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height < 860
        ? 860
        : MediaQuery.of(context).size.height;
    return Dialog(
      backgroundColor: Colors.black45,
      shadowColor: Colors.black45,
      child: Container(
          width: width * 0.95,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
              color: Colors.black.withOpacity(0.6)),
          padding: EdgeInsets.symmetric(
              vertical: height * 0.03, horizontal: width * 0.04),
          // child: ListView.builder(
          //   itemCount: comments.length,
          //   itemBuilder: (context, index) {
          //     final comment = comments[index];
          //     return commEl(content: , dtime:comment.dtime, uname: comment.uname, upic: comment.upic);
          //   },
          // ),
          child: SingleChildScrollView(
            
            child: Column(
              children: [
                Text("COMMENTS",style: GoogleFonts.nunito().copyWith(letterSpacing: 2,fontSize: 16,color: Colors.amberAccent.shade400),),
                Column(
                  children: comments.reversed.toList(),
                ),
              ],
            ),
          )),
    );
  }
}
