import 'package:flutter/material.dart';
import 'package:schoolproject/components/animation.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customButton.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/screens/student/studentLoginPage.dart';
import 'package:schoolproject/screens/student/studentSignupPage.dart';
import 'package:schoolproject/screens/teacher/teacherLogin.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  final controller = PageController(viewportFraction: 0.8);
  AnimationController animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Content about buttons
    final List content = [
      //A button to contiune as a teacher
      CustomButton(
        key: Key("buttonTeacher"),
        onpressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TeacherLogin()));
        },
        text: "Öğretmen olarak devam et",
      ),
      //A button to contiune as a student
      CustomButton(
        key: Key("buttonStudent"),
        onpressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => StudentLogin()));
        },
        text: "Öğrenci olarak devam et",
      ),
    ];
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Header
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: CustomText(
                  color: secondaryColor,
                  sizes: TextSize.title,
                  text: "HOŞGELDİNİZ",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Öğretmen öğrenci arası iletişim artık daha kolay. Ödevler, duyurular, ders programları, başarı durumları ve daha fazla bilgiye artık erişmek çok daha kolay.",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 15,
                  ),
                  maxLines: 5,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              //Images
              SizedBox(
                height: 300,
                child: PageView(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Image.asset("assets/images/class.jpg"),
                    Image.asset("assets/images/teacher.jpg"),
                    Image.asset("assets/images/student.jpg"),
                  ],
                ),
              ),
              //Page Indicator
              Container(
                child: SmoothPageIndicator(
                  controller: controller,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    expansionFactor: 4,
                  ),
                ),
              ),
              //Buttons
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) {
                  return SlideAnimation(
                    animationController: animationController,
                    itemCount: 2,
                    position: index,
                    slideDirection: SlideDirection.fromBottom,
                    child: Column(
                      children: [
                        content[index],
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
