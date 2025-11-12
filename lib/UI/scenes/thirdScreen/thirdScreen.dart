import 'package:flutter/material.dart';
import 'package:petmeteo/UI/scenes/thirdScreen/components/SampleText.dart';
import 'package:petmeteo/UI/scenes/thirdScreen/components/TextContainer.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aggiunta nome')),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(color: Colors.white),
              child: TextContainer(text1: "Scrivi il nome del tuo animale:")
            ),
            SizedBox(height: 40),
            SampleText(),
          ],
        ),
      ),
    );
  }
}
