import 'package:flutter/material.dart';
import 'package:petmeteo/UI/components3/AppLabelText30.dart';
import 'package:petmeteo/UI/components3/AppLabelText40.dart';


class AppInfoHeader extends StatelessWidget {
  final String text1;
  final String text2;
  final String text3;
  final Color color;

  const AppInfoHeader({
    super.key,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppLabelText30(text: text1),
          AppLabelText40(text: text2),
          AppLabelText30(text: text3),
        ],
      ),
    );
  }
}
