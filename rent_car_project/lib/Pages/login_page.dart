import 'package:flutter/material.dart';
import '../Services/auth_service.dart';
import 'tab_bar.dart';
import '../Components/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // Для использования kIsWeb
import 'dart:io'; // Для проверки платформы

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final NetworkService _authService = NetworkService(); 

  bool isButtonEnabled = false; 

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkFields);
    _passwordController.addListener(_checkFields);
  }

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final result = await _authService.login(email, password);

    if (result['success']) {

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const CustomBottomNavigationBar()),
        (Route<dynamic> route) => false,
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: Text(result['error'] ?? 'Login failed. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  // Future<void> _saveLoginState(int userId, String email, String password) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isLogged', true);
  //   await prefs.setInt('userId', userId);
  //   await prefs.setString('email', email); // Сохраняем email
  //   await prefs.setString('password', password); // Сохраняем password
  // }

  void _checkFields() {
    setState(() {
      isButtonEnabled = 
      _emailController.text.isNotEmpty && 
      _passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 82),
        const Text(
          "Welcome!\nLogin to your account,\nOr create new one",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B588C),
          ),
        ),
        const SizedBox(height: 62),
        CustomTextField(
          controller: _emailController, 
          labelText: 'Email address'
        ),
        const SizedBox(height: 25),
        CustomTextField(
          controller: _passwordController, 
          labelText: 'Password',
          isObscure: true,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Forgot password?',
              style: TextStyle(
                color: const Color.fromARGB(255, 178, 188, 222).withOpacity(0.7),
                fontFamily: "Urbanist",
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 9),
        Center(
          child: Opacity(
            opacity: isButtonEnabled ? 1.0 : 0.5,
            child: ElevatedButton(
              onPressed: isButtonEnabled ? _login : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF192252),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontFamily: "Urbanist",
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 53),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: const Color(0xFF424F7B).withOpacity(0.5),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "or login with",
                style: TextStyle(
                  color: Color(0xFF424F7B),
                  fontFamily: "Urbanist",
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: const Color(0xFF424F7B).withOpacity(0.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: IconButton(
                icon: Image.asset('assets/images/google_icon.png'),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 50,
              height: 50,
              child: IconButton(
                icon: Image.asset('assets/images/vk_icon.png'),
                onPressed: () {},
              ),
            ),
          ],
        ),
        isMobile 
          ? const Spacer()
          : const SizedBox(height: 100),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: RichText(
              text: const TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(
                  fontFamily: "Urbanist",
                  color: Color(0xFF424F7B),
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Register',
                    style: TextStyle(
                      fontFamily: "Urbanist",
                      color: Color(0xFF103F74),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isMobile 
            ? content
            : SingleChildScrollView(
                child: content,
              ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}