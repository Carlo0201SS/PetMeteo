import 'package:flutter/foundation.dart';
import 'package:petmeteo/state/appStateViewModels.dart';




class ThirdScreenViewModel extends ChangeNotifier {
  final AppStateViewModel appState;

  ThirdScreenViewModel({required this.appState});

  /// Getter: prendi la categoria direttamente dallo stato globale
  String? get selectedText => appState.selectedCategory;

  /// Seleziona una categoria e aggiorna l’app state globale
  Future<void> saveText(String text) async {
    // aspetta che lo stato globale scriva su SharedPreferences
    await appState.setSelectedText(text);
    notifyListeners();
  }

}
