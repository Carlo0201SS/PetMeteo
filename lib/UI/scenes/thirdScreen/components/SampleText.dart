import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:petmeteo/state/appStateViewModels.dart';
import 'package:petmeteo/UI/scenes/thirdScreen/ViewModel/ThirdScreenViewModel.dart';





class SampleText extends StatelessWidget {
  const SampleText({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppStateViewModel>();
    final tsviewmodel = ThirdScreenViewModel(appState: appState);

    return Column(
      children: [
        SizedBox(width: 250),
        TextField(
          obscureText: false,
          onSubmitted: (value) async {
            await tsviewmodel.saveText(value);

            Navigator.pushNamed(context, '/user');
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Aggiungi il nome:',
          ),
        ),
      ],
    );
  }
}
