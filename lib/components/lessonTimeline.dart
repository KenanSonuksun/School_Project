import 'package:flutter/material.dart';
import 'package:schoolproject/components/consts.dart';

class LessonTimeLine extends StatelessWidget {
  final array;

  const LessonTimeLine({Key key, this.array}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return array.length == 0
        ? Text("")
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(
                  Icons.circle_notifications,
                  color: secondaryColor,
                ),
                title: Text(array[0]["dateName"]),
              ),
              //Content
              Padding(
                padding: const EdgeInsets.only(left: 27.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Line
                    Container(
                      width: 2,
                      height: (array.length) * size.height * 0.12,
                      color: primaryColor,
                    ),
                    //Informations
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      width: size.width * 0.85,
                      height: (array.length) * size.height * 0.1,
                      color: Colors.white,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: array.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    title: Text(array[index]["lesson"]),
                                    subtitle: Text(array[index]["dateName"]),
                                    trailing: Text(
                                      array[index]["date"]
                                          .toString()
                                          .substring(10),
                                      style: TextStyle(color: secondaryColor),
                                    ),
                                  ),
                                ),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
  }
}
