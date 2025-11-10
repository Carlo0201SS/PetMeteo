import 'package:flutter/material.dart';
import 'package:petmeteo/UI/scenes/userScreen/components/menuOpened.dart';
import 'package:provider/provider.dart';
import 'package:petmeteo/UI/components3/AppLabelText16.dart';



import 'package:petmeteo/UI/scenes/userScreen/ViewModel/UserScreenViewModel.dart';
import 'package:petmeteo/UI/scenes/userScreen/components/AppInfoHeader.dart';
import 'package:petmeteo/UI/scenes/userScreen/components/HorizontalStaticCarousel.dart';
import 'package:petmeteo/UI/scenes/userScreen/components/dailyBox.dart';
import 'package:petmeteo/UI/scenes/userScreen/components/infoContainerCOR.dart';
import 'package:petmeteo/UI/scenes/userScreen/components/infoContainerFL.dart';
import 'package:petmeteo/UI/scenes/userScreen/components/infoContainerHumidity.dart';
import 'package:petmeteo/UI/scenes/userScreen/components/infoContainerWind.dart';
import 'package:petmeteo/UI/scenes/userScreen/components/menuIcon.dart';
import 'package:petmeteo/UI/scenes/userScreen/components/userButton.dart';

import 'package:petmeteo/state/appStateViewModels.dart';
import 'package:petmeteo/manager/service.dart';
import 'package:geolocator/geolocator.dart';




class UserScreen extends StatefulWidget {
  @override
  State<UserScreen> createState() => _UserScreen();
}

class _UserScreen extends State<UserScreen> {
  late HomePageViewModel model;
  bool _initialized = false;
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final appState = context.watch<AppStateViewModel>();

      Future.microtask(() async {
        Position currentPosition;
        try {
          currentPosition = await LocationService().getCurrentPosition();
        } catch (e) {
          currentPosition = Position(
            latitude: 0,
            longitude: 0,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 0,
            headingAccuracy: 0,
            floor: 0,
            isMocked: false,
          );
        }

        model = HomePageViewModel(appState: appState);
        model.currentPosition = currentPosition;
        await model.updateCurrentCity();
        await model.fetchData();

        // ✅ Post-frame fix per evitare l’errore di _handleBeginFrame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _loading = false;
          });
        });
      });

      _initialized = true;
    }
  }

  Future<void> _refreshData() async {
    try {
      setState(() => _loading = true);
      Position currentPosition;
      try {
        currentPosition = await LocationService().getCurrentPosition();
      } catch (e) {
        currentPosition = Position(
          latitude: 0,
          longitude: 0,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
          floor: 0,
          isMocked: false,
        );
      }

      model.currentPosition = currentPosition;
      await model.updateCurrentCity();
      await model.fetchData();
      setState(() => _loading = false);
    } catch (e) {
      debugPrint("Errore durante il refresh: $e");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator(color:Colors.red)));
    }

    return Scaffold(
      backgroundColor: model.backgroundColor,
      appBar: AppBar(backgroundColor: model.backgroundColor),
      body: AnimatedBuilder(
        animation: model,
        builder: (context, _) {
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        color: model.backgroundColor,
                        width: MediaQuery.of(context).size.width,
                        height: 220,
                        margin: EdgeInsets.all(0),
                        padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppInfoHeader(
                              text1: model.header?.city ?? "ND",
                              text2: model.header?.temp.toString() ?? "ND",
                              text3: model.header?.day ?? "ND",
                              color: model.backgroundColor,
                            ),
                            Spacer(flex: 2),
                            MenuIcon(
                              color: model.backgroundColor,
                              icon: Icons.menu,
                              size: 30,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    requestFocus: true,
                                    builder: (context) => const MenuOpened(
                                      
                                      optionLabels: [
                                        'Mappa',
                                        'Notifiche',
                                        'Animali',
                                        'Condividi',
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(model.icon!.icon, size: 80, color: model.iconColor),
                      if (model.image?.imagePath != null &&
                          model.image!.imagePath!.isNotEmpty)
                        Image.asset(
                          model.image!.imagePath!,
                          width: 250,
                          height: 250,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            print(' Errore immagine: $error');
                            return SizedBox.shrink();
                          },
                        ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                        child: Column(
                          children: [
                            AppLabelText16(  
                              text: model.sentences?.text ?? "Error",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        color: model.backgroundColor,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: UserButton(
                                text1: "Hourly",
                                color: model.currentView == 'daily'
                                    ? Color(0xff04093b)
                                    : Colors.white,
                                color1: model.currentView == 'daily'
                                    ? Colors.white
                                    : Colors.black,
                                onPressed: () {
                                  setState(() {
                                    model.currentView = 'hourly';
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: UserButton(
                                text1: "Daily",
                                color: model.currentView == 'hourly'
                                    ? Color(0xff04093b)
                                    : Colors.white,
                                color1: model.currentView == 'hourly'
                                    ? Colors.white
                                    : Colors.black,
                                onPressed: () {
                                  setState(() {
                                    model.currentView = 'daily';
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  _buildCurrentView(),
                  SizedBox(height: 15),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: InfoContainerCOR(
                                text1: model.container1?.title ?? "ND",
                                icon: Icons.wb_cloudy,
                                text2:
                                    model.container1?.value.toString() ?? "ND",
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: InfoContainerHumidity(
                                text1: model.container2?.title ?? "ND",
                                icon: Icons.water_drop,
                                text2:
                                    model.container2?.value.toString() ?? "ND",
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: InfoContainerFL(
                                text1: model.container3?.title ?? "ND",
                                icon: Icons.accessibility_outlined,
                                text2:
                                    model.container3?.value.toString() ?? "ND",
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: InfoContainerWind(
                                text1: model.container4?.title ?? "ND",
                                icon: Icons.air,
                                text2:
                                    model.container4?.value.toString() ?? "ND",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (model.currentView) {
      case 'hourly':
        return HorizontalStaticCarousel(items: model.weatherhourly ?? []);
      case 'daily':
        return DailyBox(items: model.weatherdaily ?? []);
      default:
        return HorizontalStaticCarousel(items: model.weatherhourly ?? []);
    }
  }
}










































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































