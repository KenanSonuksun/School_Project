import 'dart:ui';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String keyName;
  final double topPadding;
  final Widget suffixIcon;
  final bool readonly;
  final String hintText;
  final Function onChanged;
  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function validator;
  final Function onSaved;
  final double height;
  const CustomTextField(
      {Key key,
      this.topPadding,
      this.readonly,
      this.hintText,
      this.controller,
      this.obscureText,
      this.validator,
      this.onSaved,
      this.suffixIcon,
      this.keyboardType,
      this.labelText,
      this.height,
      this.onChanged,
      this.keyName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: TextFormField(
          //Text Style
          style: TextStyle(
              height: height,
              color: Colors.black,
              fontSize: size.width > 500 ? 25 : 17),
          validator: validator,
          onSaved: onSaved,
          onChanged: onChanged,
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          readOnly: readonly,
          //Decoration
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[700]),
              gapPadding: 10,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[700]),
              gapPadding: 10,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[700]),
              gapPadding: 10,
            ),
            hintText: hintText,
            labelText: labelText,
            hintStyle: TextStyle(color: Colors.grey),
            labelStyle: TextStyle(color: Colors.grey),
            helperStyle: TextStyle(color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ));
  }
}
