import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: size.height / 10.0),
        //Image
        Image.asset(
          'assets/images/nodata.jpg',
          height: size.height / 3.5,
          alignment: Alignment.center,
        ),
        //Warning message
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            "Kayıtlı sınıf bulunmamaktadır.Lütfen internet bağlantınızı kontrol edip tekrar deneyiniz.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: size.width > 500
                    ? 23
                    : size.width < 390
                        ? 15
                        : 17.0,
                color: Colors.black),
          ),
        ),
      ],
    ));
  }
}
