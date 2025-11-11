import 'package:flutter/material.dart';
import 'package:petmeteo/UI/components3/AppLabelText18.dart';

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
        backgroundColor: WidgetStateProperty.all<Color>(color),
        foregroundColor: WidgetStateProperty.all<Color>(color1),
        minimumSize: WidgetStateProperty.all(Size(180, 50)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
