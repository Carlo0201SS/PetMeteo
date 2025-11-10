import 'package:flutter/material.dart';

import 'package:petmeteo/UI/components3/AppLabelText16.dart';
import 'package:petmeteo/UI/scenes/userScreen/ViewModel/UserScreenViewModel.dart';

class WeatherInfo {
  final String day;
  final IconData icon;
  final String temp;
  final dynamic color;

  WeatherInfo({
    required this.day,
    required this.icon,
    required this.temp,
    this.color = Colors.black,
  });
}

class DailyBox extends StatelessWidget {
  final List<HomePageViewModelWeatherDaily> items;

  DailyBox({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 370,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildWeatherItem(item);
        },
      ),
    );
  }

  Widget _buildWeatherItem(HomePageViewModelWeatherDaily item) {
    return Container(
      width: 50,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.zero,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey, // ← Colore del bordo
            width: 1, // ← Spessore del bordo
          ),
          borderRadius: BorderRadius.circular(12), // ← Angoli arrotondati
        ),
        padding: EdgeInsets.all(12), // ← Spazio interno
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppLabelText16(text: item.day),
            Spacer(),
            Icon(item.icon, color: Colors.black),
            Spacer(),
            AppLabelText16(text: '${item.temp}'),
          ],
        ),
      ),
    );
  }
}
