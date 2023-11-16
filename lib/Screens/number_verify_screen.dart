import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help_247/Models/preference1.dart';
import 'package:help_247/Screens/edit_profile_screen.dart';
import 'package:help_247/Screens/main_screen.dart';
import 'package:help_247/toast.dart';
import 'package:help_247/units/colors.dart';
import 'package:help_247/units/styles.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyNumberScreen extends StatefulWidget {
  final String? number;
  final String? countryCode;
  VerifyNumberScreen({required this.number, required this.countryCode});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VerifyNumberScreenState();
  }

  // @override
  // _VerifyNumberScreenState createState() => _VerifyNumberScreenState();
}

class VerifyNumberScreenState extends State<VerifyNumberScreen> {
  TextEditingController pinCodeController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  bool firstTimeOpen = false;
  bool hasError = false;
  String? verificationCode;
  String? pin;

  final formKey = GlobalKey<FormState>();

  void signInWithPhoneNo() async {
    try {
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: verificationCode!, smsCode: pin!))
          .then((value) => {
                if (value.user != null)
                  {
                    showToast('Login Successfully'),
                    if (firstTimeOpen == true)
                      {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => MainScreen()))
                      }
                    else
                      {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => EditProfileScreen()))
                      }
                  }
              });
    } catch (e) {
      showToast('Invalid PinCode');
    }
  }

  VerifyNumberScreenState() {
    MySharedPreferences1.instance
        .getBooleanVal("once")
        .then((value) => setState(() {
              firstTimeOpen = value;
            }));
  }

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    verifyPhoneNumber();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "${widget.countryCode}${widget.number}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => {
                  if (value.user != null)
                    {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditProfileScreen()))
                    }
                });
      },
      verificationFailed: (FirebaseAuthException e) {
        showToast(e.message.toString());
      },
      codeSent: (String verifyID, int? resendToken) {
        setState(() {
          verificationCode = verifyID;
        });
      },
      codeAutoRetrievalTimeout: (String verifyID) {
        setState(() {
          verificationCode = verifyID;
        });
      },
      timeout: Duration(seconds: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(30.0, 100.0, 0.0, 0.0),
                    child: Text(
                      'Report It',
                      style: TextStyle(
                        color: alphaColor,
                        // color: Colors.while,
                        fontSize: 70.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(160.0, 175.0, 0.0, 0.0),
                    child: Text(
                      '24/7',
                      style: TextStyle(
                        color: alphaColor,
                        // color: Colors.while,
                        fontSize: 70.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(300.0, 110.0, 0.0, 0.0),
                    child: Text(
                      '.',
                      style: TextStyle(
                          fontSize: 140.0,
                          fontWeight: FontWeight.bold,
                          color: alphaColor),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
              child: RichText(
                text: TextSpan(
                    text: "Enter the code sent to ",
                    children: [
                      TextSpan(
                          text: 'Verifying : ${widget.number}',
                          style: TextStyle(
                              color: alphaColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ],
                    style: TextStyle(color: Colors.grey, fontSize: 15)),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Form(
              key: formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
                child: PinCodeTextField(
                  appContext: context,
                  pastedTextStyle: TextStyle(
                    color: alphaColor,
                    fontWeight: FontWeight.bold,
                  ),
                  length: 6,
                  obscureText: true,
                  obscuringCharacter: '*',
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  validator: (v) {
                    if (v!.length < 6) {
                      return "Please Fill it ";
                    } else {
                      return null;
                    }
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    fieldWidth: 40,
                    selectedColor: alphaColor,
                    inactiveColor: Colors.grey,
                  ),
                  cursorColor: Colors.transparent,
                  animationDuration: Duration(milliseconds: 300),
                  enableActiveFill: false,
                  errorAnimationController: errorController,
                  controller: pinCodeController,
                  keyboardType: TextInputType.number,
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      pin = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(height: 20),
            Container(
              height: 50.0,
              width: 280,
              margin: EdgeInsets.symmetric(horizontal: 55),
              child: Material(
                borderRadius: BorderRadius.circular(20.0),
                color: alphaColor,
                shadowColor: Colors.white,
                elevation: 5.0,
                child: GestureDetector(
                  onTap: () {
                    signInWithPhoneNo();
                    // verifyPhoneNumber();
                  },
                  child: Center(
                    child: Text(
                      'VERIFY',
                      style: kLoginSignUpButton,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive the code? ",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                TextButton(
                    onPressed: () {
                      verifyPhoneNumber();
                      showToast("OTP resend!!");
                    },
                    child: Text(
                      "RESEND",
                      style: TextStyle(
                          color: alphaColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
