import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_247/Screens/helpscreen.dart';
import 'package:help_247/Screens/instant_report_screen.dart';
import 'package:help_247/Screens/statusReport.dart';
import 'package:help_247/Screens/submitrepot_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final titles = [
    "Detailed Report",
    "Instant Report",
    "Report History",
    "Help",
  ];

  final screens = [
    ComplainScreen(),
    InstantReportScreen(),
    StatusReport(),
    HelpScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            child: Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Center(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => screens[index]));
                    },
                    title: Text(
                      titles[index],
                      style: TextStyle(fontSize: 20),
                    ),
                    // subtitle: Text(subtitles[index]),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                        'Images/splh.png',
                      ),
                    ),
                  ),
                )),
          );
        });
  }
}
