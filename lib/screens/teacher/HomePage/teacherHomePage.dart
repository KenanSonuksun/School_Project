import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customDialogs.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/components/customTextField.dart';
import 'package:schoolproject/components/noData.dart';
import 'package:schoolproject/providers/classesProvider.dart';
import 'package:schoolproject/providers/profileProvider.dart';
import 'package:schoolproject/screens/teacher/HomeWorks/teacherHomework.dart';
import 'package:schoolproject/screens/teacher/AddClass/teacherAddClass.dart';
import 'package:schoolproject/screens/teacher/Announcement/teacherAnnouncement.dart';
import 'package:schoolproject/screens/teacher/Profile/teacherProfile.dart';
import 'package:schoolproject/screens/teacher/classDetails/teacherClassDetail.dart';
import 'package:schoolproject/screens/teacher/teacherLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherHomePage extends StatefulWidget {
  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  TextEditingController _search = TextEditingController();
  String email;
  ClassesProvider classesProvider;
  ProfileProvider profileProvider;
  List searchResult = [];

  //Get data with this function
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString("email");
    });
    classesProvider = Provider.of<ClassesProvider>(context, listen: false);
    classesProvider.getData(email);
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.getProfil(email);
  }

  //loading screen before home screen
  bool isLoading = true;
  void startTimer() {
    Timer.periodic(const Duration(seconds: 2), (t) {
      setState(() {
        isLoading = false; //set loading to false
      });
      t.cancel(); //stops the timer
    });
  }

  @override
  void initState() {
    getData();
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final className = Provider.of<ClassesProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    //Menu for drawer menu
    List menu = [
      [
        "Duyuru Sistemi",
        Icons.announcement,
        () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TeacherAnnouncment()));
        }
      ],
      [
        "Ödev Sistemi",
        Icons.menu_book_rounded,
        () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TeacherHomeWork()));
        }
      ],
      ["Öğrenci Sistemi", Icons.people, () {}],
      [
        "Profilim",
        Icons.person,
        () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TeacherProfile(profile: profileProvider, email: email)));
        }
      ],
      [
        "Çıkış Yap",
        Icons.exit_to_app,
        () {
          _onBackPressed();
        }
      ],
    ];

    Size size = MediaQuery.of(context).size;

    return isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : className.classes == null && profileProvider.profile == null
            ? Scaffold(body: Center(child: NoData()))
            : Scaffold(
                //Drawer Menu
                drawer: Drawer(
                  child: Column(
                    children: [
                      UserAccountsDrawerHeader(
                        accountName: CustomText(
                          color: Colors.white,
                          sizes: TextSize.big,
                          text: profileProvider.profile["fullName"],
                        ),
                        accountEmail: CustomText(
                          color: Colors.white,
                          sizes: TextSize.small,
                          text: profileProvider.profile["email"].toString(),
                        ),
                        currentAccountPicture: new CircleAvatar(
                          backgroundColor: Colors.white,
                          child: new Text(
                            profileProvider.profile["fullName"]
                                .toString()
                                .characters
                                .first,
                            style: TextStyle(color: Colors.black, fontSize: 25),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: menu.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                new ListTile(
                                  title: CustomText(
                                      text: menu[index][0],
                                      color: Colors.black,
                                      sizes: TextSize.small),
                                  trailing: new Icon(
                                    menu[index][1],
                                    color: secondaryColor,
                                    size: 25,
                                  ),
                                  onTap: menu[index][2],
                                ),
                                Divider(),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                //Appbar
                appBar: AppBar(
                  iconTheme: IconThemeData(color: Colors.white),
                  backgroundColor: primaryColor,
                  centerTitle: true,
                  title: CustomText(
                    color: Colors.white,
                    sizes: TextSize.normal,
                    text: "Anasayfa",
                  ),
                ),
                //Body
                body: WillPopScope(
                  onWillPop: _onBackPressed,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //Search Bar
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: CustomTextField(
                            topPadding: size.height * 0.01,
                            controller: _search,
                            hintText: "Ara",
                            suffixIcon: Icon(Icons.search),
                            readonly: false,
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            height: 1,
                          ),
                        ),
                        //Class List
                        Container(
                          height: size.height,
                          child: ListView.builder(
                            itemCount: className.classes == null
                                ? 0
                                : className.classes.length,
                            itemBuilder: (context, index) {
                              return className.classes[index]["sınıf"] == null
                                  ? Center(
                                      child: NoData(),
                                    )
                                  : Dismissible(
                                      direction: DismissDirection.startToEnd,
                                      key: Key(className.classes.toString()),
                                      //Dismissible background
                                      background: Container(
                                          alignment: Alignment.centerLeft,
                                          color: Colors.red,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          )),
                                      //What do you want after swiping
                                      onDismissed: (direction) async {
                                        //progress in firebase
                                        await FirebaseFirestore.instance
                                            .runTransaction((Transaction
                                                myTransaction) async {
                                          await myTransaction.delete(className
                                              .classes[index].reference);
                                        });
                                        //snackbar
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "${className.classes[index]["sınıf"].toString()} sınıfı kaldırıldı.")));
                                      },
                                      child:
                                          //List tile for classes
                                          ListTile(
                                        leading: Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: secondaryColor,
                                        ),
                                        title: CustomText(
                                          text: className.classes[index]
                                                  ["sınıf"]
                                              .toString(),
                                          color: Colors.black,
                                          sizes: TextSize.small,
                                        ),
                                        subtitle: Text("Sınıf Kodu : " +
                                            className.classes[index]
                                                    ["sınıfKodu"]
                                                .toString()),
                                        trailing: Container(
                                          width: 130,
                                          padding: EdgeInsets.only(right: 10),
                                          height: size.height * 0.04,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TeacherClassDetail(
                                                              detail: className
                                                                      .classes[
                                                                  index],
                                                              index: index)));
                                            },
                                            child: Center(
                                              child: Text("Detay"),
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      secondaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //A button to add class
                floatingActionButton: Container(
                  height: size.width * 0.15,
                  width: size.width * 0.15,
                  child: FloatingActionButton(
                    backgroundColor: secondaryColor,
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeacherAddClass()));
                    },
                  ),
                ),
              );
  }

  //for onBackPress
  Future<bool> _onBackPressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CustomDialog()
        .secondDialog(context, "Çıkış yapmak istediğinize emin misiniz?", () {
      prefs.clear();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => TeacherLogin()),
          (Route<dynamic> route) => false);
    }, () {
      Navigator.pop(context);
    });
  }
}
