import 'package:flutter/material.dart';
import 'package:rent_car_project/Pages/edit_user_page.dart';
import '../Components/custom_button.dart';
import '../Components/custom_action_button.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../Services/network_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final networkService = NetworkService();
  String? fullName;
  String? email;
  String? profileImageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final response = await networkService.getUserData();

    if (response['success'] == true) {
      setState(() {
        fullName = response['userData']['fullName'];
        email = response['userData']['email'];
        profileImageUrl = response['userData']['photo'] != null &&
                response['userData']['photo'].isNotEmpty
            ? 'http://localhost:8080/${response['userData']['photo']}'
            : null;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['error'] ?? 'Failed to load user data'),
        ),
      );
    }
  }

  Future<void> _logout() async {
    final response = await networkService.logout();

    if (response['success'] == true) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['error'] ?? 'Logout failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    Widget content = Column(
      children: [
        InkWell(
          onTap: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditUserPage(
                          initialFullName: fullName,
                          initialEmail: email,
                          initialProfileImageUrl: profileImageUrl,
                        )));
            _loadUserData();
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
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
                    child:
                        profileImageUrl != null && profileImageUrl!.isNotEmpty
                            ? Image.network(
                                profileImageUrl!,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.grey[300],
                              ),
                  ),
                ),
                const SizedBox(width: 13),
                Text(
                  fullName ?? 'Loading...',
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
        isMobile ? const Spacer() : const SizedBox(height: 130),
        Column(
          children: [
            CustomActionButton(
              label: "Log Out",
              isPrimary: true,
              onTap: () async {
                await _logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (Route<dynamic> route) => false,
                );
              },
            ),
            const SizedBox(height: 20),
            CustomActionButton(
              label: "Delete account",
              isPrimary: false,
              onTap: () async {
                await _logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 120),
      ],
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
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
          ),
          Positioned(
            top: isMobile ? 0 : 59,
            left: 0,
            right: 0,
            child: AppBar(
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
          ),
        ],
      ),
    );
  }
}
