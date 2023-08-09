// import 'dart:io';

// // import 'package:file_picker/_internal/file_picker_web.dart';
// import 'package:flutter/material.dart';
// // import 'package:file_picker/file_picker.dart';

// class TwitterPostScreen extends StatefulWidget {
//   @override
//   _TwitterPostScreenState createState() => _TwitterPostScreenState();
// }

// class _TwitterPostScreenState extends State<TwitterPostScreen> {
//   final List<Tweet> tweets = [];

//   final _formKey = GlobalKey<FormState>();
//   final _tweetController = TextEditingController();
//   File? _image;

//   void addTweet(Tweet tweet) {
//     setState(() {
//       tweets.add(tweet);
//     });
//   }

//   void _submitTweet() {
//     if (_formKey.currentState!.validate()) {
//       String content = _tweetController.text;
//       Tweet tweet = Tweet(content: content, image: _image);
//       addTweet(tweet);

//       _tweetController.clear();
//       setState(() {
//         _image = null;
//       });
//     }
//   }

//   // void _pickImage() async {
//   //   try {
//   //     print('in try');
//   //     final result = await FilePickerWeb.platform.pickFiles(
//   //       type: FileType.image,
//   //       allowMultiple: false,
//   //     );

//   //     if (result != null && result.files.isNotEmpty) {
//   //       print(result.files.single.path);
//   //       setState(() {
//   //         _image = File(result.files.single.path!);
//   //       });
//   //     }
//   //   } catch (e) {
//   //     print(e);
//   //   }
//   // }

//   @override
//   void dispose() {
//     _tweetController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Twitter Post')),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'What\'s happening?',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 16.0),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: _tweetController,
//                       maxLines: null,
//                       decoration: InputDecoration(
//                         hintText: 'Share your thoughts...',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter a tweet';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 16.0),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         TextButton.icon(
//                           onPressed: (){},
//                           icon: Icon(Icons.image),
//                           label: Text('Add Image'),
//                         ),
//                         ElevatedButton(
//                           onPressed: _submitTweet,
//                           child: Text('Post'),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               Divider(thickness: 1.0),
//               SizedBox(height: 16.0),
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: tweets.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return buildTweetItem(tweets[index]);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildTweetItem(Tweet tweet) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ListTile(
//           leading: CircleAvatar(
//             radius: 24.0,
//             backgroundImage: AssetImage('assets/avatar.png'),
//           ),
//           title: Text(
//             'John Doe',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           subtitle: Text('@johndoe'),
//         ),
//         SizedBox(height: 8.0),
//         Text(
//           tweet.content,
//           style: TextStyle(fontSize: 16.0),
//         ),
//         if (tweet.image != null)
//           SizedBox(
//             height: 200.0,
//             child: Image.file(tweet.image!),
//           ),
//         SizedBox(height: 16.0),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 IconButton(
//                   onPressed: () {},
//                   icon: Icon(Icons.favorite_border),
//                 ),
//                 Text('0 Likes'),
//               ],
//             ),
//             IconButton(
//               onPressed: () {},
//               icon: Icon(Icons.share),
//             ),
//           ],
//         ),
//         SizedBox(height: 16.0),
//         Divider(thickness: 1.0),
//         SizedBox(height: 16.0),
//       ],
//     );
//   }
// }

// class Tweet {
//   final String content;
//   final File? image;

//   Tweet({required this.content, this.image});
// }
