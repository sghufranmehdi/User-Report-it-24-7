import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:help_247/Models/model_class.dart';
import 'package:help_247/getLocation.dart';
import 'package:help_247/toast.dart';
import 'package:help_247/units/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ComplainScreen extends StatefulWidget {
  @override
  _ComplainScreenState createState() => _ComplainScreenState();
}

class _ComplainScreenState extends State<ComplainScreen> {
  final _formKey = GlobalKey<FormState>();
  Timer? _timer;
  String? name;

  // final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  dynamic onTime = DateFormat('yyyy-MM-dd  hh:mm ').format(DateTime.now());
  bool isClicked = false;
  String? submit;

  List<String> _locations = [
    'Murder',
    'Missing item',
    'Accident',
    'Missing person',
    'Others'
  ];
  String? _selectedDepartment;

  final postRef = FirebaseFirestore.instance.collection('Reports').doc();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  File? image;
  List<File> attachment = [];
  Future pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
    );
    if (image != null) {
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
        attachment.add(imageTemporary);
      });
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    image == null;
    name == null;
    descriptionController.dispose();
    locationController.dispose();
    _selectedDepartment == null;
    items == null;

    super.dispose();
    // initState();
  }

  @override
  void initState() {
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    _getNameByNo();
    // getName();
    setState(() {
      image == null;
      _selectedDepartment = null;
    });
  }

  Future<void> _getNameByNo() async {
    User? user = _auth.currentUser;
    FirebaseFirestore.instance
        .collection('Profile')
        .where('Number', isEqualTo: user!.phoneNumber)
        // .where('Email', isEqualTo: user.email)
        .snapshots()
        .listen((doc) {
      doc.docs.forEach((data) {
        setState(() {
          name = data.data()['Name'];
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
        'Name': name,
        'Department': _selectedDepartment,
        'Description': descriptionController.text.toString(),
        'Location': locationController.text.toString(),
        'Time': onTime,
        'Status': 'Active'.toString(),
        'Submit to': submit,
        'Email': user!.phoneNumber,
        'uid': user.uid,
        'id': postRef.id,
      }).then((value) {
        EasyLoading.showSuccess('Success!');
        // dispose();
        // sendMail();
      });
    } catch (e) {
      print(e);
      showToast('Exception : ${e.toString()}');
      print(e);
      if (image == null) {
        showToast('Image not selected');
      }
    }
  }

  final List<SimpleModel> items = <SimpleModel>[
    SimpleModel('Rescue 1122', false, Icons.local_hospital_sharp),
    SimpleModel('Police Department', false, Icons.local_police_outlined),
    SimpleModel('Ambulance', false, Icons.apartment),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(children: [
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 10, left: 30),
                child: Text(
                  'Report Info',
                  style: TextStyle(
                    color: alphaColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: 15,
                ),
                child: Text(
                  'Take a Image to Upload ',
                  style: TextStyle(
                    color: alphaColor,
                    fontSize: 17,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
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
                                  pickImage(ImageSource.camera).then((value) {
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text(
                                  'Camera',
                                  style: TextStyle(color: Color(0xff9f7d24)),
                                )),
                            Divider(),
                            TextButton(
                                onPressed: () {
                                  pickImage(ImageSource.gallery).then((value) {
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text('Gallery',
                                    style:
                                        TextStyle(color: Color(0xff9f7d24)))),
                          ],
                        ),
                      ));
                    },
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 50, right: 50, top: 5),
                  alignment: Alignment.center,
                  height: 170,
                  decoration: BoxDecoration(
                    color: inputFieldColor,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0),
                        blurRadius: 0,
                      )
                    ],
                  ),
                  child: image != null
                      ? Image.file(
                          image!.absolute,
                          height: 200,
                          width: 300,
                          fit: BoxFit.fill,
                        )
                      : Icon(
                          Icons.camera_alt_outlined,
                          color: alphaColor,
                          size: 50,
                        ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 50, right: 50, top: 20),
                padding: EdgeInsets.only(
                  left: 10,
                  right: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: inputFieldColor,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      blurRadius: 0,
                    )
                  ],
                ),
                alignment: Alignment.topLeft,
                child: TextFormField(
                  autofocus: true,
                  controller: locationController,
                  cursorColor: alphaColor,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          getCurrentLocation();
                          locationController.text =
                              firstLocation.addressLine.toString();
                        },
                        icon: Icon(
                          Icons.add_location,
                          color: alphaColor,
                        )),
                    hintText: 'Location ',
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '';
                    }
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 50, right: 50, top: 20),
                padding: EdgeInsets.only(
                  left: 10,
                  right: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: inputFieldColor,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      blurRadius: 0,
                    )
                  ],
                ),
                alignment: Alignment.centerLeft,
                child: DropdownButton(
                  hint: Text('Please choose '), // Not necessary for Option 1
                  value: _selectedDepartment,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedDepartment = newValue as String?;
                      print(_selectedDepartment);
                    });
                  },
                  items: _locations.map((location) {
                    return DropdownMenuItem(
                      child: new Text(
                        location,
                        style: TextStyle(color: Colors.black87),
                      ),
                      value: location,
                    );
                  }).toList(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 50,
                  right: 50,
                  top: 20,
                ),
                padding: EdgeInsets.only(
                  //  top: 30,
                  //  bottom: 30,
                  left: 15,
                  right: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: inputFieldColor,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      blurRadius: 0,
                    )
                  ],
                ),
                alignment: Alignment.topLeft,
                child: TextFormField(
                  autofocus: true,
                  controller: descriptionController,
                  cursorColor: betaColor,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    // border: UnderlineInputBorder(),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '';
                    }
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        'Enter the Department which you want to report?',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 45),
                      child: Column(
                        children: items
                            .map((SimpleModel item) => CheckboxListTile(
                                  title: Text(item.title),
                                  value: item.isChecked,
                                  activeColor: alphaColor,
                                  checkColor: Colors.white,
                                  secondary: Icon(
                                    item.icon,
                                    color: alphaColor,
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      item.isChecked = val!;
                                      submit = item.title;
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 60),
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (image == null) {
                        showToast('Image not selected');
                      } else if (!isClicked) {
                        isClicked = true;
                        setData();
                      } else {
                        print('Data being Processed...');
                        showToast('Data Being Processed Please Wait...');
                      }
                    }
                  },
                  child: Container(
                    // margin: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 75),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [(alphaColor), (alphaColor)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 0,
                          //  color:
                        )
                      ],
                    ),
                    child: Text(
                      'Submit ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
