import 'package:flutter/material.dart';
import 'package:meteo/screens/city_detail_screen.dart';


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