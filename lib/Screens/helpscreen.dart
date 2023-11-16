import 'package:flutter/material.dart';
import 'package:help_247/Widgets/appbar.dart';
import 'package:help_247/units/colors.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              '  About',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: alphaColor,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                // color: alphaColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
