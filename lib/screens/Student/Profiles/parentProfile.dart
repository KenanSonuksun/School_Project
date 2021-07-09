import 'package:flutter/material.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customText.dart';

class ParentProfile extends StatelessWidget {
  final infoProvider, selectedIndex;
  const ParentProfile({Key key, this.infoProvider, this.selectedIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List info = [
      [
        Icons.person,
        "Ad - Soyad",
        infoProvider.classes[selectedIndex]["students"][0]["parentName"]
      ],
      [
        Icons.phone,
        "Telefon Numarası",
        infoProvider.classes[selectedIndex]["students"][0]["parentPhone"]
      ],
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
