import 'package:flutter/material.dart';
import 'package:petmeteo/UI/scenes/thirdScreen/components/SampleText.dart';

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
        body: const Center(child: SampleText()),
      );
    
  }
}
























