import 'package:flutter/material.dart';
import 'package:schoolproject/components/animation.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customDialogs.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/screens/student/Class/studentClass.dart';
import 'package:schoolproject/screens/student/TeacherContact/teacherContact.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../SplashScreen/splashPage.dart';

class Page3 extends StatefulWidget {
  final infoProvider, selectedIndex, profileProvider;
  const Page3(
      {Key key, this.infoProvider, this.selectedIndex, this.profileProvider})
      : super(key: key);

  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> with SingleTickerProviderStateMixin {
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

    final List content = [
      [
        Icons.contact_phone,
        "Öğretmen İletişim",
        () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TeacherContact(profileProvider: widget.profileProvider)));
        }
      ],
      [
        Icons.people,
        "Sınıf",
        () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StudentClass(
                      infoProvider: widget.infoProvider,
                      selectedIndex: widget.selectedIndex)));
        }
      ],
      [Icons.settings, "Ayarlar", () {}],
      [
        Icons.logout,
        "Çıkış Yap",
        () {
          _onBackPressed();
        }
      ],
    ];
    return ListView.builder(
      shrinkWrap: true,
      itemCount: content.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            SlideAnimation(
              animationController: animationController,
              itemCount: content.length,
              position: index,
              slideDirection: SlideDirection.fromBottom,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  width: size.width * 0.95,
                  decoration: BoxDecoration(
                      color: greyBackground,
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: Icon(
                      content[index][0],
                      color: secondaryColor,
                    ),
                    title: CustomText(
                      color: Colors.black,
                      sizes: TextSize.normal,
                      text: content[index][1],
                    ),
                    onTap: content[index][2],
                    trailing: Icon(
                      Icons.arrow_right,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
