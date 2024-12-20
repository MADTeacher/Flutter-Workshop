import 'package:flutter/material.dart';
import '../Components/text_field.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'tab_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 82, 0, 62),
          child: Text(
            "Welcome!\nLogin to your account,\nOr create new one",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B588C),
            ),
          ),
        ),
        CustomTextField(labelText: "Email address"),
        const SizedBox(height: 25),
        CustomTextField(
          labelText: "Password",
          isObscure: true,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(
              "Forgot password?",
              style: TextStyle(
                color: const Color(0xFF424F7B).withOpacity(0.7),
                fontFamily: "Urbanist",
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 9, 0, 53),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const CustomBottomNavigationBar()),
                (Route<dynamic> route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF192252),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(
              "Login",
              style: TextStyle(
                fontFamily: "Urbanist",
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: const Color(0xFF424F7B).withOpacity(0.5),
              ),
            ),
            Padding(
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
        isMobile ? const Spacer() : const SizedBox(height: 100),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(
                  fontFamily: "Urbanist",
                  color: Color(0xFF424F7B),
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "Register",
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
    super.dispose();
  }
}
