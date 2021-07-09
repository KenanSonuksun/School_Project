import 'package:flutter/material.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/homeworkContainer.dart';
import 'package:schoolproject/components/noData.dart';

class TeacherShowHomeworks extends StatelessWidget {
  final classes, selectedIndex, email;

  const TeacherShowHomeworks(
      {Key key, this.classes, this.selectedIndex, this.email})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Appbar
      appBar: CustomAppBar(
        text: "${classes[selectedIndex]["class"]} Ödev Listesi",
        widget: SizedBox(),
      ),
      //Body
      body: classes[selectedIndex]["homeworks"].length == 0
          ? NoData(
              text:
                  "Seçtiğiniz sınıfa ait herhangi bir ödev kaydı bulunmamaktadır.",
            )
          : ListView.builder(
              itemCount: classes[selectedIndex]["homeworks"].length,
              itemBuilder: (context, index) {
                return HomeWorkContainer(
                  dateOfissue: classes[selectedIndex]["homeworks"][index]
                          ["dateNow"]
                      .toString()
                      .substring(0, 10),
                  deliveryDate: classes[selectedIndex]["homeworks"][index]
                          ["delivery"]
                      .toString(),
                  desc: classes[selectedIndex]["homeworks"][index]["desc"]
                      .toString(),
                  imgUrl:
                      classes[selectedIndex]["homeworks"][index]["url"] == null
                          ? null
                          : classes[selectedIndex]["homeworks"][index]["url"]
                              .toString(),
                  email: email,
                  uid: classes[selectedIndex].id,
                );
              },
            ),
    );
  }
}
