import 'package:flutter/material.dart';

class AppLabelText30 extends StatelessWidget {
  final String text;

  const AppLabelText30({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'FiraSans',
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
