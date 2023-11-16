import 'package:flutter/material.dart';
import 'package:help_247/units/colors.dart';

AppBar header(
  context,
) {
  return AppBar(
    automaticallyImplyLeading: true,
    // centerTitle: true,
    backgroundColor: alphaColor,
    title: Text(
      'ReportIt247',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}
