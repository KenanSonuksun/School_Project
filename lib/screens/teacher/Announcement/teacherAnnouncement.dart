import 'package:flutter/material.dart';
import 'package:schoolproject/components/animation.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/components/noData.dart';
import 'package:schoolproject/screens/teacher/Announcement/teacherAnnouncmentDetail.dart';
import 'package:schoolproject/screens/teacher/Announcement/teacherAddAnnouncement.dart';

class TeacherAnnouncment extends StatefulWidget {
  final classesProvider;
  final bool noData;

  const TeacherAnnouncment({Key key, this.classesProvider, this.noData})
      : super(key: key);
  @override
  _TeacherAnnouncmentState createState() => _TeacherAnnouncmentState();
}

class _TeacherAnnouncmentState extends State<TeacherAnnouncment>
    with SingleTickerProviderStateMixin {
  List<String> values = [];
  String dropdownValue;
  int count = 0;
  String email;
  AnimationController animationController;
  //Get data from firebase
  void getData() async {
    for (int i = 0; i < widget.classesProvider.classes.length; i++) {
      setState(() {
        values.add(widget.classesProvider.classes[i]["class"].toString());
        dropdownValue = values[0];
      });
    }
  }

  @override
  void initState() {
    getData();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    //FindClassName().setClassName(widget.classesProvider.classes[0]["sınıf"]);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      //Appbar
      appBar: CustomAppBar(
        text: "Duyurular",
        widget: SizedBox(),
      ),

      //Body
      body: widget.noData
          ? NoData(
              text: "Kayıtlı Sınıf Bulunmamaktadır",
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //header
                  ListTile(
                    tileColor: Colors.grey[200],
                    leading: CustomText(
                      color: Colors.black,
                      sizes: TextSize.normal,
                      text: "Sınıf Seçiniz : ",
                    ),
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
                          for (int i = 0;
                              i < widget.classesProvider.classes.length;
                              i++) {
                            if (widget.classesProvider.classes[i]["class"] ==
                                dropdownValue) {
                              count = i;
                            }
                          }
                        });
                      },
                      items:
                          values.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomText(
                                text: value,
                                color: Colors.black,
                                sizes: TextSize.normal,
                              )),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  //announcments
                  widget.classesProvider.classes[count]["announcements"]
                              .length ==
                          0
                      ? NoData(
                          text:
                              "Seçtiğiniz sınıfa ait herhangi bir duyuru kaydı bulunmamaktadır.",
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.classesProvider.classes[count]
                                        ["announcements"] ==
                                    null
                                ? 0
                                : widget.classesProvider
                                    .classes[count]["announcements"].length,
                            itemBuilder: (context, index) {
                              return SlideAnimation(
                                animationController: animationController,
                                itemCount: widget.classesProvider
                                    .classes[count]["announcements"].length,
                                position: index,
                                slideDirection: SlideDirection.fromBottom,
                                child: RawMaterialButton(
                                  //onPressed to see announcement details
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TeacherAnnouncmentDetail(
                                                    classesProvider:
                                                        widget.classesProvider,
                                                    announcment: widget
                                                                .classesProvider
                                                                .classes[count]
                                                            ["announcements"]
                                                        [index],
                                                    email: widget
                                                            .classesProvider
                                                            .classes[count]
                                                        ["email"],
                                                    uid: widget.classesProvider
                                                        .classes[count].id
                                                        .toString())));
                                  },
                                  //announcement
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        //announcement details
                                        ListTile(
                                            leading: Icon(Icons.date_range,
                                                color: secondaryColor),
                                            title: CustomText(
                                              text: widget
                                                  .classesProvider
                                                  .classes[count]
                                                      ["announcements"][index]
                                                      ["date"]
                                                  .toString(),
                                              color: Colors.blue,
                                              sizes: TextSize.small,
                                            )),
                                        Divider(
                                          color: primaryColor,
                                          endIndent: 20,
                                          indent: 20,
                                        ),
                                        //announcement content
                                        ListTile(
                                          leading: Icon(
                                            Icons.description,
                                            color: secondaryColor,
                                          ),
                                          title: CustomText(
                                              text: widget.classesProvider
                                                          .classes[count]
                                                      ["announcements"][index]
                                                  ["announcement"],
                                              color: Colors.black,
                                              sizes: TextSize.normal),
                                        ),
                                      ],
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
      //A button to add a new announcment
      floatingActionButton: widget.noData
          ? SizedBox()
          : Container(
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
                                classes: widget.classesProvider,
                              )));
                },
              ),
            ),
    );
  }
}
