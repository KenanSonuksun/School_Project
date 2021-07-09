import 'package:flutter/material.dart';
import 'package:schoolproject/Components/findClassName.dart';
import 'package:schoolproject/components/appbar.dart';
import 'package:schoolproject/components/dropDown.dart';

class TeacherAddAnnouncment extends StatefulWidget {
  final classes;

  const TeacherAddAnnouncment({Key key, this.classes}) : super(key: key);
  @override
  _TeacherAddAnnouncmentState createState() => _TeacherAddAnnouncmentState();
}

class _TeacherAddAnnouncmentState extends State<TeacherAddAnnouncment> {
  List<String> values = [];
  TextEditingController _announcment = TextEditingController();
  @override
  void initState() {
    //Create an array which array has class name
    if (widget.classes != null) {
      for (int i = 0; i < widget.classes.classes.length; i++) {
        setState(() {
          values.add(widget.classes.classes[i]["class"].toString());
        });
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      //Appbar
      appBar: CustomAppBar(
        text: "Duyuru Ekle",
        widget: SizedBox(),
      ),
      //Body
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Image
            Image.asset(
              "assets/images/announcment.jpg",
            ),
            //Text Form Field for announcement
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: TextFormField(
                maxLines: 10,
                style: TextStyle(
                    color: Colors.black, fontSize: size.width > 500 ? 25 : 17),
                controller: _announcment,
                obscureText: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[700]),
                    gapPadding: 10,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[700]),
                    gapPadding: 10,
                  ),
                  hintText: "Duyuru yazınız.....",
                  hintStyle: TextStyle(color: Colors.grey),
                  labelStyle: TextStyle(color: Colors.grey),
                  helperStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
            //Components
            DropDownMenu(
              values: values,
              anouncementController: _announcment.text,
              classes: widget.classes,
            ),
          ],
        ),
      ),
    );
  }
}
