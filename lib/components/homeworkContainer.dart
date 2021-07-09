import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/screens/teacher/HomePage/teacherHomePage.dart';
import 'customDialogs.dart';

class HomeWorkContainer extends StatefulWidget {
  final dateOfissue, deliveryDate, desc, imgUrl, email, uid;

  const HomeWorkContainer(
      {Key key,
      this.dateOfissue,
      this.deliveryDate,
      this.desc,
      this.imgUrl,
      this.email,
      this.uid})
      : super(key: key);

  @override
  _HomeWorkContainerState createState() => _HomeWorkContainerState();
}

class _HomeWorkContainerState extends State<HomeWorkContainer> {
  bool isLoading = true;

  //A loading page
  void _startTimer() {
    Timer.periodic(const Duration(seconds: 5), (t) {
      setState(() {
        isLoading = false;
      });
      t.cancel();
    });
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: size.width * 0.9,
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Date of issue
            ListTile(
                leading: Icon(
                  Icons.date_range,
                  color: secondaryColor,
                ),
                title: CustomText(
                  color: Colors.black,
                  sizes: TextSize.small,
                  text: "Verilme Tarihi",
                ),
                trailing: CustomText(
                  color: Colors.blue,
                  sizes: TextSize.small,
                  text: widget.dateOfissue,
                )),
            //Delivery date
            ListTile(
              leading: Icon(
                Icons.timelapse_rounded,
                color: secondaryColor,
              ),
              title: CustomText(
                color: Colors.black,
                sizes: TextSize.small,
                text: "Teslilm Tarihi",
              ),
              trailing: CustomText(
                color: Colors.blue,
                sizes: TextSize.small,
                text: widget.deliveryDate,
              ),
            ),
            //Description
            ListTile(
              leading: Icon(
                Icons.plagiarism_rounded,
                color: secondaryColor,
              ),
              title: CustomText(
                color: Colors.black,
                sizes: TextSize.small,
                text: widget.desc,
              ),
            ),
            //Image
            widget.imgUrl != null
                ? !isLoading
                    ? Container(
                        width: 150,
                        height: 150,
                        child: Image.network(widget.imgUrl),
                      )
                    : const Center(child: const CircularProgressIndicator())
                : SizedBox(),
            widget.imgUrl != null
                ? const SizedBox(
                    height: 20,
                  )
                : const SizedBox(),
            //A button to delete
            Container(
              width: size.width * 0.8,
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection(widget.email)
                      .doc(widget.uid)
                      .update({
                    "homeworks": FieldValue.arrayRemove([
                      {
                        "dateNow": widget.dateOfissue,
                        "delivery": widget.deliveryDate,
                        "desc": widget.desc,
                        "url": widget.imgUrl
                      }
                    ])
                  });
                  //A dialog
                  CustomDialog().firstDialog(
                      context,
                      "Ödev başarıyla silinmiştir.",
                      Icons.done_outline,
                      Colors.green);
                  //After a second back to homework page
                  Future.delayed(Duration(seconds: 1), () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => TeacherHomePage()),
                        (Route<dynamic> route) => false);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(
                    color: Colors.white,
                    sizes: TextSize.normal,
                    text: "Ödevi kaldır",
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
