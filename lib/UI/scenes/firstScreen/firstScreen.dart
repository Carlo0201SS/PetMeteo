import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:petmeteo/UI/scenes/firstScreen/components/TextContainer.dart';
import 'package:petmeteo/UI/scenes/firstScreen/components/userButton.dart';
import 'package:petmeteo/UI/scenes/firstScreen/viewModel/FirstScreenViewModel.dart';
import 'package:petmeteo/state/appStateViewModels.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateViewModel>(context, listen: false);
    final fsviewmodel = FirstScreenViewModel(appState: appState);

    return Scaffold(
      backgroundColor: const Color(0xffbcd4df),
      appBar: AppBar(backgroundColor: const Color(0xffbcd4df)),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 200),

            // Testo principale
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
              decoration: const BoxDecoration(color: Color(0xffbcd4df)),
              child: const TextContainer(
                text1: "What kind",
                text2: "of person",
                text3: "are you?",
                color: Colors.white,
              ),
            ),

            //  Bottoni Cat / Dog
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: UserButton(
                      text1: "Cat",
                      color: appState.selectedCategory == 'cats'
                          ? const Color(0xff04093b)
                          : Colors.white,
                      color1: appState.selectedCategory == 'cats'
                          ? Colors.white
                          : Colors.black,
                      onPressed: () {
                        setState(() {
                          fsviewmodel.selectCategory('cats');
                        });
                        //vm.selectCategory('cats');
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: UserButton(
                      text1: "Dog",
                      color: appState.selectedCategory == 'dogs'
                          ? const Color(0xff04093b)
                          : Colors.white,
                      color1: appState.selectedCategory == 'dogs'
                          ? Colors.white
                          : Colors.black,
                      onPressed: () {
                        setState(() {
                          fsviewmodel.selectCategory('dogs');
                        });
                        //vm.selectCategory('dogs');
                      },
                    ),
                  ),
                ),
              ],
            ),

            //  Bottone "Done"
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    if (fsviewmodel.selectedCategory != null) {
                      Navigator.pushNamed(context, '/second');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Seleziona "Cat" o "Dog" prima di continuare.',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
