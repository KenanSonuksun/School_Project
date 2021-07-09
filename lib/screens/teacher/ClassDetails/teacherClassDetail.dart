import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schoolproject/components/animation.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customDialogs.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/screens/teacher/HomePage/teacherHomePage.dart';
import 'package:schoolproject/screens/teacher/LessonPlan/teacherLessonPlan.dart';
import 'package:schoolproject/screens/teacher/Students/showStudents.dart';
import 'package:schoolproject/screens/teacher/classDetails/teacherEditClass.dart';

class TeacherClassDetail extends StatefulWidget {
  final detail, index;

  const TeacherClassDetail({Key key, this.detail, this.index})
      : super(key: key);

  @override
  _TeacherClassDetailState createState() => _TeacherClassDetailState();
}

class _TeacherClassDetailState extends State<TeacherClassDetail>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
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
    //List about class informations
    final List content = [
      ["Sınıf Adı", "class", Icons.paste_outlined],
      ["Mevcut", "totalStudent", Icons.reduce_capacity],
      ["Sınıf Kodu", "classCode", Icons.code],
      ["Oluşturma Tarihi", "date", Icons.date_range],
      ["Ders Programı", "lessonPlan", Icons.notes_sharp],
      ["Öğrenciler", "students", Icons.people]
    ];
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      //Appbar
      appBar: CustomAppBar(
        text: "Sınıf Detayı",
        widget: SizedBox(),
      ),
      //Body
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Image
            Container(
              width: size.width * 0.75,
              child: Image.asset("assets/images/detail.jpg"),
            ),
            //Class informations
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: content.length,
              itemBuilder: (context, index) {
                return SlideAnimation(
                  animationController: animationController,
                  itemCount: content.length,
                  position: index,
                  slideDirection: SlideDirection.fromBottom,
                  child: Column(
                    children: [
                      //Content
                      ListTile(
                        leading: Icon(
                          content[index][2],
                          color: secondaryColor,
                        ),
                        title: CustomText(
                          text: content[index][0],
                          color: Colors.black,
                          sizes: TextSize.small,
                        ),
                        trailing: content[index][1] == "students" ||
                                content[index][1] == "lessonPlan"
                            ? Icon(
                                Icons.arrow_forward_ios,
                                color: primaryColor,
                              )
                            : CustomText(
                                text:
                                    widget.detail[content[index][1]].toString(),
                                color: Colors.blue,
                                sizes: TextSize.small,
                              ),
                        onTap: content[index][1] == "students"
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShowStudents(
                                              index: index,
                                              classes: widget.detail,
                                            )));
                              }
                            : content[index][1] == "lessonPlan"
                                ? () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TeacherLessonPlan(
                                                  index: index,
                                                  classes: widget.detail,
                                                )));
                                  }
                                : null,
                      ),
                      Divider(
                        color: Colors.black,
                        indent: 5,
                        endIndent: 5,
                      )
                    ],
                  ),
                );
              },
            ),
            //Edit Button
            SlideAnimation(
              animationController: animationController,
              itemCount: content.length,
              position: 0,
              slideDirection: SlideDirection.fromBottom,
              child: Container(
                width: size.width * 0.9,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(secondaryColor),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeacherEditClass(
                                    className: widget.detail["class"],
                                    classCode: widget.detail["classCode"],
                                    totalStudent: widget.detail["totalStudent"],
                                    email: widget.detail["email"],
                                    uid: widget.detail.id,
                                  )));
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                          color: Colors.white,
                          sizes: TextSize.small,
                          text: "Düzenle",
                        ),
                      ),
                    )),
              ),
            ),
            //Delete Button
            SlideAnimation(
              animationController: animationController,
              itemCount: content.length,
              position: 0,
              slideDirection: SlideDirection.fromBottom,
              child: Container(
                width: size.width * 0.9,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    onPressed: () {
                      //dialog
                      CustomDialog().secondDialog(
                          context, "Silmek istediğinize emin misiniz?",
                          //if user choose yes
                          () async {
                        await FirebaseFirestore.instance
                            .runTransaction((Transaction myTransaction) async {
                          await myTransaction.delete(widget.detail.reference);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "${widget.detail["class"].toString()} sınıfı kaldırıldı.")));

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => TeacherHomePage()),
                            (Route<dynamic> route) => false);
                      },
                          //if user choose no
                          () {
                        Navigator.pop(context);
                      });
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                          color: Colors.white,
                          sizes: TextSize.small,
                          text: widget.detail["class"] + " Sınıfını Sil",
                        ),
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
