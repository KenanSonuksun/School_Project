import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/customButton.dart';
import 'package:schoolproject/components/customDialogs.dart';
import 'package:schoolproject/components/customTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../teacherLogin.dart';

class TeacherEditProfile extends StatefulWidget {
  final profile;

  const TeacherEditProfile({Key key, this.profile}) : super(key: key);

  @override
  _TeacherEditProfileState createState() => _TeacherEditProfileState();
}

class _TeacherEditProfileState extends State<TeacherEditProfile> {
  bool isLoaded = false;
  TextEditingController _fullName = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _repassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      //Appbar
      appBar: CustomAppBar(
        text: "Profil Düzenle",
        widget: SizedBox(),
      ),
      //Body
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Image
            Image.asset("assets/images/settings.jpg"),
            //Text fields
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: CustomTextField(
                topPadding: size.height * 0.01,
                controller: _fullName,
                hintText: "İsim-Soyisim",
                suffixIcon: Icon(Icons.person),
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
                controller: _password,
                hintText: "Şifre",
                suffixIcon: Icon(Icons.security),
                readonly: false,
                keyboardType: TextInputType.text,
                obscureText: true,
                onChanged: (String value) {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: CustomTextField(
                topPadding: size.height * 0.01,
                controller: _repassword,
                hintText: "Şifre Tekrar",
                suffixIcon: Icon(Icons.security),
                readonly: false,
                keyboardType: TextInputType.text,
                obscureText: true,
                onChanged: (String value) {},
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            //A button to edit
            CustomButton(
              onpressed: () async {
                if (_fullName.text.isEmpty ||
                    _password.text.isEmpty ||
                    _repassword.text.isEmpty) {
                  CustomDialog().firstDialog(context,
                      "Lütfen boş alan bırakmayınız", Icons.close, Colors.red);
                } else if (_repassword.text != _password.text) {
                  CustomDialog().firstDialog(
                      context, "Şifreler aynı değil", Icons.close, Colors.red);
                } else {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  //change full name in firebase
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(prefs.getString("email"))
                      .update({"fullName": _fullName.text});

                  //change password in firebase
                  User user = FirebaseAuth.instance.currentUser;
                  user.updatePassword(_password.text);
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(prefs.getString("email"))
                      .update({"password": _password.text});

                  // if all progresses are done
                  CustomDialog().firstDialog(
                      context,
                      "Değişiklikler başarıyla tamamlandı",
                      Icons.done_outline,
                      Colors.green);
                  prefs.clear();
                  Future.delayed(const Duration(milliseconds: 2000), () {
                    Navigator.pop(context);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => TeacherLogin()),
                        (Route<dynamic> route) => false);
                  });
                }
              },
              text: "Düzenle",
            ),
            //checkForAd()
          ],
        ),
      ),
    );
  }
}
