import 'package:flutter/material.dart';

class ImageCarousel {
  final Image image;

  ImageCarousel({required this.image});
}

class HorizontalDynamicCarousel extends StatefulWidget {
  final List<String> items;
  final void Function(String) onTap;

  const HorizontalDynamicCarousel({
    Key? key,
    required this.items,
    required this.onTap,
  }) : super(key: key);

  @override
  State<HorizontalDynamicCarousel> createState() => _HorizontalDynamicCarouselState();
}

class _HorizontalDynamicCarouselState extends State<HorizontalDynamicCarousel> {
  String? _selectedItem; // tiene traccia dell’immagine selezionata

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          final isSelected = item == _selectedItem;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedItem = item; // aggiorna la selezione
              });
              widget.onTap(item); // chiama la callback
            },
            child: _buildWeatherItem(item, isSelected),
          );
        },
      ),
    );
  }

  Widget _buildWeatherItem(String item, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100), // effetto morbido
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.yellow.shade200 : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.transparent,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          item,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}





































