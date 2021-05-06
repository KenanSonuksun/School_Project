import 'package:flutter/material.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customText.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final onpressed;
  const CustomButton({Key key, this.text, this.onpressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.07,
      child: ElevatedButton(
        onPressed: onpressed,
        child: CustomText(
          color: Colors.white,
          text: text,
          sizes: TextSize.normal,
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primaryColor),
        ),
      ),
    );
  }
}
