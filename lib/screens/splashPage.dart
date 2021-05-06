import 'package:flutter/material.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customButton.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/screens/teacher/teacherLogin.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final controller = PageController(viewportFraction: 0.8);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
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
                height: size.height * 0.08,
              ),
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
              SizedBox(height: 16),
              Container(
                child: SmoothPageIndicator(
                  controller: controller,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    expansionFactor: 4,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              CustomButton(
                onpressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TeacherLogin()));
                },
                text: "Öğretmen olarak devam et",
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              CustomButton(
                onpressed: () {},
                text: "Öğrenci olarak devam et",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
