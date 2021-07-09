import 'package:flutter/material.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/buildLinearIndicator.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customText.dart';

class ShowStudents extends StatelessWidget {
  final index, classes;
  const ShowStudents({Key key, this.index, this.classes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: CustomAppBar(
          text: "Öğrenciler",
          widget: SizedBox(),
        ),
        body: ListView.builder(
          itemCount: classes["students"].length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: size.width * 0.9,
                decoration: BoxDecoration(
                    color: greyBackground,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Student Name
                    ListTile(
                      leading: Icon(
                        Icons.person,
                        color: secondaryColor,
                      ),
                      title: CustomText(
                        color: Colors.black,
                        sizes: TextSize.normal,
                        text: "Öğrenci Ad - Soyad",
                      ),
                      trailing: CustomText(
                        color: Colors.blue,
                        sizes: TextSize.small,
                        text: classes["students"][index]["fullName"],
                      ),
                    ),
                    //Parent Name
                    ListTile(
                      leading: Icon(
                        Icons.contact_mail,
                        color: secondaryColor,
                      ),
                      title: CustomText(
                        color: Colors.black,
                        sizes: TextSize.normal,
                        text: "Veli Ad - Soyad",
                      ),
                      trailing: CustomText(
                        color: Colors.blue,
                        sizes: TextSize.small,
                        text: classes["students"][index]["parentName"],
                      ),
                    ),
                    //Parnet Phone Number
                    ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: secondaryColor,
                      ),
                      title: CustomText(
                        color: Colors.black,
                        sizes: TextSize.normal,
                        text: "Veli Telefon Numarası",
                      ),
                      trailing: CustomText(
                        color: Colors.blue,
                        sizes: TextSize.small,
                        text: classes["students"][index]["parentPhone"],
                      ),
                    ),
                    Divider(
                      indent: 20,
                      endIndent: 20,
                      color: secondaryColor,
                    ),
                    //Indıcators
                    Center(
                      child: CustomText(
                        color: primaryColor,
                        sizes: TextSize.title,
                        text: "Ödev Yapımı",
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BuildLinearIndicator(
                        percent: 0.6,
                        text: Text("%60"),
                        widget: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CustomText(
                            color: Colors.black,
                            sizes: TextSize.normal,
                            text: "Haftalık",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BuildLinearIndicator(
                        percent: 0.8,
                        text: Text("%80"),
                        widget: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CustomText(
                            color: Colors.black,
                            sizes: TextSize.normal,
                            text: "Toplam",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
