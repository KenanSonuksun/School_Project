import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/customButton.dart';
import 'package:schoolproject/components/customDialogs.dart';
import 'package:schoolproject/components/customTextField.dart';
import 'package:schoolproject/screens/teacher/HomePage/teacherHomePage.dart';
import 'package:intl/intl.dart';

class TeacherAddClass extends StatefulWidget {
  final data;

  const TeacherAddClass({Key key, this.data}) : super(key: key);

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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      //Appbar
      appBar: CustomAppBar(
        text: "Sınıf Ekle",
        widget: SizedBox(),
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
              //A button to add
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: CustomButton(
                  onpressed: () {
                    int done = 0;
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
                    //check class code and finish
                    else {
                      //check that any class has this class code or not
                      for (int i = 0; i < widget.data.length; i++) {
                        if (_classCode.text ==
                            widget.data[i]["classCode"].toString()) {
                          done++;
                        }
                      }
                      //if all things are correct
                      if (done == 0) {
                        //progress in firebase
                        DateTime now = DateTime.now();
                        String formattedDate =
                            DateFormat('yyyy-MM-dd – kk:mm').format(now);
                        User firebaseUser = _auth.currentUser;
                        String _uid = firebaseUser.uid;
                        String _email = firebaseUser.email;
                        FirebaseFirestore.instance
                            .collection(_email)
                            .doc()
                            .set({
                          "classCode": _classCode.text,
                          "totalStudent": _totalStudent.text,
                          "class":
                              "${_classNumber.text}-${_className.text.toUpperCase()}",
                          "uId": _uid,
                          "email": _email,
                          "date": formattedDate,
                          "students": [],
                          "announcements": [],
                          "lessonPlan": [],
                          "homeworks": [],
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
                      //if this class code has been used
                      else {
                        CustomDialog().firstDialog(
                            context,
                            "Farklı bir sınıf kodu giriniz",
                            Icons.close,
                            Colors.red);
                      }
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
