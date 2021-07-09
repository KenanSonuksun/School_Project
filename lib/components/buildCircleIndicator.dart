import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'customText.dart';

class BuildCircularIndicator extends StatelessWidget {
  final percent, text, centerText;

  const BuildCircularIndicator(
      {Key key, this.percent, this.text, this.centerText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return CircularPercentIndicator(
      radius: width < 500
          ? width > 390
              ? 100
              : 85.0
          : 125.0,
      lineWidth: width > 500 ? 15 : 10.0,
      percent: percent,
      animationDuration: 2500,
      animation: true,
      header: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: CustomText(
          color: Colors.red,
          sizes: TextSize.small,
          text: text,
        ),
      ),
      arcType: ArcType.FULL,
      center: CustomText(
        color: Colors.black,
        sizes: TextSize.small,
        text: centerText,
      ),
      backgroundColor: Colors.grey,
      progressColor: CupertinoColors.activeGreen,
    );
  }
}
