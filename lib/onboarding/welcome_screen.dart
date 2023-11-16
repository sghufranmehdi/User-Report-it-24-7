import 'package:flutter/material.dart';
import 'package:help_247/Models/preference.dart';
import 'package:help_247/Screens/login_Screen.dart';
import 'package:help_247/onboarding/page_indicator.dart';
import 'package:help_247/units/colors.dart';
import 'package:help_247/units/styles.dart';

import 'data.dart';

class OnBoardWelcomeScreen extends StatefulWidget {
  @override
  _OnBoardWelcomeScreenState createState() => _OnBoardWelcomeScreenState();
}

class _OnBoardWelcomeScreenState extends State<OnBoardWelcomeScreen>
    with TickerProviderStateMixin {
  // MySharedPreferences.instance.setBooleanValue("firstTimeOpen", true);

  PageController? _controller;
  int currentPage = 0;
  bool isLastPage = false;
  AnimationController? animationController;
  Animation<double>? _scaleAnimation;

  @override
  void initState() {
    super.initState();
    MySharedPreferences.instance.setBooleanValue("firstTimeOpen", true);
    _controller = PageController(
      initialPage: currentPage,
    );
    animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _scaleAnimation = Tween(begin: 0.6, end: 1.0).animate(animationController!);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [betaColor, alphaColor],
            // colors: [betaColor, Color(0xFF071708)],
            tileMode: TileMode.clamp,
            begin: Alignment.topCenter,
            stops: [0.0, 1.0],
            end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            PageView.builder(
              itemCount: pageList.length,
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                  isLastPage = currentPage == pageList.length - 1;
                  if (isLastPage) {
                    animationController!.forward();
                  } else {
                    animationController!.reset();
                  }
                });
                print(isLastPage);
              },
              itemBuilder: (context, index) => AnimatedBuilder(
                animation: _controller!,
                builder: (context, child) => animatedPageViewBuilder(index),
              ),
            ),
            Positioned(
              left: 170.0,
              bottom: 55.0,
              width: 50.0,
              child: PageIndicator(currentPage, pageList.length),
            ),
            Positioned(
              right: 30.0,
              bottom: 30.0,
              child: ScaleTransition(
                scale: _scaleAnimation!,
                child: isLastPage
                    ? FloatingActionButton(
                        backgroundColor: bgColor,
                        child: Icon(
                          Icons.arrow_forward,
                          color: alphaColor,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ));
                        },
                      )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget animatedPageViewBuilder(int index) {
    PageModel page = pageList[index];
    double delta;
    double y = 1.0;

    if (_controller!.position.haveDimensions) {
      delta = (_controller!.page! - index);
      y = delta.abs().clamp(0.0, 1.0);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Center(
          child: Image.asset(page.imageUrl),
        ),
        Container(
            padding: const EdgeInsets.only(left: 34.0, top: 12.0),
            transform: Matrix4.translationValues(0, 50.0 * y, 0),
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text(
                page.body,
                textAlign: TextAlign.justify,
                style: onBoardingDescription,
              ),
            ))
      ],
    );
  }
}
