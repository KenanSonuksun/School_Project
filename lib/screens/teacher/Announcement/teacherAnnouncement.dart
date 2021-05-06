import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/providers/classesProvider.dart';
import 'package:schoolproject/screens/teacher/Announcement/teacherAnnouncmentDetail.dart';
import 'package:schoolproject/screens/teacher/Announcement/teacherAddAnnouncement.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../HomePage/teacherHomePage.dart';

class TeacherAnnouncment extends StatefulWidget {
  @override
  _TeacherAnnouncmentState createState() => _TeacherAnnouncmentState();
}

class _TeacherAnnouncmentState extends State<TeacherAnnouncment> {
  List<String> values = [];
  String dropdownValue;
  int count = 0;
  String email;
  ClassesProvider classesProvider;
  //Get data from firebase
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString("email");
    });
    classesProvider = Provider.of<ClassesProvider>(context, listen: false);
    classesProvider.getData(email);
    for (int i = 0; i < classesProvider.classes.length; i++) {
      setState(() {
        values.add(classesProvider.classes[i]["sınıf"].toString());
        dropdownValue = values[0];
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final className = Provider.of<ClassesProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //Appbar
      appBar: AppBar(
        backwardsCompatibility: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => TeacherHomePage()),
                  (Route<dynamic> route) => false);
            }),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        centerTitle: true,
        title: CustomText(
          color: Colors.white,
          sizes: TextSize.normal,
          text: "Duyurular",
        ),
      ),
      //Body
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: CustomText(
                color: Colors.black,
                sizes: TextSize.normal,
                text: "Sınıf Seçiniz : ",
              ),
              //dropdown menu
              trailing: DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: size.width > 428 ? 35 : 24,
                elevation: size.width > 428 ? 25 : 16,
                style: TextStyle(color: Colors.black),
                underline: Container(height: 2, color: secondaryColor),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                    for (int i = 0; i < className.classes.length; i++) {
                      if (className.classes[i]["sınıf"] == dropdownValue) {
                        count = i;
                      }
                    }
                  });
                },
                items: values.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        value,
                        style: TextStyle(fontSize: size.width > 500 ? 30 : 20),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            //announcments
            Container(
              width: size.width * 0.95,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: className.classes[count]["duyurular"] == null
                    ? 0
                    : className.classes[count]["duyurular"].length,
                itemBuilder: (context, index) {
                  return RawMaterialButton(
                    //onPressed to see announcement details
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeacherAnnouncmentDetail(
                                  announcment: className.classes[count]
                                      ["duyurular"][index],
                                  email: className.classes[count]["email"],
                                  uid:
                                      className.classes[count].id.toString())));
                    },
                    //announcement
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          //announcement details
                          ListTile(
                              leading: CustomText(
                                color: Colors.black,
                                sizes: TextSize.small,
                                text: "Olturma Tarihi : ",
                              ),
                              trailing: CustomText(
                                text: className.classes[count]["duyurular"]
                                        [index]["tarih"]
                                    .toString(),
                                color: Colors.black,
                                sizes: TextSize.small,
                              )),
                          Divider(
                            color: Colors.black,
                            endIndent: 50,
                            indent: 50,
                          ),
                          //announcement content
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomText(
                                  text: className.classes[count]["duyurular"]
                                      [index]["duyuru"],
                                  color: Colors.black,
                                  sizes: TextSize.normal)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      //A button to add a new announcment
      floatingActionButton: Container(
        height: size.width * 0.15,
        width: size.width * 0.15,
        child: FloatingActionButton(
          backgroundColor: secondaryColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TeacherAddAnnouncment(
                          classes: className.classes,
                        )));
          },
        ),
      ),
    );
  }
}
