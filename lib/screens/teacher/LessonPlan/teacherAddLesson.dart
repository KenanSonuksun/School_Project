import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customButton.dart';
import 'package:schoolproject/components/customDialogs.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/components/customTextField.dart';
import 'package:schoolproject/screens/teacher/HomePage/teacherHomePage.dart';
import 'package:intl/intl.dart';

class TeacherAddLesson extends StatefulWidget {
  final int index;
  final classInformation;

  const TeacherAddLesson({Key key, this.classInformation, this.index})
      : super(key: key);
  @override
  _TeacherAddLessonState createState() => _TeacherAddLessonState();
}

class _TeacherAddLessonState extends State<TeacherAddLesson> {
  TextEditingController _lessonName = TextEditingController();
  DateTime date = DateTime.now();
  bool didChoose = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      //Appbar
      appBar: CustomAppBar(
        text: "Ders Programı Ekle",
        widget: SizedBox(),
      ),
      //Body
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Image
            Image.asset("assets/images/lessonplan.jpg"),
            //Text field for lesson name
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: CustomTextField(
                topPadding: size.height * 0.027,
                controller: _lessonName,
                hintText: "Ders adını giriniz",
                suffixIcon: Icon(Icons.class_),
                readonly: false,
                keyboardType: TextInputType.text,
                obscureText: false,
                onChanged: (String value) {},
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            //Choose date for lesson
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Container(
                height: size.height * 0.08,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: ListTile(
                    leading: CustomText(
                      color: Colors.grey,
                      sizes: TextSize.normal,
                      text: didChoose
                          ? date.toString().substring(0, 16)
                          : "Ders saatini seçiniz",
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: primaryColor,
                    ),
                    onTap: () {
                      _showDatePicker(context);
                    },
                  ),
                ),
              ),
            ),
            //A button to submit
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: CustomButton(
                onpressed: () async {
                  if (_lessonName.text.isNotEmpty && didChoose) {
                    //progress in firebase
                    await FirebaseFirestore.instance
                        .collection(widget.classInformation["email"].toString())
                        .doc(widget.classInformation.id.toString())
                        .update({
                      "lessonPlan": FieldValue.arrayUnion([
                        {
                          "lesson": _lessonName.text,
                          "date": date.toString().substring(0, 16),
                          "dateName": (DateFormat('EEEE').format(date))
                        }
                      ])
                    });
                    //dialog
                    CustomDialog().firstDialog(
                        context,
                        "Ders başarıyla eklendi",
                        Icons.done_outline,
                        Colors.green);
                    //push TeacherLessonPage after 2 seconds
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => TeacherHomePage()),
                          (Route<dynamic> route) => false);
                    });
                  } else {
                    CustomDialog().firstDialog(
                        context,
                        "Lütfen boş alan bırakmayınız",
                        Icons.close,
                        Colors.red);
                  }
                },
                text: "Kaydet",
              ),
            ),
          ],
        ),
      ),
    );
  }

//date picker function
  void _showDatePicker(ctx) async {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: MediaQuery.of(context).size.width > 500
                  ? MediaQuery.of(context).size.height * 0.35
                  : MediaQuery.of(context).size.width < 390
                      ? MediaQuery.of(context).size.height * 0.65
                      : MediaQuery.of(context).size.height * 0.44,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 300,
                    child: CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (val) {
                          setState(() {
                            date = val;
                          });
                        }),
                  ),
                  CustomButton(
                    text: "Seç",
                    onpressed: () {
                      setState(() {
                        didChoose = true;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ));
  }
}
