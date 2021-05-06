import 'package:flutter/material.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customButton.dart';
import 'package:schoolproject/components/customText.dart';

class TeacherProfile extends StatelessWidget {
  final profile, email;

  const TeacherProfile({Key key, this.profile, this.email}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //List for person information
    List info = [
      [Icons.person, "Tam Ad", profile.profile["fullName"]],
      [Icons.mail, "Email", profile.profile["email"]],
      [Icons.security, "Şifre", profile.profile["password"]]
    ];
    return Scaffold(
      //Appbar
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        centerTitle: true,
        title: CustomText(
          color: Colors.white,
          sizes: TextSize.normal,
          text: "Profil",
        ),
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
            Image.asset("assets/images/profile.jpg"),
            SizedBox(
              height: size.height * 0.02,
            ),
            //Infromtaion texts
            Container(
              height: size.height * 0.3,
              child: ListView.builder(
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
            ),
            //A button to edit
            CustomButton(
              onpressed: () {},
              text: "Düzenle",
            ),
          ],
        ),
      ),
    );
  }
}
