import 'package:flutter/material.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customButton.dart';
import 'package:schoolproject/components/customText.dart';

class StudentHomeworks extends StatefulWidget {
  final infoProvider, selectedIndex;
  const StudentHomeworks({Key key, this.infoProvider, this.selectedIndex})
      : super(key: key);

  @override
  _StudentHomeworksState createState() => _StudentHomeworksState();
}

class _StudentHomeworksState extends State<StudentHomeworks> {
  List res = [];

  @override
  void initState() {
    for (int i = 0;
        i <
            widget
                .infoProvider.classes[widget.selectedIndex]["homeworks"].length;
        i++) {
      setState(() {
        res.add(false);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        text: "Ödevler",
        widget: SizedBox(),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: widget
            .infoProvider.classes[widget.selectedIndex]["homeworks"].length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: size.width * 0.96,
              height: size.height * 0.4,
              decoration: BoxDecoration(
                  color: greyBackground,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Container(
                  width: size.width * 0.9,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Infromations about homework
                      Container(
                        height: size.height,
                        width: size.width * 0.68,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //Decription about homework
                            ListTile(
                                leading: Icon(
                                  Icons.description,
                                  color: secondaryColor,
                                ),
                                title: CustomText(
                                  color: Colors.black,
                                  sizes: TextSize.small,
                                  text: widget.infoProvider
                                          .classes[widget.selectedIndex]
                                      ["homeworks"][index]["desc"],
                                )),
                            Divider(
                              endIndent: 20,
                              indent: 20,
                              color: secondaryColor,
                            ),
                            //Given date
                            ListTile(
                                leading: Icon(
                                  Icons.date_range,
                                  color: secondaryColor,
                                ),
                                title: CustomText(
                                  color: Colors.black,
                                  sizes: TextSize.small,
                                  text:
                                      "VERİLİŞ TARİHİ : ${widget.infoProvider.classes[widget.selectedIndex]["homeworks"][index]["dateNow"]}",
                                )),
                            Divider(
                              endIndent: 20,
                              indent: 20,
                              color: secondaryColor,
                            ),
                            //Delivery date
                            ListTile(
                                leading: Icon(
                                  Icons.timelapse_sharp,
                                  color: secondaryColor,
                                ),
                                title: CustomText(
                                    color: Colors.black,
                                    sizes: TextSize.small,
                                    text:
                                        "TESLİM TARİHİ : ${widget.infoProvider.classes[widget.selectedIndex]["homeworks"][index]["delivery"]}")),
                            //CheckBox
                            ListTile(
                              leading: CustomText(
                                color: Colors.black,
                                sizes: TextSize.small,
                                text: "Ödev Yapıldı",
                              ),
                              trailing: Checkbox(
                                checkColor: Colors.greenAccent,
                                activeColor: Colors.red,
                                value: res[index],
                                onChanged: (bool value) {
                                  setState(() {
                                    res[index] = value;
                                  });
                                },
                              ),
                            ),
                            //A button to save
                            res[index]
                                ? CustomButton(
                                    onpressed: () {},
                                    text: "Kaydet",
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                      //A image from homework
                      widget.infoProvider.classes[widget.selectedIndex]
                                  ["homeworks"][index]["url"] ==
                              null
                          ? Image.asset(
                              "assets/icons/reading-book.png",
                              height: 80,
                            )
                          : Image.network(
                              widget.infoProvider.classes[widget.selectedIndex]
                                  ["homeworks"][index]["url"],
                              height: 120,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
