import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolproject/components/customButton.dart';
import 'package:schoolproject/components/customDialogs.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/components/customTextField.dart';
import 'package:schoolproject/providers/validationLogin.dart';
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
        CustomDialog()
            .firstDialog(context, "Giriş başarısız", Icons.close, Colors.red);
      }
    } catch (e) {
      print(e);
    }
  }

  //Get email with SharedPreferences
  getEmail() async {
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
    Size size = MediaQuery.of(context).size;
    final validationProvider = Provider.of<LoginValidation>(context);
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
                      Image.asset("assets/images/login.jpg"),
                      //Text field for email
                      CustomTextField(
                          topPadding: size.height * 0.02,
                          controller: emailController,
                          hintText: "Email",
                          suffixIcon: Icon(CupertinoIcons.mail),
                          readonly: false,
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          onChanged: (String value) {
                            validationProvider.changeEmail(value);
                          }),
                      //for validation warning
                      validationProvider.email.error != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  validationProvider.email.error ?? "",
                                  style: TextStyle(
                                      color: CupertinoColors.systemRed),
                                ),
                              ),
                            )
                          : SizedBox(),
                      //Text field for password
                      CustomTextField(
                          topPadding: size.height * 0.01,
                          controller: passwordController,
                          hintText: "Şifre",
                          suffixIcon: Icon(CupertinoIcons.lock),
                          readonly: false,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          onChanged: (String value) {
                            validationProvider.changePassword(value);
                          }),
                      //for validation warning
                      validationProvider.password.error != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  validationProvider.password.error ?? "",
                                  style: TextStyle(
                                      color: CupertinoColors.systemRed),
                                ),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      //A button to sign in
                      CustomButton(
                        text: "Giriş Yap",
                        onpressed: () async {
                          if (validationProvider.isValid &&
                              emailController.text.isNotEmpty &&
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
