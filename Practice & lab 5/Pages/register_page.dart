import 'package:flutter/material.dart';
import '../Services/auth_service.dart';
import 'tab_bar.dart';
import '../Components/text_field.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../generated/l10n.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final NetworkService _authService = NetworkService();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(_checkFields);
    _emailController.addListener(_checkFields);
    _passwordController.addListener(_checkFields);
    _confirmPasswordController.addListener(_checkFields);
  }

  void _checkFields() {
    setState(() {
      isButtonEnabled = 
      _fullNameController.text.isNotEmpty && 
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty;
    });
  }

  Future<void> _register() async {
    final fullName = _fullNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    final result = await _authService.register(fullName, email, password, confirmPassword);

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
            title: Text(S.of(context).registrationFailed),
            content: Text(result['error'] ?? S.of(context).registrationFailedPleaseTryAgain),
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

  @override
  Widget build(BuildContext context) {
    bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        CustomTextField(
          controller: _fullNameController, 
          labelText: S.of(context).fullName
        ),
        const SizedBox(height: 24),
        CustomTextField(
          controller: _emailController, 
          labelText: S.of(context).emailAdress
        ),
        const SizedBox(height: 24),
        CustomTextField(
          controller: _passwordController, 
          labelText: S.of(context).password,
          isObscure: true,
        ),
        const SizedBox(height: 24),
        CustomTextField(
          controller: _confirmPasswordController, 
          labelText: S.of(context).confirmPassword,
          isObscure: true,
        ),
        const SizedBox(height: 43),
        Center(
          child: Opacity(
            opacity: isButtonEnabled ? 1.0 : 0.5,
            child: ElevatedButton(
              onPressed: isButtonEnabled ? _register : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF192252),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                S.of(context).registerBtn,
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
        isMobile 
          ? const Spacer() 
          : const SizedBox(height: 200),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: RichText(
              text: TextSpan(
                text: S.of(context).alreadyHaveAnAccount,
                style: TextStyle(
                  fontFamily: "Urbanist",
                  color: Color(0xFF424F7B),
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: S.of(context).login,
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
          S.of(context).registerTitle,
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
            onPressed: () {
              Navigator.pop(context);
            },
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
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
