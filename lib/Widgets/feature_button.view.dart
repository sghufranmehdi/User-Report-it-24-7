import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:help_247/Models/model_class.dart';
import 'package:help_247/getLocation.dart';
import 'package:help_247/toast.dart';
import 'package:help_247/units/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class FeatureButtonsView extends StatefulWidget {
  final Function onUploadComplete;
  const FeatureButtonsView({
    Key? key,
    required this.onUploadComplete,
  }) : super(key: key);
  @override
  _FeatureButtonsViewState createState() => _FeatureButtonsViewState();
}

class _FeatureButtonsViewState extends State<FeatureButtonsView> {
  final postRef = FirebaseFirestore.instance.collection('Instant Reports');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  final locationController = TextEditingController();

  String? name;
  String? audio;
  String? submit;

  late bool _isPlaying;
  late bool _isUploading;
  late bool _isRecorded;
  late bool _isRecording;

  late AudioPlayer _audioPlayer;
  String? _filePath;

  late FlutterAudioRecorder2 _audioRecorder;

  @override
  void initState() {
    super.initState();
    _isPlaying = false;
    _isUploading = false;
    _isRecorded = false;
    _isRecording = false;
    _audioPlayer = AudioPlayer();
    _getNameByNo();
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

  void setImageData() async {
    try {
      EasyLoading.show(status: 'loading...');
      dynamic time = DateFormat('yyyy-MM-dd hh:mm:ss:S').format(DateTime.now());

      // database folder configuration order
      firebase_storage.Reference imgRef =
          firebase_storage.FirebaseStorage.instance.ref('InstantFiles / $time');
      UploadTask uploadTask = imgRef.putFile(image!);
      await Future.value(uploadTask);
      var imageUrl = await imgRef.getDownloadURL();

      firebase_storage.Reference audioRef =
          firebase_storage.FirebaseStorage.instance.ref('Files / $time');
      UploadTask uploadAudio = audioRef.putFile(File(_filePath!));
      await Future.value(uploadAudio);
      var audioUrl = await audioRef.getDownloadURL();

      // firebase_storage.Reference ref =
      //     firebase_storage.FirebaseStorage.instance.ref('Images / $time');
      // UploadTask uploadTask = ref.putFile(
      //   File(_filePath),
      // );
      // await Future.value(uploadTask);
      // var audioUrl = await ref.getDownloadURL();
      // UploadTask uploadImage = ref.putFile(
      //   File(image!.path),
      // );
      // await Future.value(uploadImage);
      // var imageUrl = await ref.getDownloadURL();

      final User? user = _auth.currentUser;

      postRef.add({
        'Name': name,
        'Image': imageUrl,
        'Email': user!.phoneNumber,
        'Audio': audioUrl,
        'Location': locationController.text,
        'Submit to': submit,
      }).then((value) {
        EasyLoading.showSuccess('Success...');
      });
    } catch (e) {
      print(e);
      showToast('Exception : ${e.toString()}');
      print(e);
    }
  }

  final List<SimpleModel> items = <SimpleModel>[
    SimpleModel('Rescue 1122', false, Icons.local_hospital_sharp),
    SimpleModel('Police Department', false, Icons.local_police_outlined),
    SimpleModel('Ambulance', false, Icons.apartment),
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildImage(),
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
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  'Start/Stop Recording',
                  style: TextStyle(
                      color: alphaColor,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: _isRecorded
                ? _isUploading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: LinearProgressIndicator()),
                          Text('Uplaoding to Firebase'),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    EdgeInsets.only(left: 8, top: 5, bottom: 5),
                                side: BorderSide(
                                  color: Colors.orange,
                                  width: 3.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                primary: Colors.white,
                                elevation: 5.0,
                              ),
                              onPressed: _onRecordAgainButtonPressed,
                              icon: Icon(
                                Icons.replay,
                                color: Colors.red,
                                size: 35.0,
                              ),
                              label: Text(''),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Container(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    EdgeInsets.only(left: 8, top: 5, bottom: 5),
                                side: BorderSide(
                                  color: Colors.orange,
                                  width: 3.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                primary: Colors.white,
                                elevation: 5.0,
                              ),
                              onPressed: _onPlayButtonPressed,
                              icon: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.red,
                                size: 35.0,
                              ),
                              label: Text(''),
                            ),
                          ),
                        ],
                      )
                : Container(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.only(left: 8, top: 5, bottom: 5),
                        side: BorderSide(
                          color: Colors.orange,
                          width: 3.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        primary: Colors.white,
                        elevation: 5.0,
                      ),
                      onPressed: _onRecordButtonPressed,
                      icon: _isRecording
                          ? Icon(
                              Icons.pause,
                              color: Colors.red,
                              size: 35.0,
                            )
                          : Icon(
                              Icons.fiber_manual_record,
                              color: Colors.red,
                              size: 35.0,
                            ),
                      label: Text(''),
                    ),
                  ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    'Enter the Department which you want to report?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          GestureDetector(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                if (image == null) {
                  return showToast('Image not selected');
                } else if (_filePath == null) {
                  return showToast('Audio not recorded');
                } else if (image != null && _filePath!.isNotEmpty) {
                  setImageData();
                }
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
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
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void _onRecordAgainButtonPressed() {
    setState(() {
      _isRecorded = false;
    });
  }

  Future<void> _onRecordButtonPressed() async {
    if (_isRecording) {
      _audioRecorder.stop();
      _isRecording = false;
      _isRecorded = true;
    } else {
      _isRecorded = false;
      _isRecording = true;

      await _startRecording();
    }
    setState(() {});
  }

  void _onPlayButtonPressed() {
    if (!_isPlaying) {
      _isPlaying = true;

      _audioPlayer.play(_filePath!, isLocal: true);
      _audioPlayer.onPlayerCompletion.listen((duration) {
        setState(() {
          _isPlaying = false;
        });
      });
    } else {
      _audioPlayer.pause();
      _isPlaying = false;
    }
    setState(() {});
  }

  Future<void> _startRecording() async {
    final bool? hasRecordingPermission =
        await FlutterAudioRecorder2.hasPermissions;

    if (hasRecordingPermission ?? false) {
      Directory directory = await getApplicationDocumentsDirectory();
      String filepath = directory.path +
          '/' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.aac';
      _audioRecorder =
          FlutterAudioRecorder2(filepath, audioFormat: AudioFormat.AAC);
      await _audioRecorder.initialized;
      _audioRecorder.start();
      _filePath = filepath;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(child: Text('Please enable recording permission'))));
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
        // attachments.add(image.path);
      });
    } else {
      return null;
      //print('Image not selected ');
    }
  }

  Widget buildImage() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: 10, left: 30),
          child: Text(
            'Instant Report',
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
          onTap: () {},
          child: Container(
              margin: EdgeInsets.only(left: 50, right: 50, top: 5),
              alignment: Alignment.center,
              height: 200,
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
                      height: 250,
                      width: 300,
                      fit: BoxFit.fill,
                    )
                  : GestureDetector(
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
                                        pickImage(ImageSource.camera)
                                            .then((value) {
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Text(
                                        'Camera',
                                        style:
                                            TextStyle(color: Color(0xff9f7d24)),
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
                                              color: Color(0xff9f7d24)))),
                                ],
                              ),
                            ));
                          },
                        );
                      },
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: alphaColor,
                        size: 50,
                      ),
                    )),
        ),
      ],
    );
  }
}
