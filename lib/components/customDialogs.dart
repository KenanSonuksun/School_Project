import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialog {
  //this dialog is about warning message
  void firstDialog(context, text, icon, iconColor) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Icon(
                icon,
                size: MediaQuery.of(context).size.width > 500 ? 150 : 50,
                color: iconColor,
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    text,
                    style: TextStyle(
                        color: iconColor,
                        fontSize:
                            MediaQuery.of(context).size.width > 500 ? 25 : 20),
                  ),
                ),
              ],
            ));
  }

  //user choose yes or no with this dialog
  void secondDialog(context, text, onPressedYes, onPressedNo) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              insetAnimationDuration: Duration(seconds: 1),
              content: Text(
                text,
                style: TextStyle(
                    color: Colors.red,
                    fontSize:
                        MediaQuery.of(context).size.width > 500 ? 25 : 17),
              ),
              title: Icon(
                Icons.warning_amber_outlined,
                size: MediaQuery.of(context).size.width > 500 ? 150 : 50,
                color: Colors.red,
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    "Evet",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize:
                            MediaQuery.of(context).size.width > 500 ? 25 : 17),
                  ),
                  onPressed: onPressedYes,
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    "Hayır",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize:
                            MediaQuery.of(context).size.width > 500 ? 25 : 17),
                  ),
                  onPressed: onPressedNo,
                ),
              ],
            ));
  }
}
