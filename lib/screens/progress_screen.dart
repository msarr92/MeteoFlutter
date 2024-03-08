import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meteo/screens/city_list_screen.dart';




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