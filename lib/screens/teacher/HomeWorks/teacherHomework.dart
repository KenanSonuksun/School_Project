import 'package:flutter/material.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customText.dart';

class TeacherHomeWork extends StatefulWidget {
  @override
  _TeacherHomeWorkState createState() => _TeacherHomeWorkState();
}

class _TeacherHomeWorkState extends State<TeacherHomeWork> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        centerTitle: true,
        title: CustomText(
          color: Colors.white,
          sizes: TextSize.normal,
          text: "Ödev Sistemi",
        ),
      ),
    );
  }
}
