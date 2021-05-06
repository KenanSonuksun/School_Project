import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customDialogs.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/screens/teacher/Announcement/teacherAnnouncement.dart';

class TeacherAnnouncmentDetail extends StatelessWidget {
  final announcment, uid, email;

  const TeacherAnnouncmentDetail(
      {Key key, this.announcment, this.uid, this.email})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        //Appbar
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: primaryColor,
          centerTitle: true,
          title: CustomText(
            color: Colors.white,
            sizes: TextSize.normal,
            text: "Duyuru Detay",
          ),
        ),
        //Body
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //announcement datails
              ListTile(
                leading: CustomText(
                  text: "Oluşturulma Tarihi : ",
                  sizes: TextSize.small,
                  color: Colors.black,
                ),
                trailing: CustomText(
                  text: announcment["tarih"],
                  sizes: TextSize.small,
                  color: Colors.black,
                ),
              ),
              Divider(
                indent: 40,
                endIndent: 40,
                color: Colors.black,
              ),
              //announcement content
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  announcment["duyuru"],
                  maxLines: 10,
                  style: TextStyle(fontSize: 17),
                ),
              ),
              //a button to delete
              Container(
                width: size.width * 0.9,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    onPressed: () {
                      CustomDialog().secondDialog(
                          context, "Silmek istediğinize emin misiniz?",
                          () async {
                        await FirebaseFirestore.instance
                            .collection(email)
                            .doc(uid)
                            .update({
                          "duyurular": FieldValue.arrayRemove([
                            {
                              "duyuru": announcment["duyuru"],
                              "tarih": announcment["tarih"],
                            }
                          ])
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Duyuru Kaldırıldı")));

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => TeacherAnnouncment()),
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
        ));
  }
}
