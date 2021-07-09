import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolproject/components/animation.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customDialogs.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/components/noData.dart';
import 'package:schoolproject/providers/classesProvider.dart';
import 'package:schoolproject/providers/profileProvider.dart';
import 'package:schoolproject/screens/SplashScreen/splashPage.dart';
import 'package:schoolproject/screens/teacher/HomeWorks/teacherHomework.dart';
import 'package:schoolproject/screens/teacher/AddClass/teacherAddClass.dart';
import 'package:schoolproject/screens/teacher/Announcement/teacherAnnouncement.dart';
import 'package:schoolproject/screens/teacher/Profile/teacherProfile.dart';
import 'package:schoolproject/screens/teacher/classDetails/teacherClassDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherHomePage extends StatefulWidget {
  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage>
    with SingleTickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  String email;
  List _searchResult = [];
  AnimationController animationController;

  //Get data with this function
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString("email");
    });
    final classesProvider =
        Provider.of<ClassesProvider>(context, listen: false);
    classesProvider.getData(email);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.getProfil(email);
  }

  //Search
  _search(String text, ClassesProvider classesProvider) {
    _searchResult.clear();

    for (int i = 0; i < classesProvider.classes.length; i++) {
      if (classesProvider.classes[i]["class"].contains(text.toUpperCase())) {
        setState(() {
          _searchResult.add(classesProvider.classes[i]);
        });
      }
    }
  }

  @override
  void initState() {
    getData();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ClassesProvider classesProvider = Provider.of<ClassesProvider>(context);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    //Menu for drawer menu
    final List menu = [
      [
        "Duyuru Sistemi",
        Icons.announcement,
        () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TeacherAnnouncment(
                        classesProvider: classesProvider,
                        noData:
                            classesProvider.classes.length == 0 ? true : false,
                      )));
        }
      ],
      [
        "Ödev Sistemi",
        Icons.menu_book_rounded,
        () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TeacherHomeWork(
                        classesProvider: classesProvider,
                      )));
        }
      ],
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
        },
      ],
    ];
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      //Drawer Menu
      drawer: Drawer(
        child: profileProvider.profile == null
            ? SizedBox()
            : Column(
                children: [
                  //Header
                  UserAccountsDrawerHeader(
                    accountName: CustomText(
                      color: Colors.white,
                      sizes: TextSize.normal,
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
                  ListView.builder(
                    shrinkWrap: true,
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
                ],
              ),
      ),
      //Appbar
      appBar: CustomAppBar(
        text: "Anasayfa",
        widget: SizedBox(),
      ),
      //Body
      body: classesProvider.loading || profileProvider.loading
          ? Scaffold(
              body: const Center(child: const CircularProgressIndicator()))
          : classesProvider.error || profileProvider.error
              ? NoData(
                  text:
                      "Veri bulunamadı. Kayıtlı sınıf olduğundan emin olun ve internet bağlantınızı kontrol ediniz.",
                )
              : WillPopScope(
                  onWillPop: _onBackPressed,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //Search Bar
                        Padding(
                            padding: const EdgeInsets.all(15),
                            child: TextFormField(
                                controller: _searchController,
                                onChanged: _search(
                                    _searchController.text, classesProvider),
                                //textStyle
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.width > 500 ? 25 : 17),
                                keyboardType: TextInputType.text,
                                //decoration
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 20),
                                  suffixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Colors.grey[700]),
                                    gapPadding: 10,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Colors.grey[700]),
                                    gapPadding: 10,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Colors.grey[700]),
                                    gapPadding: 10,
                                  ),
                                  hintText: "Sınıf ara",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelStyle: TextStyle(color: Colors.grey),
                                  helperStyle: TextStyle(color: Colors.black),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ))),
                        //Class List
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: classesProvider.classes == null
                              ? 0
                              : _searchResult.length != 0
                                  ? _searchResult.length
                                  : classesProvider.classes.length,
                          itemBuilder: (context, index) {
                            return SlideAnimation(
                                animationController: animationController,
                                itemCount: classesProvider.classes.length,
                                position: index,
                                slideDirection: SlideDirection.fromLeft,
                                child: Dismissible(
                                    direction: DismissDirection.startToEnd,
                                    key:
                                        Key(classesProvider.classes.toString()),
                                    //Dismissible background
                                    background: Container(
                                        alignment: Alignment.centerLeft,
                                        color: Colors.red,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        )),
                                    //What do you want after swiping
                                    onDismissed: (direction) async {
                                      //dialog
                                      CustomDialog().secondDialog(context,
                                          "Silmek istediğinize emin misiniz?",
                                          //if user choose yes
                                          () async {
                                        await FirebaseFirestore.instance
                                            .runTransaction((Transaction
                                                myTransaction) async {
                                          await myTransaction.delete(
                                              classesProvider
                                                  .classes[index].reference);
                                        });

                                        //snackbar
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "${classesProvider.classes[index]["class"].toString()} sınıfı kaldırıldı.")));
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            TeacherHomePage()),
                                                (Route<dynamic> route) =>
                                                    false);
                                      },
                                          //if user choose no
                                          () {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            TeacherHomePage()),
                                                (Route<dynamic> route) =>
                                                    false);
                                      });
                                    },
                                    //List of all classes
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: secondaryColor,
                                      ),
                                      title: CustomText(
                                        text: _searchResult[index]["class"]
                                            .toString(),
                                        color: Colors.black,
                                        sizes: TextSize.small,
                                      ),
                                      subtitle: Text("Sınıf Kodu : " +
                                          _searchResult[index]["classCode"]
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
                                                            detail:
                                                                _searchResult[
                                                                    index],
                                                            index: index)));
                                          },
                                          child: Center(
                                            child: CustomText(
                                              color: secondaryColor,
                                              sizes: TextSize.small,
                                              text: "Detay",
                                            ),
                                          ),
                                          style: ButtonStyle(
                                            side: MaterialStateProperty.all(
                                                BorderSide(
                                                    color: secondaryColor)),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )));
                          },
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
                    builder: (context) => TeacherAddClass(
                          data: classesProvider.classes,
                        )));
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
          MaterialPageRoute(builder: (context) => SplashPage()),
          (Route<dynamic> route) => false);
    }, () {
      Navigator.pop(context);
    });
  }
}
