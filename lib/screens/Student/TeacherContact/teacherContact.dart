import 'package:flutter/material.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customText.dart';

class TeacherContact extends StatelessWidget {
  final profileProvider;
  const TeacherContact({Key key, this.profileProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List info = [
      [Icons.person, "Ad-Soyad", profileProvider.profile["fullName"]],
      [Icons.mail, "Email", profileProvider.profile["email"]],
      [Icons.phone, "Telefon Numarası", profileProvider.profile["phoneNumber"]],
    ];
    return Scaffold(
      appBar: CustomAppBar(
        text: "Veli Profil",
        widget: SizedBox(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //image
          Image.asset("assets/images/detail.jpg"),
          //Informations
          ListView.builder(
            shrinkWrap: true,
            itemCount: info.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    leading: Icon(
                      info[index][0],
                      color: secondaryColor,
                    ),
                    title: CustomText(
                      color: Colors.black,
                      sizes: TextSize.normal,
                      text: info[index][1],
                    ),
                    trailing: CustomText(
                      color: Colors.blue,
                      sizes: TextSize.small,
                      text: info[index][2],
                    ),
                  ),
                  Divider(
                    color: secondaryColor,
                    indent: 20,
                    endIndent: 20,
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
