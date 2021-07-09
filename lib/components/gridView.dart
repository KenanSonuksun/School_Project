import 'package:flutter/material.dart';
import 'consts.dart';
import 'customText.dart';

class BuildGridView extends StatelessWidget {
  final List info;
  const BuildGridView({Key key, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      children: List.generate(2, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: RawMaterialButton(
            onPressed: info[index][2],
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: greyBackground,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    info[index][0],
                    height: 50,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomText(
                    color: Colors.black,
                    sizes: TextSize.title,
                    text: info[index][1],
                  )
                ],
              ),
            ),
          )),
        );
      }),
    );
  }
}
