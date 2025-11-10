import 'package:flutter/material.dart';
import 'package:petmeteo/UI/components1/AppLabelText18.dart';

//import 'package:appmeteonew/UI/components/AppLabelTextButton18.dart';

class UserButton extends StatelessWidget {
  final String text1;
  final Color color;
  final Color color1;
  final VoidCallback? onPressed;

  const UserButton({
    super.key,
    required this.text1,
    required this.color,
    required this.color1,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
        foregroundColor: MaterialStateProperty.all<Color>(color1),
        minimumSize: MaterialStateProperty.all(Size(180, 50)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // ← ZERO = squadrato perfetto
          ),
        ),
      ),

      // ← null disabilita il button
      child: AppLabelText18(text: text1),
    );
  }
}
