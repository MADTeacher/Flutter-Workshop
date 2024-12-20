import 'dart:io';
import 'package:flutter/material.dart';
import '../Components/text_field.dart';
import '../Components/custom_action_button.dart';
import 'package:flutter/foundation.dart';

class EditUserPage extends StatefulWidget {

  const EditUserPage({super.key});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    var content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Update user info",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Color(0xFF192252),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: const DecorationImage(
                image: AssetImage(
                    'assets/images/userPhoto.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.camera_alt,
                color: Colors.white.withOpacity(0.7),
                size: 50,
              ),
            ),
          ),
          const SizedBox(height: 35),
          CustomTextField(
            labelText: "Full name",
            initialText: "Enter your name",
          ),
          const SizedBox(height: 25),
          CustomTextField(
            labelText: "Email address",
            initialText: "Enter your email",
          ),
          isMobile ? const Spacer() : SizedBox(height: 220),
          CustomActionButton(
            label: "Update info",
            isPrimary: true,
            onTap: () {},
          ),
          const SizedBox(height: 55),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: IconButton(
                icon: Image.asset('assets/images/backIcon.png'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: isMobile ? content : SingleChildScrollView(child: content),
    );
  }
}
