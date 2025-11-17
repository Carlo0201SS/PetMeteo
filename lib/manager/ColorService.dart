import 'dart:ui';
import 'package:flutter/material.dart';

class ColorService {
  Color get backgroundColor {
    final now = DateTime.now();
    final hour = now.hour;
    // Dalle 18 alle 6 → nero, altrimenti colore chiaro
    if (hour >= 18 || hour < 6) {
      return Colors.black87;
    } else {
      return const Color(0xffbcd4df);
    }
  }

  Color get iconColor {
    final now = DateTime.now();
    final hour = now.hour;
    // Dalle 18 alle 6 → icone bianche, altrimenti nere
    if (hour >= 18 || hour < 6) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}