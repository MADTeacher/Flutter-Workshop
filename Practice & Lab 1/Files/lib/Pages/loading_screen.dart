import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/car.png',
                width: 50,
                height: 50,
                color: const Color(0xFF1B588C),
                colorBlendMode: BlendMode.srcATop,
              ),
              const SizedBox(width: 10),
              const Text(
                "Rent Car App",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1B588C),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
