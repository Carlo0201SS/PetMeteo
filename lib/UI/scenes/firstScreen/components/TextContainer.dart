import 'package:flutter/material.dart';
import 'package:petmeteo/UI/components1/AppLabelText60.dart';


class TextContainer extends StatelessWidget {
  final String text1;
  final String text2;
  final String text3;
  final dynamic color;

  const TextContainer({
    super.key,
    required this.text1,
    required this.text2,
    required this.text3,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppLabelText60(text: text1),
          SizedBox(height:0),
          AppLabelText60(text: text2),
          SizedBox(height: 0),
          AppLabelText60(text: text3),
        ],
      ),
    );
  }
}
