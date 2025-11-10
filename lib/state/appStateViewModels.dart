import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateViewModel extends ChangeNotifier {
  final SharedPreferences prefs;

  String? _selectedCategory;
  String? _selectedImage;
  String? _selectedText;

  String? get selectedCategory => _selectedCategory;
  String? get selectedImage => _selectedImage;
  String? get selectedText => _selectedText;

  AppStateViewModel(this.prefs) {
    _loadPreferences();
  }

// salvo le informazioni grazie a SharedPreferences
  Future<void> _loadPreferences() async {
    _selectedCategory = prefs.getString('selectedCategory');
    _selectedImage = prefs.getString('selectedImage');
    _selectedText = prefs.getString('selectedText');
    notifyListeners();
  }

// Seleziono o cane o gatto
  Future<void> setSelectedCategory(String category) async {
    _selectedCategory = category;
    await prefs.setString('selectedCategory', category);
    notifyListeners();
  }

//seleziono una delle immagini dal carosello
  Future<void> setSelectedImage(String image) async {
    _selectedImage = image;
    await prefs.setString('selectedImage', image);
    notifyListeners();
  }

  Future<void> setSelectedText(String text) async {
    _selectedText = text;
    await prefs.setString('selectedText', text);
    notifyListeners();
  }

}





































