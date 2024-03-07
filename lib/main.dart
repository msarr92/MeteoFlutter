import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
      ),
      body: Stack(
        children: [
          // Fond bleu avec un dégradé
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.shade300, Colors.blue.shade800],
              ),
            ),
          ),
          // Animation de soleil
          Positioned(
            top: 100, // Ajustez la position verticale selon vos besoins
            left: 0,
            right: 0,
            child: SunAnimation(),
          ),
          // Contenu centré
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bienvenue sur l\'écran d\'accueil !',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => ProgressScreen());
                  },
                  child:const Text('Aller à l\'écran de progression'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Animation de soleil
class SunAnimation extends StatefulWidget {
  @override
  _SunAnimationState createState() => _SunAnimationState();
}

class _SunAnimationState extends State<SunAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:const Duration(seconds: 5),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -20, end: 20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value, 0),
          child:const Icon(
            Icons.wb_sunny,
            size: 100,
            color: Colors.yellow,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  double _progress = 0.0;
  List<String> messages = [
    'Nous téléchargeons les données…',
    'C’est presque fini…',
    'Plus que quelques secondes avant d’avoir le résultat…'
  ];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startProgress();
    _startMessages();
  }

  void _startProgress() {
    const duration = Duration(seconds: 1);
    const totalSeconds = 60;
    int secondsElapsed = 0;

    Timer.periodic(duration, (Timer timer) {
      setState(() {
        _progress = secondsElapsed / totalSeconds;
        secondsElapsed++;

        if (secondsElapsed > totalSeconds) {
          timer.cancel();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CityListScreen()),
          );
        }
      });
    });
  }

  void _startMessages() {
    const duration = Duration(seconds: 6);
    Timer.periodic(duration, (Timer timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % messages.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Écran de progression'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                messages[currentIndex],
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 200, // Largeur fixe du conteneur
              height: 20, // Hauteur fixe du conteneur
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow), // Bordure
                borderRadius: BorderRadius.circular(10), // Coins arrondis
              ),
              child: Stack(
                children: [
                  // Barre de progression
                  Container(
                    width: _progress * 200, // Largeur dynamique en fonction de _progress
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.blue, // Couleur de la barre de progression
                      borderRadius: BorderRadius.circular(10), // Coins arrondis
                    ),
                  ),
                  // Pourcentage
                  Center(
                    child: Text(
                      '${(_progress * 100).toInt()}%', // Conversion en pourcentage entier
                      style: const TextStyle(color: Colors.black26),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CityListScreen extends StatelessWidget {
  final List<String> cities = [
    'Rennes',
    'Paris',
    'Nantes',
    'Bordeaux',
    'Lyon',
    'Dakar',
    'Canada',
    'Gambie',
    'Touba',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des villes')),
      backgroundColor: Colors.blue, // Fond bleu
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              const SizedBox(height: 10), // Espace entre les villes
              Container(
                color: Colors.white, // Fond blanc pour chaque ville
                child: ListTile(
                  title: Text(
                    cities[index],
                    style:const TextStyle(color: Colors.black), // Texte gris
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CityDetailScreen(city: cities[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }




}

class CityDetailScreen extends StatefulWidget {
  final String city;

  CityDetailScreen({required this.city});

  @override
  _CityDetailScreenState createState() => _CityDetailScreenState();
}

class _CityDetailScreenState extends State<CityDetailScreen> {
  late Future<WeatherData> _weatherData;

  @override
  void initState() {
    super.initState();
    _weatherData = fetchWeatherData(widget.city);
  }

  Future<WeatherData> fetchWeatherData(String city) async {
    final apiKey = '7186600ed8e91b27645f49677b6cb2f7';
    final url ='https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détails de la ville')),
      backgroundColor: Colors.blue, // Fond bleu
      body: Center(
        child: FutureBuilder<WeatherData>(
          future: _weatherData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: Text(
                      'Nom de la ville : ${widget.city}',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      key: UniqueKey(),
                    ),
                  ),
                  SizedBox(height: 10),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: Text(
                      'Température : ${snapshot.data!.temperature}°C',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      key: UniqueKey(),
                    ),
                  ),
                  SizedBox(height: 10),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: Text(
                      'Couverture nuageuse : ${snapshot.data!.cloudiness}',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      key: UniqueKey(),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Erreur : ${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }


}

class WeatherData {
  final double temperature;
  final String cloudiness;

  WeatherData({required this.temperature, required this.cloudiness});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: json['main']['temp'],
      cloudiness: json['weather'][0]['description'],
    );
  }
}




