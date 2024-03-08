import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




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
