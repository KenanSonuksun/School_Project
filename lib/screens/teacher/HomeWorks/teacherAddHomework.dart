import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customButton.dart';
import 'package:schoolproject/components/customDialogs.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/screens/teacher/HomePage/teacherHomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherAddHomework extends StatefulWidget {
  final classes, index, email;

  const TeacherAddHomework({Key key, this.classes, this.index, this.email})
      : super(key: key);
  @override
  _TeacherAddHomeworkState createState() => _TeacherAddHomeworkState();
}

class _TeacherAddHomeworkState extends State<TeacherAddHomework> {
  TextEditingController _desc = TextEditingController();
  bool more = false;
  String url, email;
  DateTime date = DateTime.now();
  DateTime date2 = DateTime.now();
  bool didChoose = false;

  //Get Email
  getEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      email = pref.getString("email");
    });
  }

  @override
  void initState() {
    getEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        //Appbar
        appBar: CustomAppBar(
          text: "Ödev Ekle",
          widget: SizedBox(),
        ),
        //Body
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Image
                Image.asset(
                  "assets/images/addHomework.jpg",
                  height: 250,
                ),
                //Description for homework
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                    maxLines: 5,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: size.width > 500 ? 25 : 17),
                    controller: _desc,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[700]),
                        gapPadding: 10,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[700]),
                        gapPadding: 10,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[700]),
                        gapPadding: 10,
                      ),
                      hintText: "Ödev açıklaması giriniz...",
                      hintStyle: TextStyle(color: Colors.grey),
                      labelStyle: TextStyle(color: Colors.grey),
                      helperStyle: TextStyle(color: Colors.black),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                //A date picker for delivery date
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
                          sizes: TextSize.small,
                          text: didChoose
                              ? date.toString().substring(0, 10)
                              : "Teslim Tarihi Seçiniz",
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
                SizedBox(
                  height: size.height * 0.02,
                ),
                //Upload Image or Show image
                Container(
                  width: size.width * 0.93,
                  height: size.height * 0.11,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: url != null
                      //if there are any selected images
                      ? Container(
                          width: size.width * 0.25,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Image.network(
                              url,
                              height: 120,
                            ),
                          ),
                        )
                      //if there are not any selected images
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.add_a_photo_outlined,
                                    color: secondaryColor,
                                    size: 40,
                                  ),
                                  onPressed: () => uploadImage(-1, email)),
                              CustomText(
                                text: "Resim eklemek için ikona tıklayınız",
                                color: Colors.grey,
                                sizes: TextSize.small,
                              ),
                            ],
                          ),
                        ),
                ),
                SizedBox(height: size.height * 0.02),
                //A button for adding to firebase
                CustomButton(
                  onpressed: () async {
                    if (_desc.text.isNotEmpty && didChoose) {
                      await FirebaseFirestore.instance
                          .collection(email)
                          .doc(widget.classes[widget.index].id.toString())
                          .update({
                        "homeworks": FieldValue.arrayUnion([
                          {
                            "url": url,
                            "desc": _desc.text == null
                                ? "No Description"
                                : _desc.text,
                            "dateNow": date2.toString().substring(0, 10),
                            "delivery": date.toString().substring(0, 10)
                          }
                        ])
                      });
                      //A dialog
                      CustomDialog().firstDialog(
                          context,
                          "Ödev başarıyla eklenmiştir.",
                          Icons.done_outline,
                          Colors.green);
                      //After a second back to homework page
                      Future.delayed(Duration(seconds: 1), () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => TeacherHomePage()),
                            (Route<dynamic> route) => false);
                      });
                    } else {
                      //Warning dialog
                      CustomDialog().firstDialog(
                          context,
                          "Lütfen açıklama ve teslim tarihi kısmını boş bırakmayınız",
                          Icons.close,
                          Colors.red);
                    }
                  },
                  text: "Ekle",
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
              ],
            ),
          ),
        ));
  }

  //Upload Image
  uploadImage(int index, String email) async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    //Chechk Permission
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);

      if (image != null) {
        //Upload to firebase storage
        var snapshot = await _storage
            .ref()
            .child("folderName/${index.toString()}")
            .putFile(file)
            .whenComplete(() => print("uploading is compeleted"));

        var downloadUrl = await snapshot.ref.getDownloadURL();
        print(downloadUrl.toString());
        setState(() {
          url = downloadUrl;
        });
      } else {
        print("No Path Received");
      }
    } else {
      print("Grant Permission and try again");
    }
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
                        mode: CupertinoDatePickerMode.date,
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
