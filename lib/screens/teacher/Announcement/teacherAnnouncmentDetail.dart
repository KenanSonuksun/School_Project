import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customDialogs.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/screens/teacher/HomePage/teacherHomePage.dart';

class TeacherAnnouncmentDetail extends StatelessWidget {
  final announcment, uid, email, classesProvider;

  const TeacherAnnouncmentDetail(
      {Key key, this.announcment, this.uid, this.email, this.classesProvider})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        //Appbar
        appBar: CustomAppBar(
          text: "Duyuru Detay",
          widget: SizedBox(),
        ),
        //Body
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                width: size.width * 0.95,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //announcement datails
                      ListTile(
                        leading: Icon(
                          Icons.date_range,
                          color: secondaryColor,
                        ),
                        title: CustomText(
                          text: "Oluşturulma Tarihi : ",
                          sizes: TextSize.small,
                          color: Colors.black,
                        ),
                        trailing: CustomText(
                          text: announcment["date"],
                          sizes: TextSize.small,
                          color: Colors.blue,
                        ),
                      ),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                        color: primaryColor,
                      ),
                      //announcement content
                      ListTile(
                        leading: Icon(Icons.description, color: secondaryColor),
                        title: Text(
                          announcment["announcement"],
                          maxLines: 10,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),

                      //a button to delete
                      Container(
                        width: size.width * 0.9,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                            onPressed: () {
                              CustomDialog().secondDialog(
                                  context, "Silmek istediğinize emin misiniz?",
                                  () async {
                                await FirebaseFirestore.instance
                                    .collection(email)
                                    .doc(uid)
                                    .update({
                                  "announcements": FieldValue.arrayRemove([
                                    {
                                      "announcement":
                                          announcment["announcement"],
                                      "date": announcment["date"],
                                    }
                                  ])
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Duyuru Kaldırıldı")));

                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TeacherHomePage()),
                                    (Route<dynamic> route) => false);
                              }, () {
                                Navigator.pop(context);
                              });
                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomText(
                                  color: Colors.white,
                                  sizes: TextSize.small,
                                  text: "Duyuruyu Sil",
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
