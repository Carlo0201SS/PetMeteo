import 'package:flutter/material.dart';
import 'package:petmeteo/UI/components3/AppLabelText16Light.dart';
import 'package:petmeteo/UI/scenes/userScreen/ViewModel/UserScreenViewModel.dart';


class WeatherInfo {
  final String hour;
  final String temp;
  final IconData icon;
  final Color color;

  WeatherInfo({
    required this.hour,
    required this.temp,
    required this.icon,
    this.color = Colors.black,
  });
}

class HorizontalStaticCarousel extends StatelessWidget {
  final List<HomePageViewModelWeatherHourly> items;

  HorizontalStaticCarousel({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildWeatherItem(item);
        },
      ),
    );
  }

  Widget _buildWeatherItem(HomePageViewModelWeatherHourly item) {
    return Container(
      width: 50,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLabelText16Light(text: item.hour),
          SizedBox(height: 5),
          Icon(item.icon, color: Colors.black),
          SizedBox(height: 5),
          AppLabelText16Light(text: '${item.temp}'),
        ],
      ),
    );
  }
}
