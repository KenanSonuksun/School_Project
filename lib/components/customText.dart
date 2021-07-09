import 'package:flutter/material.dart';

enum TextSize {
  small,
  normal,
  big,
  title,
}

class CustomText extends StatelessWidget {
  final TextSize sizes;
  final String text;
  final Color color;

  const CustomText({this.text, this.color, this.sizes});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Text(text,
        softWrap: true,
        //textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        style: sizes == TextSize.normal
            //TextSize is normall
            ? TextStyle(
                color: color,
                fontFamily: 'Muli',
                fontSize: size.width < 390
                    ? 14
                    : size.width > 500
                        ? 22
                        : 17)
            : sizes == TextSize.title
                //TextSize is title
                ? TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MuliBold',
                    fontSize: size.width < 390
                        ? 16
                        : size.width > 500
                            ? 24
                            : 18)
                : sizes == TextSize.small
                    //TextSize is small
                    ? TextStyle(
                        color: color,
                        fontFamily: 'Muli',
                        fontSize: size.width < 390
                            ? 12
                            : size.width > 500
                                ? 20
                                : 14)
                    : TextStyle(
                        color: color,
                        fontFamily: 'Muli',
                        fontSize: size.width < 390
                            ? 18
                            : size.width > 500
                                ? 24
                                : 18));
  }
}
