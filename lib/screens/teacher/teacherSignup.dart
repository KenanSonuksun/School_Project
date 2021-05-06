import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolproject/components/customButton.dart';
import 'package:schoolproject/components/customDialogs.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/components/customTextField.dart';
import 'package:schoolproject/providers/validationSignup.dart';
import 'package:schoolproject/service/service.dart';

class TeacherSignup extends StatefulWidget {
  @override
  _TeacherSignupState createState() => _TeacherSignupState();
}

class _TeacherSignupState extends State<TeacherSignup>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  String repsw = "";

  Animation fadeAnim;
  AnimationController animationController;

  //A function for firebase progress
  Future<void> _signUpUser(
      String email, String password, BuildContext context) async {
    FirebaseService _currentUser =
        Provider.of<FirebaseService>(context, listen: false);

    try {
      if (await _currentUser.signUp(email, password)) {
        CustomDialog().firstDialog(
            context, "Kayıt başarılı", Icons.done_outline, Colors.green);

        Future.delayed(const Duration(milliseconds: 1000), () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      } else {
        CustomDialog()
            .firstDialog(context, "Kayıt başarısız", Icons.close, Colors.red);
      }
    } catch (e) {
      print(e);
    }
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
    nameController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final validationProvider = Provider.of<SignupValidation>(context);
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
              text: "Kayıt Ol",
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
                      Image.asset("assets/images/signup.jpg"),
                      //Text field for email
                      CustomTextField(
                          topPadding: size.height * 0.02,
                          controller: emailController,
                          hintText: "E mail",
                          suffixIcon: Icon(CupertinoIcons.mail),
                          readonly: false,
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          onChanged: (String value) {
                            validationProvider.changeEmail(value);
                          }),
                      //warning about validation errors
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
                      //Text field for full name
                      CustomTextField(
                          topPadding: size.height * 0.01,
                          controller: nameController,
                          hintText: "Ad - Soyad",
                          suffixIcon: Icon(CupertinoIcons.person),
                          readonly: false,
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          onChanged: (String value) {
                            validationProvider.changeFullName(value);
                          }),
                      //warning about validation errors
                      validationProvider.fullName.error != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  validationProvider.fullName.error ?? "",
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
                      //warning about validation errors
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
                      //Text field for rePassword
                      CustomTextField(
                        topPadding: size.height * 0.01,
                        controller: rePasswordController,
                        hintText: "Şifre tekrar",
                        suffixIcon: Icon(CupertinoIcons.lock),
                        readonly: false,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        onChanged: (String value) {
                          setState(() {
                            repsw = value;
                          });
                        },
                      ),
                      //check that password and repassword are same
                      repsw != passwordController.text
                          ? Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Şifreler aynı değil",
                                  style: TextStyle(
                                      color: CupertinoColors.systemRed),
                                ),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      //A button to sign up
                      CustomButton(
                        text: "Kayıt Ol",
                        onpressed: () {
                          if (validationProvider.isValid &&
                              passwordController.text ==
                                  rePasswordController.text &&
                              emailController.text.isNotEmpty &&
                              nameController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty &&
                              rePasswordController.text.isNotEmpty) {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(emailController.text)
                                .set({
                              "fullName": nameController.text,
                              "email": emailController.text,
                              "password": passwordController.text
                            });
                            _signUpUser(emailController.text,
                                passwordController.text, context);
                          } else {
                            CustomDialog().firstDialog(context,
                                "Kayıt başarısız", Icons.close, Colors.red);
                          }
                        },
                      ),
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
