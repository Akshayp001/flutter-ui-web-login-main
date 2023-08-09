import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:io';
// import 'package:firebase/firebase.dart' as fb;

import 'package:login/widgets/userUle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:login/DB/db.dart';
import 'package:login/Models/modelPost.dart';
import 'package:login/Models/postModel.dart';
import 'package:login/Models/userModel.dart';
import 'package:login/authServices/config.dart';
import 'package:login/components/logoWithTitle.dart';
import 'package:login/constants.dart';
import 'package:login/screens/UserProfile.dart';
import 'package:login/screens/loadscreen.dart';
import 'package:login/widgets/PostingTF.dart';
import 'package:login/widgets/commEl.dart';
import 'package:login/widgets/expandWidget.dart';
import 'package:login/widgets/textfieldNAuth.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import '../widgets/PostELe.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

import '../widgets/snackbar.dart';
import '../widgets/temp.dart';

// void main() {
//   String url =
//       'https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png';
//   runApp(MaterialApp(
//     home: PostWidget(
//       avatarImage: url,
//       caption: "Hello",
//       postDate: "03-05-2003",
//       postImage: url,
//       username: "Aks001",
//     ),
//   ));
// }

class PostWidget extends StatefulWidget {
  // final String username;
  // final String avatarImage;
  // final String postDate;
  // final String caption;
  // final String postImage;

  // PostWidget({
  //   required this.username,
  //   required this.avatarImage,
  //   required this.postDate,
  //   required this.caption,
  //   required this.postImage,
  // });

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> with WidgetsBindingObserver {
  var user = FirebaseAuth.instance.currentUser;
  late List<PostEle> posts;
  late List<UEL> users;
  late TextEditingController tc;

  late String imgUrl;
  var imgfile;

  late bool fun1;
  late bool fun3;
  late bool fun2;

  // Filters dropdown valurs declaration
  late String filtDeptDDval;
  late String filtyearDDval;

  late String durl;

  Future<String> getDownloadUrl(UploadTask task) async {
    final snapshot = await task.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Timer? _timer;
  void startTimer() {
    const duration = Duration(seconds: 5);
    _timer = Timer(duration, () {
      setState(() {
        getUserData();
      });
    });
  }

  void updateProfileCardUserData(dynamic data) {
    setState(() {
      profileCardUserData = UModel(
        dept: data["dept"],
        name: data["name"],
        email: data["email"],
        password: data["password"],
        phn: data["phn"],
        uid: data["uid"],
        upic: data["upic"],
        year: data["year"],
      );
    });
  }

  Future<void> getUserData() async {
    var uidur = FirebaseAuth.instance.currentUser!.uid;
    // print("uid : " + uidur);
    final response;
    response = await http
        .get(Uri.parse("https://important-snaps-yak.cyclic.app/users/${uidur}"))
        .then((value) {
      final data = jsonDecode(value.body.toString());
      updateProfileCardUserData(data);
    });
    // print(response.body.toString());
    // final data = jsonDecode(response.body.toString());
    // final data = datae.firstWhere(
    //   (element) => element["uid"] == RegisteredUser!.uid.toString(),
    // );
    // print(data.toString());
    // profileCardUserData = UModel(
    //     dept: data["dept"],
    //     name: data["name"],
    //     email: data["email"],
    //     password: data["password"],
    //     phn: data["phn"],
    //     uid: data["uid"],
    //     upic: data["upic"],
    //     year: data["year"]);
    // print(profileCardUserData.name);
    // setState(() {});
    // print(RegisteredUser!.email.toString());
  }

  void updateParentState() {
    setState(() {
      getPostApi();
    });
  }

  Future<void> _uploadImage() async {
    // Get the image file

    // Upload the image to Firebase Storage
    if (selectedImageInBytes != null) {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // final Reference storageRef = storage.ref().child('images/$fileName');
      final Reference storageRef = storage.ref();
      // final metadata = storage.SettableMetadata(contentType: 'image/jpeg');
      final UploadTask uploadTask = storageRef
          .child('images/$fileName')
          .putData(selectedImageInBytes,
              SettableMetadata(contentType: 'image/jpeg'));

      // Monitor the upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print(
            'Upload progress: ${snapshot.bytesTransferred / snapshot.totalBytes * 100}%');
      }, onError: (Object e) {
        print('Error during image upload: $e');
      });

      // Wait until the upload is complete
      try {
        await uploadTask;
        print('Image uploaded successfully!');
        final downloadUrl = await getDownloadUrl(uploadTask);
        durl = downloadUrl;
        setState(() {
          durl = downloadUrl;
        });
        print(downloadUrl);
        // print(uploadTask);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  late Uint8List selectedImageInBytes;
  late bool isImgSelected2;
  late bool isImgSelected;
  String selctFile = '';

  Future<void> getPostApi() async {
    var data;

    int y;
    if (filtyearDDval == "FY") {
      y = 1;
    } else if (filtyearDDval == "SY") {
      y = 2;
    } else if (filtyearDDval == "TY") {
      y = 3;
    } else if (filtyearDDval == "BE") {
      y = 4;
    } else {
      y = 1;
    }

    var uri;

    if (filtDeptDDval == "DEFAULT" && filtyearDDval == "NA") {
      uri = 'https://important-snaps-yak.cyclic.app/posts';
    } else if (filtDeptDDval == "DEFAULT") {
      uri = 'https://important-snaps-yak.cyclic.app/fyposts/${y}';
    } else if (filtyearDDval == "NA") {
      uri = 'https://important-snaps-yak.cyclic.app/fdposts/${filtDeptDDval}';
    } else {
      uri =
          'https://important-snaps-yak.cyclic.app/fdyposts/${filtDeptDDval}/${y}';
    }
    final response = await http.get(Uri.parse("$uri"));

    final uresponse = await http
        .get(Uri.parse("https://important-snaps-yak.cyclic.app/users"));
    setState(() {
      data = jsonDecode(response.body.toString());
      var udata = jsonDecode(uresponse.body.toString());
      // print(data.length);
      var len = data.length;
      var ulen = udata.length;
      // for(Map i in data){

      // }
      posts = [];
      users = [];

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
      for (int i = 0; i < ulen; i++)
        users.add(UEL(
          uname: udata[i]["name"],
          uid: udata[i]["uid"],
          upic: udata[i]["upic"],
        ));
    });
  }

  var RegisteredUser = FirebaseAuth.instance.currentUser;
  late UModel profileCardUserData;
  // late bool imagecheck;
  // late bool capcheck;
  void _selectFile() async {
    // setState(() {
    //   imagecheck = false;
    // });

    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    selctFile = result!.files.first.name;
    if (result != null) {
      isImgSelected = true;
      isImgSelected2 = true;
      setState(() {});
      selectedImageInBytes = result.files.first.bytes!;
      imgfile = result.files.first;
    }
    print('FIle name:' + selctFile);
  }

  // void sendData() async {
  //   var regBody = {
  //     "name": "${tc.text}",
  //     "age": "1002",
  //     "img": selectedImageInBytes,
  //   };
  //   _uploadImage();

  //   var response = await http.post(Uri.parse(registerUserapi),
  //       body: jsonEncode(regBody),
  //       headers: {"Content-Type": "application/json"});
  //   print("Error is :" + response.statusCode.toString());
  // }

  void postData() async {
    if (isImgSelected2) {
      await _uploadImage();
    }
    if (isImgSelected2 == true || tc.text != "") {
      print("Seding dtaa.............");
      print(durl);
      var str = tc.text;
      var regBody = {
        "caption": str,
        "lcnt": "0",
        "img": "${durl}",
        "isLiked": false,
        "dt": DateTime.now().toString(),
        "userId": RegisteredUser!.uid.toString()
      };
      try {
        var response = await http.post(Uri.parse(POSTDATAAPI),
            body: jsonEncode(regBody),
            headers: {"Content-Type": "application/json"});
        durl = '';
        tc.clear();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: CsnackBar(
              snackBarColor: Colors.orange,
              snackBarIcon: Icon(
                Icons.done,
                size: 14,
              ),
              snackBarText: "Post Added!!",
            )));
        print("Error is :" + response.statusCode.toString());
        setState(() {
          isImgSelected = false;
          // isImgSelected = false;
        });
        getPostApi();
        print("Error :" + response.body.toString());
      } catch (e) {
        print("Erroris" + e.toString());
      }
      // print("Error is :" + response.statusCode.toString());
    }
  }

  late bool loaded;
  late bool filtersWidExp;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // When the app is resumed, check if data has been fetched
      if (profileCardUserData.email == "") {
        print("Tried 1");
        getUserData();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isImgSelected = false;
    isImgSelected2 = false;
    // posts = [
    //   PostEle(
    //       imgInBytes: null,
    //       isLiked: false,
    //       avatrImg: widget.avatarImage,
    //       caption: widget.caption,
    //       date: widget.postDate,
    //       postImg: widget.postImage,
    //       uname: widget.username),
    //   PostEle(
    //       imgInBytes: null,
    //       isLiked: false,
    //       avatrImg: widget.avatarImage,
    //       caption: widget.caption,
    //       date: widget.postDate,
    //       postImg: widget.postImage,
    //       uname: widget.username),
    //   PostEle(
    //       imgInBytes: null,
    //       isLiked: false,
    //       avatrImg: widget.avatarImage,
    //       caption: widget.caption,
    //       date: widget.postDate,
    //       postImg: widget.postImage,
    //       uname: widget.username),
    // ];
    tc = new TextEditingController();
    // getPosts = post();
    fun1 = false;
    fun2 = false;
    fun3 = false;

    //inititallisation of filter values

    filtDeptDDval = "DEFAULT";
    filtyearDDval = "NA";
    durl = '';
    posts = [];
    users = [];
    getPostApi();
    profileCardUserData = UModel(
        dept: "",
        email: "",
        name: "",
        password: "",
        phn: 0,
        uid: "",
        upic: "",
        year: 0);
    WidgetsBinding.instance.addObserver(this);
    getUserData();
    filtersWidExp = false;
    startTimer();
    // imagecheck = true;
    // capCheck = true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width > 600
        ? 600
        : MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height < 860
        ? 860
        : MediaQuery.of(context).size.height;
    // Timer(
    //     Duration(seconds: 3),
    //     () => setState(() {
    //           loaded = true;
    //         }));
    // if (profileCardUserData.name == "") {
    //   print("not fetched");
    //   setState(() {});
    // } else {
    print("Fetched Name : " + profileCardUserData.name);
    // }
    // FutureBuilder(future: Timer.periodic(Duration(seconds: 2), (timer) { }),);
    return Scaffold(
      // body: !loaded? loadscreen():
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(232, 0, 0, 0),
            Color.fromARGB(255, 20, 4, 41),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card

            MediaQuery.of(context).size.width > 1100
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.01, horizontal: width * 0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return ProfileUI2(
                                  userid: profileCardUserData.uid);
                            },
                          )),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: height * 0.03,
                                horizontal: width * 0.04),
                            height: height * 0.42,
                            width:
                                ((MediaQuery.of(context).size.width - width) /
                                    2.5),
                            child: SingleChildScrollView(
                              child: profileCardUserData.name == ""
                                  ? Center(child: CircularProgressIndicator())
                                  : Column(
                                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                          CircleAvatar(
                                            // backgroundColor: Colors.deepPurpleAccent,
                                            backgroundImage: NetworkImage(
                                                'https://firebasestorage.googleapis.com/v0/b/socialink-20b5d.appspot.com/o/instagram-background-gradient-colors_23-2147821883.avif?alt=media&token=1468dc0c-b28d-4ae8-b38d-be074758fa88'),

                                            maxRadius: ((MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        width) /
                                                    2.2) *
                                                0.21,
                                            minRadius: ((MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        width) /
                                                    2.2) *
                                                0.11,
                                            child: CircleAvatar(
                                              maxRadius:
                                                  ((MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              width) /
                                                          2.2) *
                                                      0.2,
                                              minRadius:
                                                  ((MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              width) /
                                                          2.2) *
                                                      0.1,
                                              backgroundImage: NetworkImage(
                                                  profileCardUserData.upic),
                                              // foregroundImage: NetworkImage(url),
                                            ),
                                          ),
                                          SizedBox(
                                            height: height * 0.02,
                                          ),
                                          Text(
                                            profileCardUserData.name.toString(),
                                            style: TextStyle(
                                                fontSize: (width < 350
                                                        ? 350
                                                        : width) *
                                                    0.035,
                                                color: Colors.white54),
                                          ),
                                          Text(
                                            "@${profileCardUserData.uid}",
                                            style: TextStyle(
                                                fontSize: (width < 350
                                                        ? 350
                                                        : width) *
                                                    0.02,
                                                color: Colors.white38),
                                          ),
                                          Text(
                                            profileCardUserData.dept.toString(),
                                            style: TextStyle(
                                                fontSize: (width < 350
                                                        ? 350
                                                        : width) *
                                                    0.038,
                                                color: Colors.white54),
                                          ),
                                          Text(
                                            year(profileCardUserData.year)
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: (width < 350
                                                        ? 350
                                                        : width) *
                                                    0.025,
                                                color: Colors.white38),
                                          ),
                                        ]),
                            ),
                            // color: Colors.red.withOpacity(0.5),
                            decoration: BoxDecoration(
                                // color: Colors.black87,
                                boxShadow: [
                                  BoxShadow(
                                    // color: Color.fromARGB(255, 74, 5, 5),
                                    blurRadius: 10.0, // soften the shadow
                                    spreadRadius: 2.0, //extend the shadow
                                    offset: Offset(
                                      2.0, // Move to right 5  horizontally
                                      2.0, // Move to bottom 5 Vertically
                                    ),
                                  )
                                ],
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.lightGreen.shade100
                                          .withOpacity(0.2),
                                      Colors.teal.shade100.withOpacity(0.2)
                                    ]),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        )
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    width: width * 0.93,
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LogoWithTitle(Color.fromARGB(255, 63, 73, 33), 30),
                          IconButton(
                            icon: Icon(Icons.restart_alt,
                                size: (width < 350 ? 350 : width) * 0.05),
                            color: Colors.grey.shade300,
                            onPressed: () {
                              // fetchData();
                              getPostApi();
                              // getUserData();
                              setState(() {});
                            },
                          ),
                          GestureDetector(
                            child: Icon(Icons.power_settings_new,
                                color: Colors.red,
                                size: (width < 350 ? 350 : width) * 0.055),
                            onTap: () => FirebaseAuth.instance.signOut(),
                          ),
                          //

                          GestureDetector(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return ProfileUI2(
                                    userid: profileCardUserData.uid);
                              },
                            )),
                            child: CircleAvatar(
                              // backgroundColor: Colors.deepPurpleAccent,
                              maxRadius: (width < 350 ? 350 : width) * 0.0325,
                              backgroundImage: NetworkImage(
                                  'https://firebasestorage.googleapis.com/v0/b/socialink-20b5d.appspot.com/o/instagram-background-gradient-colors_23-2147821883.avif?alt=media&token=1468dc0c-b28d-4ae8-b38d-be074758fa88'),

                              minRadius: (width < 350 ? 350 : width) * 0.0285,
                              child: CircleAvatar(
                                maxRadius: (width < 350 ? 350 : width) * 0.030,

                                minRadius: (width < 350 ? 350 : width) * 0.026,
                                backgroundImage:
                                    NetworkImage(profileCardUserData.upic),
                                // foregroundImage: NetworkImage(url),
                              ),
                            ),
                          ),
                        ]),
                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  //posts feeds section

                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.bounceInOut,
                    child: Container(
                      // height: MediaQuery.of(context).size.height * 0.25,
                      width: width * 0.92,
                      height: isImgSelected ? (height * 0.40) : (height * 0.22),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 14),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 6),
                          child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "What's on your Mind ?",
                                    style: TextStyle(
                                      fontSize:
                                          (width < 350 ? 350 : width) * 0.035,
                                      color: Colors.white60,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TFposting(
                                      controller: tc,
                                      hintText: 'Type Something.....'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: _selectFile,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade100
                                                .withOpacity(0.4),
                                            border: Border.all(
                                                color: Colors.orange),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsets.all(width * 0.015),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.image,
                                                  size: (width < 350
                                                          ? 350
                                                          : width) *
                                                      0.035,
                                                ),
                                                Text(
                                                  "Add Image",
                                                  style: TextStyle(
                                                      fontSize: (width < 350
                                                              ? 350
                                                              : width) *
                                                          0.03),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      //post button

                                      InkWell(
                                        onTap: () {
                                          // print(tc.text);
                                          setState(() {
                                            // isImgSelected = false;
                                            selctFile = '';
                                            // posts.add(PostEle(
                                            //     imgInBytes:
                                            //         selectedImageInBytes,
                                            //     isLiked: false,
                                            //     avatrImg: widget.avatarImage,
                                            //     caption: tc.text,
                                            //     date: DateTime.now().toString(),
                                            //     postImg: widget.postImage,
                                            //     uname: widget.username));
                                            // _insertData(tc.text);
                                            // print("img : " +
                                            //     selectedImageInBytes.toString());
                                            postData();
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.4),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: width * 0.018,
                                                  horizontal: width * 0.036),
                                              child: Text(
                                                "Post",
                                                style: TextStyle(
                                                    fontSize: (width < 350
                                                            ? 350
                                                            : width) *
                                                        0.03,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  isImgSelected
                                      ? Image.memory(
                                          selectedImageInBytes,
                                          height: height * 0.15,
                                          width: height * 0.15,
                                          fit: BoxFit.contain,
                                        )
                                      : SizedBox.shrink(),
                                ]),
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.black87,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 74, 5, 5),
                              blurRadius: 10.0, // soften the shadow
                              spreadRadius: 2.0, //extend the shadow
                              offset: Offset(
                                2.0, // Move to right 5  horizontally
                                2.0, // Move to bottom 5 Vertically
                              ),
                            )
                          ],
                          // gradient: LinearGradient(
                          //     begin: Alignment.centerLeft,
                          //     end: Alignment.bottomRight,
                          //     colors: [
                          //       Colors.lightGreen.shade100,
                          //       Colors.teal.shade100
                          //     ]),
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  //filters section

                  AnimatedContainer(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 18),
                    duration: Duration(milliseconds: 50),
                    // height: filtersWidExp ? height * 0.2 : height * 0.05,
                    width: width * 0.9,
                    decoration: filtersWidExp
                        ? BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white38))
                        : BoxDecoration(
                            color: Colors.transparent,
                          ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: filtersWidExp
                            ? MainAxisAlignment.spaceEvenly
                            : MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        filtersWidExp = !filtersWidExp;
                                      });
                                    },
                                    child: Text(
                                      "Filters",
                                      style: GoogleFonts.rubik().copyWith(
                                          color: Colors.white60,
                                          fontSize:
                                              (width < 350 ? 350 : width) *
                                                  0.030),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.05,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        filtDeptDDval = "DEFAULT";
                                        filtyearDDval = "NA";
                                        getPostApi();
                                      });
                                    },
                                    child: Text(
                                      "Reset",
                                      style: GoogleFonts.rubik().copyWith(
                                          color: Colors.lightBlue.shade300,
                                          fontSize:
                                              (width < 350 ? 350 : width) *
                                                  0.030),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          !filtersWidExp
                              ? SizedBox.shrink()
                              : Container(
                                  width: width * 0.85,
                                  // height: height * 0.1 ,
                                  color: Colors.black,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: height * 0.035,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1, horizontal: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                  color: Colors.orange),
                                            ),
                                            child: DropdownButton<String>(
                                              dropdownColor: Colors.orange
                                                  .withOpacity(0.3),

                                              // isExpanded: true,
                                              value: filtDeptDDval,

                                              icon: Icon(Icons.arrow_drop_down),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              style: TextStyle(
                                                  color: Colors.white60),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  filtDeptDDval = newValue!;
                                                });
                                              },
                                              items: <String>[
                                                'COMP',
                                                'ENTC',
                                                'MECH',
                                                'CIVIL',
                                                'IT',
                                                'DEFAULT'
                                              ]
                                                  .map<
                                                      DropdownMenuItem<String>>(
                                                    (String value) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                      value: value,
                                                      child: Text(value),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1, horizontal: 6),
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border.all(
                                                    color: Colors.orange),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: DropdownButton<String>(
                                              // isExpanded: true,r
                                              value: filtyearDDval,
                                              style: TextStyle(
                                                  color: Colors.white60),
                                              dropdownColor: Colors.orange
                                                  .withOpacity(0.3),
                                              icon: Icon(Icons.arrow_drop_down),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  filtyearDDval = newValue!;
                                                });
                                              },
                                              items: <String>[
                                                'FY',
                                                'SY',
                                                'TY',
                                                'BE',
                                                'NA'
                                              ]
                                                  .map<
                                                      DropdownMenuItem<String>>(
                                                    (String value) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                      value: value,
                                                      child: Text(value),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height * 0.025,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            getPostApi();
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.black38,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          'Apply',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                  // commEl(content: "this is commnet", dtime: DateTime.now().toString(), uname: "Akshay", upic: posts[0].avatrImg.toString()),
                  Column(
                    children: posts.reversed.toList(),
                  ),
                ],
              ),
            ),

            // pending Implementation box
            MediaQuery.of(context).size.width > 1100
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.01, horizontal: width * 0.04),
                    child: Container(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                fun1 = !fun1;
                              });
                            },
                            child: ExpWidget(
                              title: 'Filters',
                              fun: fun1,
                              content: [
                                Text(
                                  "Filters is Below Post Section",
                                  style: TextStyle(color: Colors.white60),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                fun2 = !fun2;
                              });
                            },
                            child: ExpWidget(
                              title: 'Menu',
                              fun: fun2,
                              content: [
                                GestureDetector(
                                  onTap: () => FirebaseAuth.instance.signOut(),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Logout",
                                          style: TextStyle(
                                              fontSize:
                                                  (width < 350 ? 350 : width) *
                                                      0.028,
                                              color: Colors.white60),
                                        ),
                                        Icon(
                                          Icons.power_settings_new,
                                          color: Colors.red,
                                          size: (width < 350 ? 350 : width) *
                                              0.055,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                fun3 = !fun3;
                              });
                            },
                            child: ExpWidget(
                              title: 'Peoples',
                              fun: fun3,
                              content: users.reversed.toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Future<void> _insertData(String caption) async {
    var _id = M.ObjectId().toString();
    final data = postModel(
      caption: 'This is inserted from webapp',
      comment: 'no com',
      iId: _id,
      isLiked: false,
      userId: 'Akshay',
    );
    // var result = await slDatabase.insert(data);
  }
  // Future<Widget> _getImage(BuildContext context,String image)async{
  //   Image m;
  //   await FirebaseSt
  // }
}
