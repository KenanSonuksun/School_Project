import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customDialogs.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/screens/teacher/HomePage/teacherHomePage.dart';
import 'package:schoolproject/screens/teacher/LessonPlan/teacherLessonPlan.dart';
import 'package:schoolproject/screens/teacher/classDetails/teacherEditClass.dart';

class TeacherClassDetail extends StatefulWidget {
  final detail, index;

  const TeacherClassDetail({Key key, this.detail, this.index})
      : super(key: key);
  @override
  _TeacherClassDetailState createState() => _TeacherClassDetailState();
}

class _TeacherClassDetailState extends State<TeacherClassDetail> {
  //For loading screen before home screen
  bool isLoading = true;
  void startTimer() {
    Timer.periodic(const Duration(seconds: 2), (t) {
      setState(() {
        isLoading = false; //set loading to false
      });
      t.cancel(); //stops the timer
    });
  }

  //List about class informations
  List detail = [
    ["Sınıf Adı", "sınıf", Icons.paste_outlined],
    ["Mevcut", "mevcut", Icons.reduce_capacity],
    ["Sınıf Kodu", "sınıfKodu", Icons.code],
    ["Oluşturma Tarihi", "date", Icons.date_range],
    ["Ders Programı", "lessonPlan", Icons.notes_sharp],
    ["Öğrenciler", "students", Icons.people]
  ];

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            //Appbar
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: primaryColor,
              centerTitle: true,
              title: CustomText(
                color: Colors.white,
                sizes: TextSize.normal,
                text: "Sınıf Detayı",
              ),
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
                  Container(
                    height: size.height * 0.53,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: detail.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                detail[index][2],
                                color: secondaryColor,
                              ),
                              title: CustomText(
                                text: detail[index][0],
                                color: Colors.black,
                                sizes: TextSize.small,
                              ),
                              trailing: detail[index][1] == "students" ||
                                      detail[index][1] == "lessonPlan"
                                  ? Icon(
                                      Icons.arrow_forward_ios,
                                      color: primaryColor,
                                    )
                                  : CustomText(
                                      text: widget.detail[detail[index][1]]
                                          .toString(),
                                      color: Colors.blue,
                                      sizes: TextSize.small,
                                    ),
                              onTap: detail[index][1] == "students"
                                  ? () {}
                                  : detail[index][1] == "lessonPlan"
                                      ? () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TeacherLessonPlan(
                                                          index:
                                                              widget.index)));
                                        }
                                      : null,
                            ),
                            Divider(
                              color: Colors.black,
                              indent: 5,
                              endIndent: 5,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  //Edit Button
                  Container(
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
                                        sinif: widget.detail["sınıf"],
                                        sinifKodu: widget.detail["sınıfKodu"],
                                        mevcut: widget.detail["mevcut"],
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
                  //Delete Button
                  Container(
                    width: size.width * 0.9,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        onPressed: () {
                          //dialog
                          CustomDialog().secondDialog(
                              context, "Silmek istediğinize emin misiniz?",
                              //if user choose yes
                              () async {
                            await FirebaseFirestore.instance.runTransaction(
                                (Transaction myTransaction) async {
                              await myTransaction
                                  .delete(widget.detail.reference);
                            });

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "${widget.detail["sınıf"].toString()} sınıfı kaldırıldı.")));

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
                              text: widget.detail["sınıf"] + " Sınıfını Sil",
                            ),
                          ),
                        )),
                  )
                ],
              ),
            ),
          );
  }
}
