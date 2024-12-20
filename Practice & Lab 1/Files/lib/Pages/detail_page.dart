import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final PageController _pageController = PageController();

  double _calculateDynamicHeight(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 400) {
      return 200;
    } else if (screenWidth > 800) {
      return 600;
    } else {
      return 200 + (screenWidth - 400) * (400 / 400);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.chevron_left,
                          size: 30,
                          color: Color(0xFF192252),
                        ),
                      ),
                    ),
                  ),
                ),
                expandedHeight: _calculateDynamicHeight(context),
                floating: false,
                pinned: true,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    var top = constraints.biggest.height;
                    return FlexibleSpaceBar(
                      title: AnimatedOpacity(
                        opacity: top <= kToolbarHeight + 50 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                      ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          PageView(
                            controller: _pageController,
                            children: [
                              Image.asset(
                                'assets/images/bmwm5.jpg',
                                fit: BoxFit.cover,
                              ),
                              Image.asset(
                                'assets/images/bmwm5.jpg',
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: SmoothPageIndicator(
                                controller: _pageController,
                                count: 2,
                                effect: const ExpandingDotsEffect(
                                  expansionFactor: 4.0,
                                  activeDotColor: Color(0xFF192252),
                                  dotColor: Color(0xFFD9D9D9),
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  spacing: 8.0,
                                ),
                              ),
                            ),
                          ),
                          IgnorePointer(
                            child: Container(
                              color: Colors.white.withOpacity(
                                top <= kToolbarHeight + 50 ? 1.0 : 0.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          "BMW M5 F90, 2022",
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF192252),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const ImageIcon(
                              AssetImage('assets/images/star.png'),
                              size: 30,
                              color: Color(0xFFFFBD16),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(3, 0, 10, 0),
                              child: Text(
                                '5.0',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFFFFBD16),
                                ),
                              ),
                            ),
                            Text(
                              "(100+ reviews)",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF192252),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                        child: Text(
                          "Experience the ultimate combination of luxury, power, and precision with the BMW M5 F90. "
                          "This high-performance sports sedan features a twin-turbocharged 4.4L V8 engine, delivering an exhilarating 600 horsepower for an unforgettable drive. "
                          "Equipped with BMW’s signature xDrive all-wheel-drive system, the M5 F90 ensures both stability and thrilling speed in any road condition.\n\n"
                          "Inside, enjoy a sophisticated, tech-forward interior with premium leather seating, a state-of-the-art infotainment system, and advanced safety features. "
                          "Whether you’re navigating city streets or taking a weekend getaway, the BMW M5 F90 offers unparalleled comfort and driving dynamics.\n\n"
                          "Book today and elevate your driving experience with the power and luxury of the M5 F90!",
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF848FAC),
                            fontSize: 15,
                            fontFamily: 'Urbanist',
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(16, 5, 16, 20),
                          child: Text(
                            "CAR INFO",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF192252),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 150),
                        child: Column(
                          children: [
                            infoRow(
                                label: "Engine", value: "4.4L twin-turbo V8"),
                            const SizedBox(height: 20),
                            infoRow(label: "Power", value: "600hp"),
                            const SizedBox(height: 20),
                            infoRow(label: "Fuel", value: "Casoline"),
                            const SizedBox(height: 20),
                            infoRow(label: "Color", value: "Dark Blue"),
                            const SizedBox(height: 20),
                            infoRow(
                                label: 'Drivetrain',
                                value: "xDrive All-Wheel Drive"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "BMW M5 F90, 2022",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF192252),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '22 000 ₽ / day',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF192252),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF192252),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 14),
                        child: Text(
                          "Rent Car",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget infoRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF848FAC),
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF192252),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
