import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schoolproject/components/customDialogs.dart';
import 'package:schoolproject/screens/teacher/Announcement/teacherAnnouncement.dart';
import 'consts.dart';
import 'customButton.dart';
import 'customText.dart';

class DropDownMenu extends StatelessWidget {
  final dropdownValue;
  final values;
  final anouncementController;
  final classes;
  const DropDownMenu(
      {Key key,
      this.dropdownValue,
      this.values,
      this.anouncementController,
      this.classes})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    int index = 0;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    String dropdownValue = values[0];
    Size size = MediaQuery.of(context).size;
    return StatefulBuilder(builder: (thisLowerContext, innerSetState) {
      return Column(
        children: [
          //Choose class
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
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
                    dropdownValue = newValue;
                    for (int i = 0; i < classes.length; i++) {
                      if (classes[i]["sınıf"] == dropdownValue) {
                        innerSetState(() {
                          index = i;
                        });
                      }
                    }
                  },
                  items: values.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          value,
                          style:
                              TextStyle(fontSize: size.width > 500 ? 30 : 20),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )),
          SizedBox(
            height: size.height * 0.02,
          ),
          //A button to add
          CustomButton(
            onpressed: () async {
              //progress in firebase
              await FirebaseFirestore.instance
                  .collection(classes[index]["email"].toString())
                  .doc(classes[index].id.toString())
                  .update({
                "duyurular": FieldValue.arrayUnion([
                  {
                    "duyuru": anouncementController,
                    "tarih": formattedDate,
                  }
                ])
              });
              //dialog
              CustomDialog().firstDialog(context, "Duyuru başarıyla eklendi",
                  Icons.done_outline, Colors.green);
              //push Home Page after 2 seconds
              Future.delayed(Duration(seconds: 2), () {
                Navigator.pop(context);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => TeacherAnnouncment()),
                    (Route<dynamic> route) => false);
              });
            },
            text: "Ekle",
          ),
        ],
      );
    });
  }
}
