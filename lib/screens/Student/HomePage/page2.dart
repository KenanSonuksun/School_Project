import 'package:flutter/material.dart';
import 'package:schoolproject/components/animation.dart';
import 'package:schoolproject/components/lessonTimeline.dart';

class Page2 extends StatefulWidget {
  final infoProvider, selectedIndex;

  const Page2({Key key, this.infoProvider, this.selectedIndex})
      : super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  List mon = [], tues = [], wed = [], thur = [], fri = [];

  @override
  void initState() {
    //for lesson Plan
    for (int i = 0;
        i <
            widget.infoProvider.classes[widget.selectedIndex]["lessonPlan"]
                .length;
        i++) {
      if (widget.infoProvider.classes[widget.selectedIndex]["lessonPlan"][i]
              ["dateName"] ==
          "Monday") {
        setState(() {
          mon.add(widget.infoProvider.classes[widget.selectedIndex]
              ["lessonPlan"][i]);
        });
      } else if (widget.infoProvider.classes[widget.selectedIndex]["lessonPlan"]
              [i]["dateName"] ==
          "Wednesday") {
        setState(() {
          wed.add(widget.infoProvider.classes[widget.selectedIndex]
              ["lessonPlan"][i]);
        });
      } else if (widget.infoProvider.classes[widget.selectedIndex]["lessonPlan"]
              [i]["dateName"] ==
          "Tuesday") {
        setState(() {
          tues.add(widget.infoProvider.classes[widget.selectedIndex]
              ["lessonPlan"][i]);
        });
      } else if (widget.infoProvider.classes[widget.selectedIndex]["lessonPlan"]
              [i]["dateName"] ==
          "Thursday") {
        setState(() {
          thur.add(widget.infoProvider.classes[widget.selectedIndex]
              ["lessonPlan"][i]);
        });
      } else if (widget.infoProvider.classes[widget.selectedIndex]["lessonPlan"]
              [i]["dateName"] ==
          "Friday") {
        setState(() {
          fri.add(widget.infoProvider.classes[widget.selectedIndex]
              ["lessonPlan"][i]);
        });
      }
    }
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //widgets
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return SlideAnimation(
              animationController: animationController,
              itemCount: 5,
              position: index,
              slideDirection: SlideDirection.fromBottom,
              child: LessonTimeLine(
                array: index == 0
                    ? mon
                    : index == 1
                        ? tues
                        : index == 2
                            ? wed
                            : index == 3
                                ? thur
                                : fri,
              ),
            );
          },
        ),
        SizedBox(
          height: size.height * 0.05,
        )
      ],
    ));
  }
}
