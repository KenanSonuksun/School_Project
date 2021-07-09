import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/customButton.dart';
import 'package:schoolproject/components/customDialogs.dart';
import 'package:schoolproject/components/customTextField.dart';
import 'package:schoolproject/screens/teacher/HomePage/teacherHomePage.dart';

class TeacherEditClass extends StatefulWidget {
  final className, classCode, totalStudent, email, uid;

  const TeacherEditClass(
      {Key key,
      this.className,
      this.classCode,
      this.totalStudent,
      this.email,
      this.uid})
      : super(key: key);

  @override
  _TeacherEditClassState createState() => _TeacherEditClassState();
}

class _TeacherEditClassState extends State<TeacherEditClass> {
  TextEditingController _class = TextEditingController();
  TextEditingController _totalStudent = TextEditingController();
  TextEditingController _classCode = TextEditingController();

  @override
  void initState() {
    _class.text = widget.className.toString();
    _totalStudent.text = widget.totalStudent.toString();
    _classCode.text = widget.classCode.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        //Apbar
        appBar: CustomAppBar(
          text: "Sınıf Düzenle",
          widget: SizedBox(),
        ),
        //Body
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Image
                Image.asset("assets/images/settings.jpg"),
                //Text fields
                CustomTextField(
                  topPadding: size.height * 0.027,
                  controller: _class,
                  hintText: "Sınıf Adı",
                  suffixIcon: Icon(Icons.school),
                  readonly: false,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  onChanged: (String value) {},
                ),
                CustomTextField(
                  topPadding: size.height * 0.01,
                  controller: _totalStudent,
                  hintText: "Sınıf Mevcut",
                  suffixIcon: Icon(Icons.people),
                  readonly: false,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  onChanged: (String value) {},
                ),
                CustomTextField(
                  topPadding: size.height * 0.01,
                  controller: _classCode,
                  hintText: "Sınıf Kodu",
                  suffixIcon: Icon(Icons.code),
                  readonly: false,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  onChanged: (String value) {},
                ),
                SizedBox(
                  height: 30,
                ),
                //Button
                CustomButton(
                  onpressed: () {
                    if (_class.text.isNotEmpty &&
                        _classCode.text.isNotEmpty &&
                        _totalStudent.text.isNotEmpty) {
                      FirebaseFirestore.instance
                          .collection(widget.email)
                          .doc(widget.uid)
                          .update({
                        "totalStudent": _totalStudent.text,
                        "class": _class.text,
                        "classCode": _classCode.text
                      });

                      CustomDialog().firstDialog(
                          context,
                          "Güncelleme işlemi tamamlandı.",
                          Icons.done_outline,
                          Colors.green);
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
              ],
            ),
          ),
        ));
  }
}
