import 'package:flutter/material.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customText.dart';

class NotificationContainer extends StatelessWidget {
  final text, onPressed;
  const NotificationContainer({Key key, this.text, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        width: size.width * 0.96,
        height: size.height * 0.066,
        decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: ListTile(
            leading: Icon(
              Icons.notification_important,
              color: secondaryColor,
            ),
            title: CustomText(
              color: Colors.black,
              sizes: TextSize.small,
              text: text,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_sharp,
              color: secondaryColor,
            ),
            onTap: onPressed,
          ),
        ),
      ),
    );
  }
}
