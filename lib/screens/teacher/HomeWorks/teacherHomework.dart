import 'package:flutter/material.dart';
import 'package:schoolproject/components/animation.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/components/noData.dart';
import 'package:schoolproject/providers/classesProvider.dart';
import 'package:schoolproject/screens/teacher/HomeWorks/teacherAddHomework.dart';
import 'package:schoolproject/screens/teacher/HomeWorks/teacherShowHomeworks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherHomeWork extends StatefulWidget {
  final classesProvider;

  const TeacherHomeWork({Key key, this.classesProvider}) : super(key: key);
  @override
  _TeacherHomeWorkState createState() => _TeacherHomeWorkState();
}

class _TeacherHomeWorkState extends State<TeacherHomeWork>
    with SingleTickerProviderStateMixin {
  String email;
  TextEditingController _search = TextEditingController();
  List _searchResult = [];
  int counter = 0;
  AnimationController animationController;

  //Get email
  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString("email");
    });
  }

  //Search
  search(String text, ClassesProvider classesProvider) {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    for (int i = 0; i < classesProvider.classes.length; i++) {
      if (classesProvider.classes[i]["class"].contains(text.toUpperCase())) {
        setState(() {
          _searchResult.add(classesProvider.classes[i]);
          counter = i;
        });
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    getEmail();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      //Appbar
      appBar: CustomAppBar(
        text: "Ödev Sistemi",
        widget: SizedBox(),
      ),
      //Body
      body: widget.classesProvider.loading
          ? const Center(
              child: const CircularProgressIndicator(),
            )
          : widget.classesProvider.error
              ? NoData(
                  text:
                      "Veri bulunamadı.Lütfen kayıtlı sınıf olduğundan emin olunuz ve internet bağlantınızı kontrol ediniz.",
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      //Search
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: TextFormField(
                              controller: _search,
                              onChanged:
                                  search(_search.text, widget.classesProvider),
                              //textStyle
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.width > 500 ? 25 : 17),
                              keyboardType: TextInputType.text,
                              //decoration
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 20),
                                suffixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.grey[700]),
                                  gapPadding: 10,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.grey[700]),
                                  gapPadding: 10,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.grey[700]),
                                  gapPadding: 10,
                                ),
                                hintText: "Sınıf ara",
                                hintStyle: TextStyle(color: Colors.grey),
                                labelStyle: TextStyle(color: Colors.grey),
                                helperStyle: TextStyle(color: Colors.black),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ))),
                      //Class List
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.classesProvider.classes == null
                            ? 0
                            : _searchResult.length != 0
                                ? 1
                                : widget.classesProvider.classes.length,
                        itemBuilder: (context, index) {
                          return widget.classesProvider.classes[index]
                                      ["class"] ==
                                  null
                              ? Center(
                                  child: NoData(),
                                )
                              : //List tiles for classes
                              _searchResult.length != 0
                                  //For searching
                                  ? SlideAnimation(
                                      animationController: animationController,
                                      itemCount:
                                          widget.classesProvider.classes.length,
                                      position: index,
                                      slideDirection: SlideDirection.fromBottom,
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.class_,
                                          color: primaryColor,
                                        ),
                                        title: CustomText(
                                          text: _searchResult[index]["class"]
                                              .toString(),
                                          color: Colors.black,
                                          sizes: TextSize.small,
                                        ),
                                        subtitle: Text("Sınıf Kodu : " +
                                            _searchResult[index]["classCode"]
                                                .toString()),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            //A button to show this class' homeworks
                                            Container(
                                              width: 80,
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              height: size.height * 0.04,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TeacherShowHomeworks(
                                                                  classes: widget
                                                                      .classesProvider
                                                                      .classes,
                                                                  selectedIndex:
                                                                      index,
                                                                  email:
                                                                      email)));
                                                },
                                                child: Center(
                                                  child: Icon(
                                                    Icons
                                                        .remove_red_eye_outlined,
                                                    color: secondaryColor,
                                                  ),
                                                ),
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
                                                    side: MaterialStateProperty
                                                        .all(BorderSide(
                                                            color:
                                                                secondaryColor))),
                                              ),
                                            ),
                                            //A button to add a new homework
                                            Container(
                                              width: 80,
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              height: size.height * 0.04,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TeacherAddHomework(
                                                                  classes: widget
                                                                      .classesProvider
                                                                      .classes,
                                                                  index:
                                                                      index)));
                                                },
                                                child: Center(
                                                  child: Icon(
                                                    Icons.add,
                                                    color: secondaryColor,
                                                  ),
                                                ),
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
                                                    side: MaterialStateProperty
                                                        .all(BorderSide(
                                                            color:
                                                                secondaryColor))),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  //All classes
                                  : SlideAnimation(
                                      animationController: animationController,
                                      itemCount:
                                          widget.classesProvider.classes.length,
                                      position: index,
                                      slideDirection: SlideDirection.fromBottom,
                                      child: ListTile(
                                          leading: Icon(
                                            Icons.class_,
                                            color: primaryColor,
                                          ),
                                          title: CustomText(
                                            text: widget.classesProvider
                                                .classes[index]["class"]
                                                .toString(),
                                            color: Colors.black,
                                            sizes: TextSize.small,
                                          ),
                                          subtitle: Text("Sınıf Kodu : " +
                                              widget.classesProvider
                                                  .classes[index]["classCode"]
                                                  .toString()),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              //A button to show this class' homeworks
                                              Container(
                                                width: 80,
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                height: size.height * 0.04,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                TeacherShowHomeworks(
                                                                    classes: widget
                                                                        .classesProvider
                                                                        .classes,
                                                                    selectedIndex:
                                                                        index,
                                                                    email:
                                                                        email)));
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                        Icons
                                                            .remove_red_eye_outlined,
                                                        color: secondaryColor),
                                                  ),
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                                  Colors.white),
                                                      side: MaterialStateProperty
                                                          .all(BorderSide(
                                                              color:
                                                                  secondaryColor))),
                                                ),
                                              ),
                                              //A button to add a new homework
                                              Container(
                                                width: 80,
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                height: size.height * 0.04,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                TeacherAddHomework(
                                                                    classes: widget
                                                                        .classesProvider
                                                                        .classes,
                                                                    index:
                                                                        index)));
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.add,
                                                      color: secondaryColor,
                                                    ),
                                                  ),
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                                  Colors.white),
                                                      side: MaterialStateProperty
                                                          .all(BorderSide(
                                                              color:
                                                                  secondaryColor))),
                                                ),
                                              ),
                                            ],
                                          )),
                                    );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
