import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_247/Screens/number_verify_screen.dart';
import 'package:help_247/units/colors.dart';
import 'package:help_247/units/styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  String dialCode = '+92';

  @override
  void dispose() {
    emailController.clear();
    numberController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                Container(
                  padding: EdgeInsets.only(
                    top: 35.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: numberController,
                        validator: (password) {
                          if (password == null || password.isEmpty) {
                            return 'Required';
                          } else if (password.length != 11) {
                            return 'incorrect number';
                          }
                        },
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        cursorColor: alphaColor,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: alphaColor, width: 3.0),
                          ),
                          labelText: 'Number',
                          fillColor: Colors.grey,
                          labelStyle: kLabelText,
                        ),
                        obscureText: false,
                      ),
                      SizedBox(
                        height: 70.0,
                      ),
                      Container(
                        height: 50.0,
                        width: 280,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          color: alphaColor,
                          shadowColor: Colors.white,
                          elevation: 5.0,
                          child: GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VerifyNumberScreen(
                                              number: numberController.text,
                                              countryCode: dialCode,
                                            )));
                              }
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
