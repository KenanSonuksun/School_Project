import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolproject/components/customButton.dart';
import 'package:schoolproject/components/customDialogs.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/components/customTextField.dart';
import 'package:schoolproject/providers/classesProvider.dart';
import 'package:schoolproject/providers/validationSignup.dart';
import 'package:schoolproject/service/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentSignup extends StatefulWidget {
  @override
  _StudentSignupState createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final teacherEmail = TextEditingController();
  final classCode = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  final parentFullName = TextEditingController();
  final parentPhone = TextEditingController();
  String repsw = "";
  bool codeChecking = false;
  Animation fadeAnim;
  int index = 0;
  bool loading = true;
  bool error = false;
  AnimationController animationController;

  //A function for firebase progress
  Future<void> _signUpUser(
      String email, String password, BuildContext context) async {
    FirebaseService _currentUser =
        Provider.of<FirebaseService>(context, listen: false);

    try {
      if (await _currentUser.signUp(email, password)) {
        //if everything is done user have to verify email to sign in

        //and this dialog is information about that
        CustomDialog().bigDialog(
            context,
            "Maililnize gönderilen doğrulamayı yaptıktan sonra giriş yapabilirisinz",
            () {},
            Colors.green);
        //after 5 seconds go previous page
        Future.delayed(const Duration(milliseconds: 5000), () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      } else {
        //sigin up is failed
        CustomDialog()
            .firstDialog(context, "Kayıt başarısız", Icons.close, Colors.red);
      }
    } catch (e) {
      print(e);
    }
  }

  //check class code
  checkEmail(ClassesProvider classesProvider, classCode) {
    for (int i = 0; i < classesProvider.classes.length; i++) {
      if (classesProvider.classes[i]["classCode"] == classCode) {
        setState(() {
          codeChecking = true;
          index = i;
        });
      }
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
    teacherEmail.dispose();
    classCode.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    parentFullName.dispose();
    parentPhone.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
      body: Center(
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
                                style:
                                    TextStyle(color: CupertinoColors.systemRed),
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
                                style:
                                    TextStyle(color: CupertinoColors.systemRed),
                              ),
                            ),
                          )
                        : SizedBox(),
                    //Text field for teacher email
                    CustomTextField(
                        topPadding: size.height * 0.01,
                        controller: teacherEmail,
                        hintText: "Öğretmen Mailini Giriniz",
                        suffixIcon:
                            Icon(CupertinoIcons.chevron_up_chevron_down),
                        readonly: false,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        onChanged: (String value) {
                          validationProvider.changeEmail(value);
                        }),
                    //Text field for Class code
                    CustomTextField(
                        topPadding: size.height * 0.01,
                        controller: classCode,
                        hintText: "Sınıf Kodunu Giriniz",
                        suffixIcon:
                            Icon(CupertinoIcons.chevron_up_chevron_down),
                        readonly: false,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        onChanged: (String value) {
                          validationProvider.changeEmail(value);
                        }),
                    //Parent Full Name
                    CustomTextField(
                        topPadding: size.height * 0.01,
                        controller: parentFullName,
                        hintText: "Veli Ad - Soyad",
                        suffixIcon: Icon(CupertinoIcons.person),
                        readonly: false,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        onChanged: (String value) {
                          validationProvider.changeFullName(value);
                        }),
                    //Parent Phone Number
                    CustomTextField(
                        topPadding: size.height * 0.01,
                        controller: parentPhone,
                        hintText: "Veli Telefon Numarası",
                        suffixIcon: Icon(CupertinoIcons.person),
                        readonly: false,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        onChanged: (String value) {
                          validationProvider.changeFullName(value);
                        }),
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
                                style:
                                    TextStyle(color: CupertinoColors.systemRed),
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
                                style:
                                    TextStyle(color: CupertinoColors.systemRed),
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
                      onpressed: () async {
                        final classesProvider = Provider.of<ClassesProvider>(
                            context,
                            listen: false);
                        classesProvider.getData(teacherEmail.text);
                        if (classesProvider.error) {
                          setState(() {
                            error = true;
                          });
                        }
                        checkEmail(classesProvider, classCode.text);
                        if (validationProvider.isValid &&
                            passwordController.text ==
                                rePasswordController.text &&
                            emailController.text.isNotEmpty &&
                            nameController.text.isNotEmpty &&
                            teacherEmail.text.isNotEmpty &&
                            passwordController.text.isNotEmpty &&
                            rePasswordController.text.isNotEmpty &&
                            parentFullName.text.isNotEmpty &&
                            parentPhone.text.isNotEmpty &&
                            !error) {
                          //Check Class code that there is or not
                          if (codeChecking) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString("index", index.toString());
                            prefs.setString("studentEmail", teacherEmail.text);
                            //progress in firebase
                            await FirebaseFirestore.instance
                                .collection(teacherEmail.text)
                                .doc(classesProvider.classes[index].id
                                    .toString())
                                .update({
                              "students": FieldValue.arrayUnion([
                                {
                                  "fullName": nameController.text,
                                  "email": emailController.text,
                                  "password": passwordController.text,
                                  "parentName": parentFullName.text,
                                  "parentPhone": parentPhone.text
                                }
                              ])
                            });
                            //signup service
                            _signUpUser(emailController.text,
                                passwordController.text, context);
                          } else {
                            CustomDialog().firstDialog(
                                context,
                                "Girdiğiniz Sınıf Kodu Eşleşmiyor",
                                Icons.close,
                                Colors.red);
                          }
                        } else {
                          CustomDialog().firstDialog(context, "Kayıt başarısız",
                              Icons.close, Colors.red);
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
    );
  }
}
