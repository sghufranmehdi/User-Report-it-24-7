import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_247/Widgets/appbar.dart';
import 'package:help_247/Widgets/feature_button.view.dart';
import 'package:help_247/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class InstantReportScreen extends StatefulWidget {
  const InstantReportScreen({Key? key}) : super(key: key);

  @override
  _InstantReportScreenState createState() => _InstantReportScreenState();
}

class _InstantReportScreenState extends State<InstantReportScreen> {
  List<Reference> references = [];

  final postRef = FirebaseFirestore.instance.collection('Instant Reports');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  var audio;
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
        // attachments.add(image.path);
      });
    } else {
      return null;
      //print('Image not selected ');
    }
  }

  void setData() async {
    try {
      showToast('Please wait for 10 sec. while we process data.');
      dynamic time = DateFormat('yyyy-MM-dd hh:mm:ss:S').format(DateTime.now());

      // database folder configuration order
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref('Images / $time');
      UploadTask uploadTask = ref.putFile(
        File(audio!),
      );
      await Future.value(uploadTask);
      var imageUrl = await ref.getDownloadURL();

      final User? user = _auth.currentUser;

      postRef.add({
        'Image': imageUrl,
        'Audio': audio,
        'Number': user!.phoneNumber,
        'uid': user.uid,
      }).then((value) {
        showToast('Complain submitted');
      });
    } catch (e) {
      print(e);
      showToast('Exception : ${e.toString()}');
      print(e);
    }
  }

  Future<void> _onUploadComplete() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    ListResult listResult =
        await firebaseStorage.ref().child('upload-voice-firebase').list();
    setState(() {
      references = listResult.items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Container(
                  child: FeatureButtonsView(
                    onUploadComplete: _onUploadComplete,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
