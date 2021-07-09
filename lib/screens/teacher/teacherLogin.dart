import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolproject/components/customButton.dart';
import 'package:schoolproject/components/customDialogs.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/components/customTextField.dart';
import 'package:schoolproject/screens/teacher/HomePage/teacherHomePage.dart';
import 'package:schoolproject/screens/teacher/teacherSignup.dart';
import 'package:schoolproject/service/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherLogin extends StatefulWidget {
  @override
  _TeacherLoginState createState() => _TeacherLoginState();
}

class _TeacherLoginState extends State<TeacherLogin>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String repsw = "";
  Animation fadeAnim;
  AnimationController animationController;

  //A function for firebase progress
  Future<void> _signInUser(
      String email, String password, BuildContext context) async {
    FirebaseService _currentUser =
        Provider.of<FirebaseService>(context, listen: false);

    try {
      if (await _currentUser.logIn(email, password)) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TeacherHomePage()));
      } else {
        CustomDialog().bigDialog(context,
            "Giriş başarısız. Emailinizi,şifrenizi kontrol edin ve email doğrulaması yaptığınızdan emin olun",
            () {
          Navigator.pop(context);
        }, Colors.red);
      }
    } catch (e) {
      print(e);
    }
  }

  //Get email with SharedPreferences
  void getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", emailController.text);
  }

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    fadeAnim = new CurvedAnimation(
      parent: animationController,
      curve: new Interval(
        0.100,
        0.200,
        curve: Curves.easeIn,
      ),
    );
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      //Appbar
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 1,
            title: CustomText(
              color: Colors.black,
              sizes: TextSize.normal,
              text: "Giriş",
            ),
          )),
      //Body
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: FadeTransition(
              //for animation
              opacity: fadeAnim,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //Image
                      Image.asset(
                        "assets/images/login.jpg",
                        height: 300,
                      ),
                      //Text field for email
                      CustomTextField(
                          key: Key("loginEmail"),
                          topPadding: size.height * 0.02,
                          controller: emailController,
                          hintText: "Email",
                          suffixIcon: Icon(CupertinoIcons.mail),
                          readonly: false,
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          onChanged: (String value) {}),
                      //Text field for password
                      CustomTextField(
                          key: Key("loginPass"),
                          topPadding: size.height * 0.01,
                          controller: passwordController,
                          hintText: "Şifre",
                          suffixIcon: Icon(CupertinoIcons.lock),
                          readonly: false,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          onChanged: (String value) {}),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      //A button to sign in
                      CustomButton(
                        key: Key("loginButton"),
                        text: "Giriş Yap",
                        onpressed: () async {
                          if (emailController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty) {
                            _signInUser(emailController.text,
                                passwordController.text, context);
                          } else {
                            CustomDialog().firstDialog(context,
                                "Giriş başarısız", Icons.close, Colors.red);
                          }
                          getEmail();
                        },
                      ),
                      //Do not you have an account text
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TeacherSignup()));
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: 'Hesabınız Yok mu ? Hemen ',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: size.width > 500 ? 25 : 17),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Kayıt Olun',
                                      style: TextStyle(
                                        color: Color(0xFFFF7643),
                                      ))
                                ]),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
