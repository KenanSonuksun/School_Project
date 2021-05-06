import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customButton.dart';
import 'package:schoolproject/components/customDialogs.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/components/customTextField.dart';
import 'package:schoolproject/screens/teacher/HomePage/teacherHomePage.dart';
import 'package:intl/intl.dart';

class TeacherAddClass extends StatefulWidget {
  @override
  _TeacherAddClassState createState() => _TeacherAddClassState();
}

class _TeacherAddClassState extends State<TeacherAddClass> {
  TextEditingController _classNumber = TextEditingController();
  TextEditingController _className = TextEditingController();
  TextEditingController _classCode = TextEditingController();
  TextEditingController _totalStudent = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //Appbar
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        centerTitle: true,
        title: CustomText(
          color: Colors.white,
          sizes: TextSize.normal,
          text: "Sınıf Ekle",
        ),
      ),
      //Body
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Image
              Container(
                  width: size.width * 0.7,
                  height: size.width * 0.7,
                  child: Image.asset("assets/images/add.jpg")),
              //Text fields
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: CustomTextField(
                  topPadding: size.height * 0.01,
                  controller: _classNumber,
                  hintText: "Sınıf (Örnek : 4)",
                  suffixIcon: Icon(Icons.class_),
                  readonly: false,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  onChanged: (String value) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: CustomTextField(
                  topPadding: size.height * 0.01,
                  controller: _className,
                  hintText: "Şube (Örnek : A)",
                  suffixIcon: Icon(Icons.workspaces_filled),
                  readonly: false,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  onChanged: (String value) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: CustomTextField(
                  topPadding: size.height * 0.01,
                  controller: _classCode,
                  hintText: "Sınıf Kodu",
                  suffixIcon: Icon(Icons.code),
                  readonly: false,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  onChanged: (String value) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: CustomTextField(
                  topPadding: size.height * 0.01,
                  controller: _totalStudent,
                  hintText: "Mevcut",
                  suffixIcon: Icon(Icons.people),
                  readonly: false,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  onChanged: (String value) {},
                ),
              ),
              //Button
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: CustomButton(
                  onpressed: () {
                    //Check text fields to continue
                    if (_classNumber.text.length > 1 ||
                        _classNumber.text.isEmpty) {
                      CustomDialog().firstDialog(
                          context,
                          "Lütfen sınıfı doğru şekilde giriniz. Örnek : 4",
                          Icons.close,
                          Colors.black);
                    } else if (_className.text.length > 1 ||
                        _className.text.isEmpty) {
                      CustomDialog().firstDialog(
                          context,
                          "Lütfen şubeyi doğru şekilde giriniz. Örnek : A",
                          Icons.close,
                          Colors.black);
                    } else if (_classCode.text.length < 4 ||
                        _classCode.text.isEmpty) {
                      CustomDialog().firstDialog(
                          context,
                          "En az 4 karakter içeren bir sınıf kodu giriniz",
                          Icons.close,
                          Colors.black);
                    } else if (_totalStudent.text.isEmpty) {
                      CustomDialog().firstDialog(
                          context,
                          "Lütfen bir sınıf mevcut giriniz",
                          Icons.close,
                          Colors.black);
                    }
                    //if all text fields are correct,
                    else {
                      //progress in firebase
                      DateTime now = DateTime.now();
                      String formattedDate =
                          DateFormat('yyyy-MM-dd – kk:mm').format(now);
                      User firebaseUser = _auth.currentUser;
                      String _uid = firebaseUser.uid;
                      String _email = firebaseUser.email;
                      FirebaseFirestore.instance.collection(_email).doc().set({
                        "sınıfKodu": _classCode.text,
                        "mevcut": _totalStudent.text,
                        "sınıf": "${_classNumber.text}-${_className.text}",
                        "uId": _uid,
                        "email": _email,
                        "date": formattedDate,
                        "students": [],
                        "duyurular": [],
                        "lessonPlan": []
                      });
                      //dialog
                      CustomDialog().firstDialog(context, "Kayıt başarılı",
                          Icons.done_outline, Colors.green);
                      //push Home Page after 2 seconds
                      Future.delayed(const Duration(milliseconds: 2000), () {
                        Navigator.pop(context);
                        _classNumber.clear();
                        _className.clear();
                        _classCode.clear();
                        _totalStudent.clear();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => TeacherHomePage()),
                            (Route<dynamic> route) => false);
                      });
                    }
                  },
                  text: "Ekle",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
