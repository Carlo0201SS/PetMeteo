import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:petmeteo/manager/PromptService.dart';

import 'package:petmeteo/manager/backend.dart';
import 'package:petmeteo/manager/backendLLM1.dart';
import 'package:petmeteo/manager/backendLLM2.dart';

import 'package:petmeteo/models/forecast_response/ForecastResponse.dart'; // GET
import 'package:petmeteo/models/llm_request/LLMRequest1.dart'; // POST
import 'package:petmeteo/models/llm_request/LLMRequest2.dart'; // POST
import 'package:petmeteo/models/llm_response/LLMResponse1.dart'; // POST
import 'package:petmeteo/models/llm_response/LLMResponse2.dart'; // POST

import 'package:petmeteo/state/appStateViewModels.dart'; // "torre di controllo stato di più pagine"

import 'package:petmeteo/manager/service.dart';

// definizione classe HomePageViewModel, di tipo ChangeNotifier perchè contiene oggetti asincroni.
// definizione di backend(chiamata API), mappatura dei dati nell'API(forecastresponse), LocationService(per la geolocalizzazione tramite librerie), e def. di variabili

class HomePageViewModel extends ChangeNotifier {
  final Backend _weatherData = Backend();
  ForecastResponse? _forecast;

  final BackendLLM1 _llmData1 = BackendLLM1();
  final BackendLLM2 _llmData2 =
  BackendLLM2(); // qui istanzio Backendllm() che mi permette di fare la chiamata POST.

  LLMRequest1? _llmRequest1; // mappatura della request
  LLMResponse1? _llmResponse1;

  LLMRequest2? _llmRequest2;
  LLMResponse2? _llmResponse2; // mappatura della response

  final LocationService _locationService = LocationService();

  Position? currentPosition;
  String? _currentCity;

  String currentView = 'hourly'; // stato bottone hourly oppure daily.
  final AppStateViewModel appState;

  bool isBadWeather =
      false; // variabile poi controllata da un prompt generato da ChatGPT.

  // definizione degli elementi che compaiono nella UI
  HomePageViewModelHeader? header;
  HomePageViewModelImage? image;
  HomePageViewModelSentences? sentences;
  HomePageViewModelIcon? icon;

  HomePageViewModelContainerCOR? container1;
  HomePageViewModelContainerHumidity? container2;
  HomePageViewModelContainer? container3;
  HomePageViewModelContainer? container4;

  List<HomePageViewModelWeatherDaily>? weatherdaily;
  List<HomePageViewModelWeatherHourly>? weatherhourly;

  //gestione image dall'appstate.(Contiene la sua informazione salvata).
  HomePageViewModel({required this.appState}) {
    appState.addListener(() {
      image = HomePageViewModelImage(
        imagePath: appState.selectedImage ?? 'assets/images/default/1.png',
      );
      notifyListeners();
    });
  }

  // metodo per restituire la giornata corrente
  String get _currentDay {
    if (_forecast?.current?.time == null) return 'ND';

    try {
      final date = DateTime.parse(_forecast!.current!.time!);
      final days = [
        'Lunedì',
        'Martedì',
        'Mercoledì',
        'Giovedì',
        'Venerdì',
        'Sabato',
        'Domenica',
      ];
      return days[date.weekday - 1];
    } catch (e) {
      return 'ND';
    }
  }

  // metodo che restituisce la probabilità di pioggia corrente
  int? get _currentProbPrecipitation {
    if (_forecast?.current?.time == null) return 0;

    try {
      final currentTime = DateTime.parse(_forecast!.current!.time!);
      final probPrecipitation = _forecast!.hourly!.probprecipitation;
      final hourlyTimes = _forecast!.hourly!.time;

      for (int i = 0; i < hourlyTimes!.length; i++) {
        if (_areTimesEqual(hourlyTimes[i], currentTime)) {
          return probPrecipitation![i];
        }
      }

      return findClosestPrecipitation(currentTime);
    } catch (e) {
      return 0;
    }
  }

  bool _areTimesEqual(DateTime time1, DateTime time2) {
    return time1.year == time2.year &&
        time1.month == time2.month &&
        time1.day == time2.day &&
        time1.hour == time2.hour;
  }

  int findClosestPrecipitation(DateTime targetTime) {
    final hourlyTimes = _forecast!.hourly!.time;
    final probPrecipitation = _forecast!.hourly!.probprecipitation;

    int closestIndex = 0;
    Duration minDifference = (hourlyTimes![0].difference(targetTime)).abs();

    for (int i = 1; i < hourlyTimes.length; i++) {
      final difference = (hourlyTimes[i].difference(targetTime)).abs();
      if (difference < minDifference) {
        minDifference = difference;
        closestIndex = i;
      }
    }

    return probPrecipitation![closestIndex];
  }

  // genera l'icona sopra il cucciolo (importante), si scorre l'array con i weathercode e si fa la conversione con un metodo apposito, la funzione non verrà richiamata nel codice.
  List<IconData> _mapWeatherCodesToIcons(List<int> weatherCodes) {
    /*return weatherCodes.map((weatherCode) {
      return _getWeatherIcon(weatherCode);
    }).toList();*/
    List<IconData> array = [];
    for (int i = 0; i < weatherCodes.length; i++) {
      array.add(_getWeatherIcon(weatherCodes[i]));
    }
    return array;
  }

  // restituisce un'icona dai codici weathercode presi dall'API Open Meteo
  IconData _getWeatherIcon(int weatherCode) {
    //print("weathercode: $weatherCode");
    switch (weatherCode) {
      case 0:
        return Icons.wb_sunny; // Cielo sereno
      case 1:
      case 2:
      case 3:
        return Icons.wb_twighlight; // Parzialmente nuvoloso
      case 45:
      case 48:
        return Icons.wb_cloudy_outlined; // Nebbia
      case 51:
      case 53:
      case 55:
        return Icons.grain; // Pioggia leggera
      case 56:
      case 57:
        return Icons.cloudy_snowing; // Pioggia gelata
      case 61:
      case 63:
      case 65:
        return Icons.grain; // Pioggia
      case 66:
      case 67:
        return Icons.cloudy_snowing; // Pioggia gelata intensa
      case 71:
      case 73:
      case 75:
        return Icons.ac_unit; // Neve
      case 77:
        return Icons.ac_unit; // Granelli di neve
      case 80:
      case 81:
      case 82:
        return Icons.thunderstorm; // Rovesci di pioggia
      case 85:
      case 86:
        return Icons.ac_unit; // Rovesci di neve
      case 95:
        return Icons.thunderstorm; // Temporale
      case 96:
      case 99:
        return Icons.thunderstorm; // Temporale con grandine
      default:
        return Icons.help; // Icona predefinita per codici sconosciuti
    }
  }

  // metodo che restituisce l'immagine corretta a nseconda delle condizioni meteo
  String getImageForConditions(AppStateViewModel appState) {
    final wind = _forecast?.current?.windspeed ?? 0;
    final temp = _forecast?.current?.temperature ?? 0;
    final probprecipitation = _forecast?.hourly?.probprecipitation ?? [];
    final hourlyCodes = _forecast?.hourly?.weathercode ?? [];
    final hourlyTimes = _forecast?.hourly?.time ?? [];

    //1° "metodo"
    int? currentCode;
    if (hourlyCodes.isNotEmpty && hourlyTimes.isNotEmpty) {
      final now = DateTime.now();
      Duration minDiff = (hourlyTimes[0].difference(now)).abs();

      int closestIndex = 0;
      for (int i = 1; i < hourlyTimes.length; i++) {
        final diff = (hourlyTimes[i].difference(now)).abs();
        if (diff < minDiff) {
          minDiff = diff;
          closestIndex = i;
        }
      }
      currentCode = hourlyCodes[closestIndex];
    }

    // 2° "metodo"
    int? currentProbPrecipitation;
    if (probprecipitation.isNotEmpty && hourlyTimes.isNotEmpty) {
      final now = DateTime.now();

      // Trova il primo orario FUTURO (non nel passato)
      int closestIndex = hourlyTimes.indexWhere((t) => t.isAfter(now));

      // Se tutti gli orari sono passati, prendi l’ultimo disponibile
      if (closestIndex == -1) {
        closestIndex = hourlyTimes.length - 1;
      }

      currentProbPrecipitation = probprecipitation[closestIndex];
    }

    isBadWeather =
        wind > 30 ||
        (temp < 5 || temp > 35) ||
        currentProbPrecipitation! >= 45 ||
        [
          51,
          53,
          55,
          56,
          57,
          61,
          63,
          65,
          66,
          67,
          71,
          73,
          75,
          77,
          80,
          81,
          82,
          85,
          86,
          95,
          96,
          99,
        ].contains(currentCode);

    print(
      '🌤 Meteo: wind=$wind  temperatura:=$temp currentCode=$currentCode currentProbPrecipitation: $currentProbPrecipitation  isBadWeather=$isBadWeather',
    );
    print('📸 Selected image: ${appState.selectedImage}');

    // 🔹 Se l'utente non ha selezionato nulla, torna default
    if (appState.selectedImage == null) {
      return 'assets/images/default/1.png';
    }

    final originalPath = appState.selectedImage!;

    //  Trova la categoria e l’animale
    if (originalPath.contains('happycats')) {
      return isBadWeather
          ? originalPath.replaceFirst('happycats', 'sadcats')
          : originalPath;
    } else if (originalPath.contains('happydogs')) {
      return isBadWeather
          ? originalPath.replaceFirst('happydogs', 'saddogs')
          : originalPath;
    } else if (originalPath.contains('sadcats')) {
      return isBadWeather
          ? originalPath
          : originalPath.replaceFirst('sadcats', 'happycats');
    } else if (originalPath.contains('saddogs')) {
      return isBadWeather
          ? originalPath
          : originalPath.replaceFirst('saddogs', 'happydogs');
    }

    // 🔹 fallback
    return 'assets/images/default/1.png';
  }

  String _getWeatherString(int weatherCode) {
    //print("weathercode: $weatherCode");
    switch (weatherCode) {
      case 0:
        return "Cielo sereno";
      case 1:
      case 2:
      case 3:
        return "Parzialmente nuvoloso";
      case 45:
      case 48:
        return "Nebbia";
      case 51:
      case 53:
      case 55:
        return "Pioggia leggera";
      case 56:
      case 57:
        return "Pioggia gelata";
      case 61:
      case 63:
      case 65:
        return "Pioggia";
      case 66:
      case 67:
        return "Pioggia gelata intensa";
      case 71:
      case 73:
      case 75:
        return "Neve";
      case 77:
        return "Granelli di neve";
      case 80:
      case 81:
      case 82:
        return "Rovesci di pioggia";
      case 85:
      case 86:
        return "Rovesci di neve";
      case 95:
        return "Temporale";
      case 96:
      case 99:
        return "Temporale con grandine";
      default:
        return "codici sconosciuti";
    }
  }

  // metodo asincrono che gestisce lo stato dei widget contenenti elementi presi da API terze parti / da dipendenze esterne (librerie).
  Future<void> fetchData() async {

    //prende la posizione corrente.
    currentPosition = await LocationService().getCurrentPosition();
    await updateCurrentCity();
    if (currentPosition != null) {
      _forecast = await _weatherData.getWeatherData(currentPosition!);
    }

    // header
    header = HomePageViewModelHeader(
      city: _currentCity ?? "Località sconosciuta",
      day: _currentDay,
      temp: _forecast?.current?.temperature ?? 0,
    );

    final now = DateTime.now();
    
    DateTime targetHour = now.add(Duration(hours: 24));
    final hours = targetHour.hour;
    int startIndex = 0;

    for (int i = 0; i < hours; i++) {
      final time = _forecast!.hourly!.time![i];
      if (time.isAfter(now)) {
        startIndex = i;
        break;
      }
    }

    icon = HomePageViewModelIcon(
      icon: _getWeatherIcon(_forecast!.hourly!.weathercode![hours + 1]),
    );


    final temperatura = _forecast?.current?.temperature ?? 0;
    final hourlyCodes = _forecast?.hourly?.weathercode ?? [];
    final probPrecipitation = _forecast?.hourly?.probprecipitation ?? [];
    final vento = _forecast?.current?.windspeed ?? 0;
    final hourlyTimes = _forecast?.hourly?.time ?? [];
    final text = appState.selectedText;

    int currentCode = 0;
    if (hourlyCodes.isNotEmpty && hourlyTimes.isNotEmpty) {
      final now = DateTime.now();
      int closestIndex = 0;
      Duration minDiff = (hourlyTimes[0].difference(now)).abs();
      for (int i = 1; i < hourlyTimes.length; i++) {
        final diff = (hourlyTimes[i].difference(now)).abs();
        if (diff < minDiff) {
          minDiff = diff;
          closestIndex = i;
        }
      }
      currentCode = hourlyCodes[closestIndex];
    }

    List<int> currentProbPrecipitation = [];
    if (probPrecipitation.isNotEmpty && hourlyTimes.isNotEmpty) {
      final now = DateTime.now();
      final twoHoursLater = now.add(const Duration(hours: 2));

      // Trova tutti i valori da ora a +2 ore
      for (int i = 0; i < hourlyTimes.length; i++) {
        final t = hourlyTimes[i];
        if (t.isAfter(now.subtract(const Duration(minutes: 1))) &&
            t.isBefore(twoHoursLater.add(const Duration(minutes: 1)))) {
          currentProbPrecipitation.add(probPrecipitation[i]);
        }
      }

PromptService promptclassifier = PromptService();

      _llmRequest1 = LLMRequest1(
        model: "gpt-3.5-turbo",
        messages: [LLMMessage1(role: "user", content: promptclassifier.getClassifierTextPrompt(temperatura, vento, currentCode, currentProbPrecipitation, isBadWeather))],
        maxTokens: 4096,
        temperature: 1,
        topP: 1,
      );

      try {
        _llmResponse1 = await _llmData1.postLLMData(_llmRequest1!);
        final risposta =
            _llmResponse1?.choices?.first.message?.content
                ?.trim()
                .toLowerCase() ??
            "";

        if (risposta.contains("cattiva")) {
          isBadWeather = true;
        } else if (risposta.contains("buona")) {
          isBadWeather = false;
        } else {
          isBadWeather = false;
        }

        //print(" Risposta Prompt1: '$risposta' → isBadWeather=$isBadWeather");
      } catch (e) {
        //print("Errore nel Prompt1: $e");
        isBadWeather = false;
      }

      PromptService promptgenerationtext = PromptService();
      
      
      _llmRequest2 = LLMRequest2(
        model: "gpt-3.5-turbo",
        messages: [LLMMessage2(role: "user", content: promptgenerationtext.getGenerationTextPrompt(temperatura, vento, currentCode, currentProbPrecipitation, text!, isBadWeather))],
        maxTokens: 4096,
        temperature: 1,
        topP: 1,
      );

      try {
        _llmResponse2 = await _llmData2.postLLMData(_llmRequest2!);
        final message =
            _llmResponse2?.choices?.first.message?.content ??
            "Nessuna risposta";

        sentences = HomePageViewModelSentences(text: message);
        notifyListeners();
      } catch (e) {
        sentences = HomePageViewModelSentences(text: "Errore: $e");
        notifyListeners();
      }

      container1 = HomePageViewModelContainerCOR(
        title: "Chance of rain:",
        iconmeteo: Icons.wb_cloudy,
        value: [_currentProbPrecipitation ?? 101],
      ); //_forecast?.hourly?.probprecipitation ?? []);

      container2 = HomePageViewModelContainerHumidity(
        title: "Humidity:",
        iconmeteo: Icons.water_drop,
        value: _forecast?.current?.relativehumidity ?? 0,
      );

      container3 = HomePageViewModelContainer(
        title: "Feels like:",
        iconmeteo: Icons.thermostat,
        value: _forecast?.current?.apparenttemperature ?? 0,
      );

      container4 = HomePageViewModelContainer(
        title: "Wind:",
        iconmeteo: Icons.air,
        value: _forecast?.current?.windspeed ?? 0,
      );

      image = HomePageViewModelImage(
        imagePath: getImageForConditions(appState),
      );
      notifyListeners();

      //-------------------------------------------------------------------
      int lengthdaily = _forecast?.daily?.weathercode?.length ?? 0;

      weatherdaily = List.generate(lengthdaily, (index) {
        DateTime dayTime = _forecast!.daily!.time![index];
        final days = ['Dom', 'Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab'];
        String dayName = days[dayTime.weekday % 7];

        if (_forecast?.daily?.weathercode! != null) {
          return HomePageViewModelWeatherDaily(
            day: dayName,
            icon: _getWeatherIcon(_forecast?.daily?.weathercode?[index] ?? 0),
            temp: _forecast!.daily!.temperaturemax![index],
          );
        }
        return HomePageViewModelWeatherDaily(
          day: '',
          icon: Icons.help,
          temp: 0,
        ); // fallback
      });
      //------------------------------------------------------------------------
      int lengthhourly = _forecast?.hourly?.weathercode?.length ?? 0;
      int limit = lengthhourly > 24 ? 24 : lengthhourly;

      weatherhourly = List.generate(limit, (index) {
        final now = DateTime.now().toUtc();
        final timesUtc = _forecast!.hourly!.time!
            .map((t) => t.toUtc())
            .toList();

        // Trova l'indice dell'orario più vicino a "adesso"
        int startIndex = 0;
        Duration minDiff = (timesUtc[0].difference(now)).abs();

        for (int i = 1; i < timesUtc.length; i++) {
          // cicla il vettore temporale
          final diff = (timesUtc[i].difference(now)).abs();
          if (diff < minDiff) {
            minDiff = diff;
            startIndex = i; // adesso startIndex punta al tempo più vicino a ora
          }
        }

        final pos = (startIndex + index).clamp(
          0,
          _forecast!.hourly!.temperature!.length - 1,
        );
        final time = _forecast!.hourly!.time![pos]
            .toLocal(); // converti in locale
        final formattedHour =
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

        if (_forecast?.hourly?.weathercode! != null) {
          return HomePageViewModelWeatherHourly(
            hour: formattedHour, // Ora formattata
            icon: _getWeatherIcon(_forecast!.hourly!.weathercode![pos]),
            temp: _forecast!.hourly!.temperature![pos].round(),
          );
        }
        return HomePageViewModelWeatherHourly(
          hour: '',
          icon: Icons.help,
          temp: 0,
        );
      });
    }
  }

  //---------------------------------------------------------------------
  Future<void> updateCurrentCity() async {
    if (currentPosition == null) return;
    try {
      final city = await _locationService.getCityName(currentPosition!);
      _currentCity = city;
      notifyListeners();
    } catch (e) {
      _currentCity = 'Località sconosciuta';
    }
  }

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

//----------------------------------------------------------------------
class HomePageViewModelHeader {
  String? city;
  String? day;
  double? temp;

  HomePageViewModelHeader({
    required this.city,
    required this.day,
    required this.temp,
  });
}

class HomePageViewModelIcon {
  IconData icon;

  HomePageViewModelIcon({required this.icon});
}

class HomePageViewModelImage {
  String? imagePath;

  HomePageViewModelImage({required this.imagePath});
}

class HomePageViewModelSentences {
  String? text;

  HomePageViewModelSentences({required this.text});
}

class HomePageViewModelContainerCOR {
  String? title;
  IconData? iconmeteo;
  List<int>? value;

  HomePageViewModelContainerCOR({
    required this.title,
    required this.iconmeteo,
    required this.value,
  });
}

class HomePageViewModelContainerHumidity {
  String? title;
  IconData? iconmeteo;
  int? value;

  HomePageViewModelContainerHumidity({
    required this.title,
    required this.iconmeteo,
    required this.value,
  });
}

class HomePageViewModelContainer {
  String? title;
  IconData? iconmeteo;
  double? value;

  HomePageViewModelContainer({
    required this.title,
    required this.iconmeteo,
    required this.value,
  });
}

class HomePageViewModelWeatherHourly {
  String hour;
  IconData icon;
  int temp;

  HomePageViewModelWeatherHourly({
    required this.hour,
    required this.icon,
    required this.temp,
  });
}

class HomePageViewModelWeatherDaily {
  String day;
  IconData icon;
  int temp;

  HomePageViewModelWeatherDaily({
    required this.day,
    required this.icon,
    required this.temp,
  });
}
