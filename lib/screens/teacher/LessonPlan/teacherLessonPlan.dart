import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/components/lessonTimeline.dart';
import 'package:schoolproject/providers/classesProvider.dart';
import 'package:schoolproject/screens/teacher/LessonPlan/teacherAddLesson.dart';
import 'package:schoolproject/screens/teacher/HomePage/teacherHomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherLessonPlan extends StatefulWidget {
  final int index;

  const TeacherLessonPlan({Key key, this.index}) : super(key: key);
  @override
  _TeacherLessonPlanState createState() => _TeacherLessonPlanState();
}

class _TeacherLessonPlanState extends State<TeacherLessonPlan> {
  ClassesProvider classesProvider;
  String email;
  List mon = [], tues = [], wed = [], thur = [], fri = [];

  //Get data from firebase
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString("email");
    });
    classesProvider = Provider.of<ClassesProvider>(context, listen: false);
    classesProvider.getData(email);
    for (int i = 0;
        i < classesProvider.classes[widget.index]["Wednesday"].length;
        i++) {
      setState(() {
        wed.add(classesProvider.classes[widget.index]["Wednesday"][i]);
      });
    }
    for (int i = 0;
        i < classesProvider.classes[widget.index]["Monday"].length;
        i++) {
      setState(() {
        mon.add(classesProvider.classes[widget.index]["Monday"][i]);
      });
    }
    for (int i = 0;
        i < classesProvider.classes[widget.index]["Tuesday"].length;
        i++) {
      setState(() {
        tues.add(classesProvider.classes[widget.index]["Tuesday"][i]);
      });
    }
    for (int i = 0;
        i < classesProvider.classes[widget.index]["Thursday"].length;
        i++) {
      setState(() {
        thur.add(classesProvider.classes[widget.index]["Thursday"][i]);
      });
    }
    for (int i = 0;
        i < classesProvider.classes[widget.index]["Friday"].length;
        i++) {
      setState(() {
        fri.add(classesProvider.classes[widget.index]["Friday"][i]);
      });
    }
  }

  //Loading screen before screen
  bool isLoading = true;
  void startTimer() {
    Timer.periodic(const Duration(seconds: 2), (t) {
      setState(() {
        isLoading = false; //set loading to false
      });
      t.cancel(); //stops the timer
    });
  }

  @override
  void initState() {
    getData();
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final className = Provider.of<ClassesProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //Appbar
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        backwardsCompatibility: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => TeacherHomePage()),
                  (Route<dynamic> route) => false);
            }),
        centerTitle: true,
        title: CustomText(
          color: Colors.white,
          sizes: TextSize.normal,
          text: "Ders Programı",
        ),
      ),
      //Body
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //widgets
                LessonTimeLine(
                  dizi: mon,
                ),
                LessonTimeLine(
                  dizi: tues,
                ),
                LessonTimeLine(
                  dizi: wed,
                ),
                LessonTimeLine(
                  dizi: thur,
                ),
                LessonTimeLine(
                  dizi: fri,
                ),
                SizedBox(
                  height: size.height * 0.05,
                )
              ],
            )),
      //A button to add
      floatingActionButton: Container(
        height: size.width * 0.15,
        width: size.width * 0.15,
        child: FloatingActionButton(
          backgroundColor: secondaryColor,
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TeacherAddLesson(
                        classInfo: className.classes, index: widget.index)));
          },
        ),
      ),
    );
  }
}
