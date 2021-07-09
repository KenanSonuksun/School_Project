import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BuildLinearIndicator extends StatelessWidget {
  final widget, percent, text;

  const BuildLinearIndicator({Key key, this.widget, this.percent, this.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return LinearPercentIndicator(
      alignment: width < 390 ? MainAxisAlignment.center : MainAxisAlignment.end,
      width: width * 0.7,
      animation: true,
      animationDuration: 2500,
      lineHeight: width > 500
          ? 30
          : width < 390
              ? 15
              : 20.0,
      leading: widget,
      percent: percent,
      center: text,
      linearStrokeCap: LinearStrokeCap.roundAll,
      progressColor: CupertinoColors.activeGreen,
    );
  }
}
