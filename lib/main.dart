import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:petmeteo/state/appStateViewModels.dart';

import 'package:petmeteo/UI/scenes/userScreen/ViewModel/UserScreenViewModel.dart';
import 'package:petmeteo/UI/scenes/firstScreen/viewModel/FirstScreenViewModel.dart';
import 'package:petmeteo/UI/scenes/secondScreen/viewModel/SecondScreenViewModel.dart';
import 'package:petmeteo/UI/scenes/thirdScreen/viewModel/ThirdScreenViewModel.dart';

import 'package:petmeteo/UI/scenes/userScreen/userScreen.dart';
import 'package:petmeteo/UI/scenes/firstScreen/firstScreen.dart';
import 'package:petmeteo/UI/scenes/secondScreen/secondScreen.dart';
import 'package:petmeteo/UI/scenes/thirdScreen/thirdScreen.dart';





void main() async {
  
  await dotenv.load(fileName:'.env');
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // 🔹 Verifica se l’utente ha già fatto la scelta
  final hasCategory = prefs.getString('selectedCategory');
  final hasImage = prefs.getString('selectedImage');
  final startRoute = (hasCategory != null && hasImage != null) ? '/user' : '/';
  

  runApp(AppMeteo(prefs: prefs, startRoute: startRoute));
}

class AppMeteo extends StatelessWidget {
  final SharedPreferences prefs;
  final String startRoute;

  const AppMeteo({super.key, required this.prefs, required this.startRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 🔹 Stato globale persistente
        ChangeNotifierProvider<AppStateViewModel>(
          create: (_) => AppStateViewModel(prefs),
        ),

        // 🔹 Primo schermo
        ChangeNotifierProxyProvider<AppStateViewModel, FirstScreenViewModel>(
          create: (context) =>
              FirstScreenViewModel(appState: context.read<AppStateViewModel>()),
          update: (context, appState, previous) =>
              previous ?? FirstScreenViewModel(appState: appState),
        ),

        // 🔹 Carosello
        ChangeNotifierProxyProvider<AppStateViewModel, CarouselViewModel>(
          create: (context) =>
              CarouselViewModel(appState: context.read<AppStateViewModel>()),
          update: (context, appState, previous) =>
              previous ?? CarouselViewModel(appState: appState),
        ),


        ChangeNotifierProxyProvider<AppStateViewModel, ThirdScreenViewModel>(
          create: (context) =>
              ThirdScreenViewModel(appState: context.read<AppStateViewModel>()),
          update: (context, appState, previous) =>
              previous ?? ThirdScreenViewModel(appState: appState),
        ),


        //  HomePage
        ChangeNotifierProxyProvider<AppStateViewModel, HomePageViewModel>(
          create: (context) =>
              HomePageViewModel(appState: context.read<AppStateViewModel>()),
          update: (context, appState, previous) =>
              previous ?? HomePageViewModel(appState: appState),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App Meteo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffbcd4df)),
          useMaterial3: true,
        ),
        //  Route iniziale dinamica
        initialRoute: startRoute,
        routes: {
          '/': (context) => FirstScreen(),
          '/second': (context) => SecondScreen(),
          '/third': (context) => ThirdScreen(),
          '/user': (context) => UserScreen(),
        },
      ),
    );
  }
}























































