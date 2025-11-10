import 'package:flutter/material.dart';

class AppLabelTextButton18 extends StatelessWidget {
  final String text;
  final dynamic color;

  const AppLabelTextButton18({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'FiraSans',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
