import 'package:flutter/material.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customText.dart';

class StudentAnnouncement extends StatelessWidget {
  final infoProvider, selectedIndex;
  const StudentAnnouncement({Key key, this.infoProvider, this.selectedIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        text: "Duyurular",
        widget: SizedBox(),
      ),
      body: ListView.builder(
        itemCount: infoProvider.classes[selectedIndex]["announcements"].length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: size.width * 0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: greyBackground),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.date_range,
                      color: secondaryColor,
                    ),
                    title: CustomText(
                      sizes: TextSize.small,
                      color: Colors.black,
                      text: infoProvider.classes[selectedIndex]["announcements"]
                          [index]["date"],
                    ),
                  ),
                  Divider(
                    indent: 20,
                    endIndent: 20,
                    color: secondaryColor,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.description,
                      color: secondaryColor,
                    ),
                    title: CustomText(
                      sizes: TextSize.small,
                      color: Colors.black,
                      text: infoProvider.classes[selectedIndex]["announcements"]
                          [index]["announcement"],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
