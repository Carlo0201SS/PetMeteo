import 'package:flutter/foundation.dart';
import 'package:petmeteo/state/appStateViewModels.dart';

class CarouselViewModel extends ChangeNotifier {
  final AppStateViewModel appState;

  CarouselViewModel({required this.appState});

  List<String> get items {
    final category = appState.selectedCategory;
    final folder = category == 'cats'
        ? 'assets/images/happycats'
        : 'assets/images/happydogs';

    if (category == 'happycats') {
      return [
        '$folder/1h.png',
        '$folder/2h.png',
        '$folder/3h.png',
        '$folder/4h.png',
      ];
    } else {
      return [
        '$folder/1h.png',
        '$folder/2h.png',
      ];
    }
  }


  void selectImage(String item)  {
    appState.setSelectedImage(item);
    notifyListeners();
  }
}

/*class CarouselImageItem {
  final String imagePath;

  CarouselImageItem({required this.imagePath});
}*/























































































































































































