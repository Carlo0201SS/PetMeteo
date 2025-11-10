import 'package:flutter/material.dart';
import 'package:petmeteo/UI/components3/AppLabelText18.dart';
import 'package:petmeteo/UI/components3/AppLabelText20.dart';

//import 'package:appmeteonew/UI/scenes/userScreen/ViewModel/components/feelsLike.dart';

class InfoContainerFL extends StatelessWidget {
  final String text1;
  final String text2;
  final IconData icon;
  final dynamic color;

  const InfoContainerFL({
    super.key,
    required this.text1,
    required this.text2,
    required this.icon,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
      width: 170,
      height: 140,
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // ← Colore del bordo
          width: 2, // ← Spessore del bordo
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppLabelText18(text: text1),
          SizedBox(height: 10),
          Icon(icon),
          SizedBox(height: 10),
          AppLabelText20(text: text2),
        ],
      ),
    );
  }
}
