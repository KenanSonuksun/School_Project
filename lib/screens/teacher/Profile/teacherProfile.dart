import 'package:flutter/material.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customButton.dart';
import 'package:schoolproject/screens/teacher/Profile/teacherEditProfile.dart';

class TeacherProfile extends StatelessWidget {
  final profile, email;

  const TeacherProfile({Key key, this.profile, this.email}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    //List for person information
    List info = [
      [Icons.person, "Ad-Soyad", profile.profile["fullName"]],
      [Icons.mail, "Email", profile.profile["email"]],
      [Icons.security, "Şifre", profile.profile["password"]]
    ];
    return Scaffold(
      //Appbar
      appBar: CustomAppBar(
        text: "Profil",
        widget: SizedBox(),
      ),
      //Body
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.02,
            ),
            //Image
            Image.asset(
              "assets/images/profile.jpg",
              height: 300,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            //Infromtaion texts
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: info.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        info[index][0],
                        color: secondaryColor,
                      ),
                      title: Text(info[index][1]),
                      trailing: info[index][1] == "Şifre"
                          ? Text("******")
                          : Text(info[index][2].toString()),
                    ),
                    Divider(
                      indent: 20,
                      endIndent: 20,
                      color: primaryColor,
                    )
                  ],
                );
              },
            ),
            //A button to edit
            CustomButton(
              onpressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TeacherEditProfile(
                              profile: profile.profile,
                            )));
              },
              text: "Düzenle",
            ),
          ],
        ),
      ),
    );
  }
}
