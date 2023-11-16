import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:help_247/Models/preference1.dart';
import 'package:help_247/Screens/main_screen.dart';
import 'package:help_247/toast.dart';
import 'package:help_247/units/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  final postRef = FirebaseFirestore.instance.collection('Profile').doc();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  String? username;
  Timer? _timer;

  void initState() {
    MySharedPreferences1.instance.setBooleanVal("once", true);
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    _getData();
    // TODO: implement initState
    super.initState();
  }

  Future<void> _getData() async {
    FirebaseFirestore.instance.collection('Profile').snapshots().listen((doc) {
      doc.docs.forEach((data) {
        setState(() {
          username = data.data()['Username'];
        });
      });
    });
  }

  void setData() async {
    try {
      EasyLoading.show(status: 'Uploading...');
      dynamic time = DateFormat('yyyy-MM-dd hh:mm:ss:S').format(DateTime.now());
      // database folder configuration order
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref('Images / $time');
      UploadTask uploadTask = ref.putFile(image!);
      await Future.value(uploadTask);
      var imageUrl = await ref.getDownloadURL();
      final User? user = _auth.currentUser;
      postRef.set({
        'Image': imageUrl,
        'id': postRef.id,
        'Name': nameController.text,
        'Username': usernameController.text,
        'Time': time,
        'Number': user!.phoneNumber,
        'Uid': user.uid,
      }).then((value) {
        EasyLoading.showSuccess('Success!');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MainScreen(),
          ),
          (route) => false,
        );
      });
    } catch (e) {
      print(e);
      showToast('Exception : ${e.toString()}');
      print(e);
      if (image == null) {
        showToast('Image not selected');
        EasyLoading.dismiss();
      }
    }
  }

  File? image;
  Future pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
    );
    if (image != null) {
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    nameController.clear();
    usernameController.clear();
    setState(() {
      image == null;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Text(
                    '  Edit Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: alphaColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(width: 4, color: alphaColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 0))
                          ],
                          shape: BoxShape.circle,
                          image: image == null
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('Images/camera1.png'))
                              : DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(image!.absolute)),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: Colors.white,
                              ),
                              color: alphaColor,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.camera_enhance,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                        content: Container(
                                      height: 115,
                                      child: Column(
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                pickImage(ImageSource.camera)
                                                    .then((value) {
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Text(
                                                'Camera',
                                                style: TextStyle(
                                                    color: Color(0xff9f7d24)),
                                              )),
                                          Divider(),
                                          TextButton(
                                              onPressed: () {
                                                pickImage(ImageSource.gallery)
                                                    .then((value) {
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Text('Gallery',
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xff9f7d24)))),
                                        ],
                                      ),
                                    ));
                                  },
                                );
                              },
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (name) {
                    if (name == null || name.isEmpty) {
                      return 'Required';
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                  validator: (userName) {
                    if (userName == null || userName.isEmpty) {
                      return 'Required';
                    } else if (userName.contains(RegExp(r'[A-Z]'))) {
                      return 'username must be in lowercase';
                    } else if (userName == this.username) {
                      return 'Already in use';
                    } else if (userName.length <= 5) {
                      return 'username too short';
                    }
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlineButton(
                      padding: EdgeInsets.symmetric(horizontal: 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      onPressed: () {},
                      child: Text("CANCEL",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.black)),
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (image == null) {
                            showToast('Image not selected');
                          } else {
                            setData();
                          }
                        }
                      },
                      color: alphaColor,
                      padding: EdgeInsets.symmetric(horizontal: 55),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "SAVE",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
