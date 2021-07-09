import 'package:flutter/material.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customText.dart';

class StudentClass extends StatelessWidget {
  final infoProvider, selectedIndex;
  const StudentClass({Key key, this.infoProvider, this.selectedIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "Sınıfım",
        widget: SizedBox(),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: infoProvider.classes[selectedIndex]["students"].length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: secondaryColor,
                ),
                trailing: CustomText(
                  color: Colors.black,
                  sizes: TextSize.normal,
                  text: infoProvider.classes[selectedIndex]["students"][index]
                      ["fullName"],
                ),
              ),
              Divider(
                indent: 20,
                endIndent: 20,
                color: secondaryColor,
              )
            ],
          );
        },
      ),
    );
  }
}
