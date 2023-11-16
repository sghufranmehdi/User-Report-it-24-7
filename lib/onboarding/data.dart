import 'dart:ui';

var pageList = [
  PageModel(
      imageUrl: "Images/solution.png",
      title: "One Solution",
      body: "Provide one solution for evidence base reporting.",
      // titleGradient: [Color(0xFFb83021), Color(0xFFc8e02b)]),
      titleGradient: [Color(0xFF030a05), Color(0xFF030a05)]),
  PageModel(
      imageUrl: "Images/camera1.png",
      title: "Take Picture",
      body: "Provide help from nearby department in emergency.",
      titleGradient: [Color(0xFF030a05), Color(0xFF030a05)]),
  PageModel(
      imageUrl: "Images/tag1.png",
      title: "Tag litter",
      body: "Provide a digital way of reporting.",
      titleGradient: [Color(0xFF030a05), Color(0xFF030a05)]),
  PageModel(
      imageUrl: "Images/upload.png",
      title: "Upload Images",
      body:
          "Help government department to resolve issues using digital medium.",
      titleGradient: [Color(0xFF030a05), Color(0xFF030a05)]),
  // titleGradient: [Color(0xFF102e10), Color(0xFF02c5ed)]),
];

class PageModel {
  String imageUrl;
  String title;
  String body;
  List<Color> titleGradient = [];

  PageModel(
      {required this.imageUrl,
      required this.title,
      required this.body,
      required this.titleGradient});
}
