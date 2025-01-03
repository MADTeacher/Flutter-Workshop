import 'package:flutter/material.dart';
import 'login_page.dart';
import 'tab_bar.dart';
import '../Services/network_service.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final networkService = NetworkService();

  @override
  void initState() {
    super.initState();
    _attemptAutoLogin();
  }

  Future<void> _attemptAutoLogin() async {
    final result = await networkService.autoLogin();

    Future.delayed(const Duration(seconds: 3), () {
      if (result['success']) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const CustomBottomNavigationBar()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
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
