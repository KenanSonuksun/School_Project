import 'package:flutter/material.dart';
import 'package:schoolproject/components/animation.dart';
import 'package:schoolproject/components/buildCircleIndicator.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/components/gridView.dart';
import 'package:schoolproject/components/notificationContainer.dart';
import 'package:schoolproject/screens/student/Announcement/studentAnnouncement.dart';
import 'package:schoolproject/screens/student/HomeWorks/studentHomeworks.dart';
import 'package:schoolproject/screens/student/Profiles/parentProfile.dart';
import 'package:schoolproject/screens/student/Profiles/studentProfile.dart';

class Page1 extends StatefulWidget {
  final infoProvider, selectedIndex;
  const Page1({Key key, this.infoProvider, this.selectedIndex})
      : super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: SlideAnimation(
          animationController: animationController,
          itemCount: 1,
          position: 0,
          slideDirection: SlideDirection.fromBottom,
          child: Column(
            children: [
              //Notificitaion area for Announcements
              widget.infoProvider.classes[widget.selectedIndex]["announcements"]
                          .length ==
                      0
                  ? SizedBox()
                  : NotificationContainer(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentAnnouncement(
                                      infoProvider: widget.infoProvider,
                                      selectedIndex: widget.selectedIndex,
                                    )));
                      },
                      text:
                          "${widget.infoProvider.classes[widget.selectedIndex]["announcements"].length.toString()} yeni duyurunuz var.",
                    ),
              //Notification area for Homeworks
              widget.infoProvider.classes[widget.selectedIndex]["homeworks"]
                          .length ==
                      0
                  ? SizedBox()
                  : NotificationContainer(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentHomeworks(
                                    infoProvider: widget.infoProvider,
                                    selectedIndex: widget.selectedIndex)));
                      },
                      text:
                          "${widget.infoProvider.classes[widget.selectedIndex]["homeworks"].length.toString()} yeni ödeviniz var.",
                    ),
              //Announcements and Homeworks
              BuildGridView(info: [
                [
                  "assets/icons/announcementIcon.png",
                  "Duyurular",
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentAnnouncement(
                                  infoProvider: widget.infoProvider,
                                  selectedIndex: widget.selectedIndex,
                                )));
                  }
                ],
                [
                  "assets/icons/homeworkIcon.png",
                  "Ödevler",
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentHomeworks(
                                  infoProvider: widget.infoProvider,
                                  selectedIndex: widget.selectedIndex,
                                )));
                  }
                ],
              ]),
              //Indicator
              const SizedBox(
                height: 2,
              ),
              Container(
                width: size.width * 0.96,
                height: size.height * 0.23,
                decoration: BoxDecoration(
                    color: greyBackground,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        //Title
                        Center(
                          child: CustomText(
                            color: Colors.black,
                            sizes: TextSize.title,
                            text: "Ödev Tamamla Oranları",
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        //Indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            BuildCircularIndicator(
                              centerText: "%60",
                              percent: 0.6,
                              text: "Haftalık",
                            ),
                            BuildCircularIndicator(
                              centerText: "%80",
                              percent: 0.8,
                              text: "Toplam",
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
              const SizedBox(
                height: 2,
              ),
              //Profile and Parents
              BuildGridView(
                info: [
                  [
                    "assets/icons/profileIcon.png",
                    "Öğrenci",
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentProfile(
                                    infoProvider: widget.infoProvider,
                                    selectedIndex: widget.selectedIndex,
                                  )));
                    }
                  ],
                  [
                    "assets/icons/parentsIcon.png",
                    "Veli",
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ParentProfile(
                                    infoProvider: widget.infoProvider,
                                    selectedIndex: widget.selectedIndex,
                                  )));
                    }
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
