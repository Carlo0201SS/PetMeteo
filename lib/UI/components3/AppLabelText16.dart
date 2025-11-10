import 'package:flutter/material.dart';

class AppLabelText16 extends StatelessWidget {
  final String text;

  const AppLabelText16({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'FiraSans',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade900,
      ),
    );
  }
}
