import 'package:flutter/material.dart';
import 'home_page.dart';
import 'profile_page.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const Text('Car Rent Tab Content'),
    const Text('Chat Tab Content'),
    const ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    double bottomPosition = screenHeight > 737 ? -20 : -10;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomPosition,
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                selectedItemColor: const Color(0xFF192252),
                unselectedItemColor: const Color(0xFF848FAC),
                elevation: 0,
                onTap: _onItemTapped,
                backgroundColor: const Color.fromARGB(255, 242, 242, 242),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('assets/images/home.png')),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('assets/images/carRent.png')),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('assets/images/chat.png')),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('assets/images/profile.png')),
                    label: '',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}