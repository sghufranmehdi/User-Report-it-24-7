import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help_247/units/colors.dart';
import 'package:help_247/units/styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final postRef = FirebaseFirestore.instance.collection('Profile');
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: postRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: alphaColor,
              ),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_auth.currentUser!.uid == data['Uid']) ...[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Text(
                              '   Profile',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: alphaColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Stack(
                              children: [
                                Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 4, color: alphaColor),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            offset: Offset(0, 0))
                                      ],
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(data['Image'] ??
                                            'Error Fetching Image...'),
                                      )),
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
                                        onPressed: () {},
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            data['Name'] ?? 'Error Fetching Name...',
                            style: editProfileColour,
                          ),
                          Divider(
                            color: Colors.black54,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            data['Username'] ?? 'Error Fetching Username...',
                            style: editProfileColour,
                          ),
                          Divider(
                            color: Colors.black54,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            _auth.currentUser!.phoneNumber ?? data['Number'],
                            style: editProfileColour,
                          ),
                          Divider(
                            color: Colors.black54,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ]
                ],
              );
            }).toList(),
          );
        });
  }
}
