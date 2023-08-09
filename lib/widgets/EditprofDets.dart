import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:login/Models/userModel.dart';
import 'package:http/http.dart' as http;
import 'package:login/constants.dart';
import 'package:login/widgets/snackbar.dart';

import '../authServices/config.dart';

class profeditDialog extends StatefulWidget {
  UModel userData;

  profeditDialog({required this.userData});

  @override
  State<profeditDialog> createState() => _profeditDialogState();
}

class _profeditDialogState extends State<profeditDialog> {
  late String name;
  late String userId;
  late int phoneNumber;
  late String profilePicture;

  late String filtDeptDDval;
  late String filtyearDDval;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imguploaded = true;
    name = widget.userData.name;
    userId = '';
    profilePicture = '';
    phoneNumber = widget.userData.phn;
    durl = widget.userData.upic;
    filtDeptDDval = widget.userData.dept;
    filtyearDDval = year(widget.userData.year);
  }

  late String durl;
  late Uint8List selectedImageInBytes;
  late bool imguploaded;

  Future _selectFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result != null) {
      setState(() {});
      selectedImageInBytes = result.files.first.bytes!;
    }
  }

  Future<String> getDownloadUrl(UploadTask task) async {
    final snapshot = await task.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _uploadImage() async {
    setState(() {
      imguploaded = false;
    });
    // Get the image file
    await _selectFile();
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
          imguploaded = true;
          durl = downloadUrl;
        });
        print(downloadUrl);
        // print(uploadTask);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  void UpdateData(String uid) async {
    var regBody = {
      "name": name,
      "upic": durl.toString(),
      "dept": filtDeptDDval,
      "year": Intyear(filtyearDDval),
      "phn": phoneNumber
    };
    try {
      var response = await http.put(
          Uri.parse("${URL}users/${widget.userData.uid}"),
          body: jsonEncode(regBody),
          headers: {"Content-Type": "application/json"});

      print("printed Status :" + response.body.toString());
    } catch (e) {
      print("Erroris" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add User'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                initialValue: name,
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Name'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                enabled: false,
                onChanged: (value) {
                  setState(() {
                    userId = value;
                  });
                },
                decoration: InputDecoration(labelText: 'User ID'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Implement image picker logic
                    },
                    icon: IconButton(
                      icon: Icon(Icons.add_a_photo),
                      onPressed: _uploadImage,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Text('Add Profile Image'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 6),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(8)),
                child: DropdownButton<String>(
                  // isExpanded: true,r
                  value: filtyearDDval,
                  style: TextStyle(color: Colors.black87),
                  dropdownColor: Colors.orange.withOpacity(0.3),
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (String? newValue) {
                    setState(() {
                      filtyearDDval = newValue!;
                    });
                  },
                  items: <String>['FY', 'SY', 'TY', 'BE', 'NA']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.orange),
                ),
                child: DropdownButton<String>(
                  dropdownColor: Colors.orange.withOpacity(0.3),

                  // isExpanded: true,
                  value: filtDeptDDval,

                  icon: Icon(Icons.arrow_drop_down),
                  borderRadius: BorderRadius.circular(8),
                  style: TextStyle(color: Colors.black87),
                  onChanged: (String? newValue) {
                    setState(() {
                      filtDeptDDval = newValue!;
                    });
                  },
                  items:
                      <String>['COMP', 'ENTC', 'MECH', 'CIVIL', 'IT', 'DEFAULT']
                          .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                initialValue: phoneNumber.toString(),
                onChanged: (value) {
                  setState(() {
                    phoneNumber = int.parse(value);
                  });
                },
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            setState(() {});
            if (imguploaded) {
              UpdateData(widget.userData.uid);
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  content: CsnackBar(
                    snackBarColor: Colors.orange,
                    snackBarIcon: Icon(Icons.error_outline),
                    snackBarText: "Wait..Image is Being Uploaded..",
                  )));
            }
          },
          child: Text('Add'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
