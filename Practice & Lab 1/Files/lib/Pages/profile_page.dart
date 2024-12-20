import 'package:flutter/material.dart';
// import 'package:rent_car_project/Pages/edit_user_page.dart';
import '../Components/custom_button.dart';
import '../Components/custom_action_button.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
// import '../Services/auth_service.dart';
// import '../generated/l10n.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // final NetworkService _networkService = NetworkService();
  // String? fullName;
  // String? email;
  // String? profileImageUrl;
  // bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    Widget content = Column(
      children: [
        Container(
          padding: const EdgeInsets.all(25.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF1B588C), Color(0xFF848FAC)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              ClipOval(
                child: SizedBox.fromSize(
                    size: const Size.fromRadius(24),
                    child: Image.asset('assets/images/userPhoto.jpg')
                    ),
              ),
              const SizedBox(width: 13),
              Text(
                'Anna Montana',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const Spacer(),
              const ImageIcon(
                AssetImage('assets/images/edit.png'),
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        CustomButton(
          iconPath: 'assets/images/lock-circle.png',
          label: "Change password",
          onTap: () {},
        ),
        const SizedBox(height: 21),
        CustomButton(
          iconPath: 'assets/images/empty-wallet.png',
          label: "Billing information",
          onTap: () {},
        ),
        const SizedBox(height: 21),
        CustomButton(
          iconPath: 'assets/images/direct-inbox.png',
          label: "Notifications",
          onTap: () {},
        ),
        isMobile ? const Spacer() : const SizedBox(height: 250),
        CustomActionButton(
          label: "Log Out",
          isPrimary: true,
          onTap: () async {},
        ),
        const SizedBox(height: 20),
        CustomActionButton(
          label: "Delete account",
          isPrimary: false,
          onTap: () async {},
        ),
        isMobile ? const SizedBox(height: 50) : const SizedBox(height: 0)
      ],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Color(0xFF192252),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: isMobile
                  ? content
                  : SingleChildScrollView(
                      child: content,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
