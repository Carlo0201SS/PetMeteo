import 'package:flutter/material.dart';

class AppLabelText16Light extends StatelessWidget {
  final String text;

  const AppLabelText16Light({
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
        fontWeight: FontWeight.normal,
        color: Colors.grey.shade800,
      ),
    );
  }
}
