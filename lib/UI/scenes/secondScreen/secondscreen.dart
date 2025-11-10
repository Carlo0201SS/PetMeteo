import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:petmeteo/state/appStateViewModels.dart';
import 'package:petmeteo/UI/scenes/secondScreen/components/DynamicCarousel.dart';
import 'package:petmeteo/UI/scenes/secondScreen/viewModel/SecondScreenViewModel.dart';
import 'package:petmeteo/UI/scenes/secondScreen/components/TextContainer.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    // Prende il ViewModel dal Provider
    final carouselVm = context.watch<CarouselViewModel>();
    final appState = context.read<AppStateViewModel>();

     final category = appState.selectedCategory;

    final items = category == 'dogs'
        ? carouselVm.items
        : carouselVm.items;

    return Scaffold(
      backgroundColor: const Color(0xffbcd4df),
      appBar: AppBar(backgroundColor: const Color(0xffbcd4df)),
      body: Center(
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
              decoration: const BoxDecoration(color: Color(0xffbcd4df)),
              child: const TextContainer(
                text1: "Seleziona immagine",
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: HorizontalDynamicCarousel(items: items,
                onTap: (selectedImage) {
                  appState.setSelectedImage(selectedImage);
                  
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    if (appState.selectedImage != null) {
                      Navigator.pushNamed(context, '/third');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Seleziona una immagine per continuare',
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.grey.shade800,
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
