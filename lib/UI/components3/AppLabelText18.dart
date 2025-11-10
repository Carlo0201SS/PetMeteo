import 'package:flutter/material.dart';

class AppLabelText18 extends StatelessWidget {
  final String text;

  const AppLabelText18({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'FiraSans',
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
