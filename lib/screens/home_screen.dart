import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meteo/screens/progress_screen.dart';

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
