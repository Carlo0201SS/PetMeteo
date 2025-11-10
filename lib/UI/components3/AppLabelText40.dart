import 'package:flutter/material.dart';

class AppLabelText40 extends StatelessWidget {
  final String text;

  const AppLabelText40({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'FiraSans',
        fontSize: 60,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
