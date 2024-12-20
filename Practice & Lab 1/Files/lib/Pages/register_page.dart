import 'package:flutter/material.dart';
import '../Components/text_field.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        CustomTextField(
          labelText: "Full name"
        ),
        const SizedBox(height: 24),
        CustomTextField(
          labelText: "Email address"
        ),
        const SizedBox(height: 24),
        CustomTextField(
          labelText: "Password",
          isObscure: true,
        ),
        const SizedBox(height: 24),
        CustomTextField(
          labelText: "Confirm password",
          isObscure: true,
        ),
        const SizedBox(height: 43),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF192252),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: Text(
            "Register",
            style: TextStyle(
              fontFamily: "Urbanist",
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        isMobile 
          ? const Spacer() 
          : const SizedBox(height: 200),
        Center(
          child: TextButton(
            onPressed: () {},
            child: RichText(
              text: TextSpan(
                text: "Already have an account? ",
                style: TextStyle(
                  fontFamily: "Urbanist",
                  color: Color(0xFF424F7B),
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "Login",
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Register",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF192252)
          ),
        ),
        elevation: 0,
        leading: SizedBox(
          width: 45,
          height: 45,
          child: IconButton(
            icon: Image.asset('assets/images/backIcon.png'),
            onPressed: () {},
          ),
        ),
      ),
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