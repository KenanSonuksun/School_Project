import 'package:flutter/material.dart';
import 'package:schoolproject/components/animation.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/lessonTimeline.dart';
import 'package:schoolproject/components/noData.dart';
import 'package:schoolproject/screens/teacher/LessonPlan/teacherAddLesson.dart';

class TeacherLessonPlan extends StatefulWidget {
  final int index;
  final classes;

  const TeacherLessonPlan({Key key, this.index, this.classes})
      : super(key: key);
  @override
  _TeacherLessonPlanState createState() => _TeacherLessonPlanState();
}

class _TeacherLessonPlanState extends State<TeacherLessonPlan>
    with SingleTickerProviderStateMixin {
  List mon = [], tues = [], wed = [], thur = [], fri = [];
  AnimationController animationController;

  @override
  void initState() {
    for (int i = 0; i < widget.classes["lessonPlan"].length; i++) {
      if (widget.classes["lessonPlan"][i]["dateName"] == "Monday") {
        setState(() {
          mon.add(widget.classes["lessonPlan"][i]);
        });
      } else if (widget.classes["lessonPlan"][i]["dateName"] == "Wednesday") {
        setState(() {
          wed.add(widget.classes["lessonPlan"][i]);
        });
      } else if (widget.classes["lessonPlan"][i]["dateName"] == "Tuesday") {
        setState(() {
          tues.add(widget.classes["lessonPlan"][i]);
        });
      } else if (widget.classes["lessonPlan"][i]["dateName"] == "Thursday") {
        setState(() {
          thur.add(widget.classes["lessonPlan"][i]);
        });
      } else if (widget.classes["lessonPlan"][i]["dateName"] == "Friday") {
        setState(() {
          fri.add(widget.classes["lessonPlan"][i]);
        });
      }
    }
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      //Appbar
      appBar: CustomAppBar(
        text: "Ders Programı",
        widget: SizedBox(),
      ),
      //Body
      body: widget.classes["lessonPlan"].length == 0
          ? NoData(
              text:
                  "Seçtiğiniz sınıfa ait herhangi bir ders programı kaydı bulunmamaktadır.",
            )
          : SingleChildScrollView(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //widgets
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return SlideAnimation(
                      animationController: animationController,
                      itemCount: 5,
                      position: index,
                      slideDirection: SlideDirection.fromBottom,
                      child: LessonTimeLine(
                        array: index == 0
                            ? mon
                            : index == 1
                                ? tues
                                : index == 2
                                    ? wed
                                    : index == 3
                                        ? thur
                                        : fri,
                      ),
                    );
                  },
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
                        classInformation: widget.classes,
                        index: widget.index)));
          },
        ),
      ),
    );
  }
}
