import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            top: 117,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double screenWidth = constraints.maxWidth;
                          double blockHeight =
                              (screenWidth / 3).clamp(200, 400);
                          double imageHeight =
                              (blockHeight - 50).clamp(150, 350);

                          return SizedBox(
                            height: blockHeight,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: 4,
                              onPageChanged: (int index) {
                                setState(() {});
                              },
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: imageHeight,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/bmwm5.jpg'),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "New car in rent - M5 F90",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Urbanist",
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 10, 8, 27),
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 4,
                        effect: const ExpandingDotsEffect(
                          expansionFactor: 4.0,
                          activeDotColor: Color(0xFF192252),
                          dotColor: Color(0xFFD9D9D9),
                          dotHeight: 8,
                          dotWidth: 8,
                          spacing: 4.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Popular cars",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "see all",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF192252),
                                fontFamily: "Urbanist",
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 22),
                      child: SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/detailPage');
                              },
                              child: carCard(
                                context: context,
                                imageUrl: 'assets/images/bmwm5.jpg',
                                title: "BMW M5",
                                price: 22000,
                                rating: "5",
                                numOfReviews: "100",
                                isHorizontalScroll: true,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 0, 22),
                      child: Text(
                        "All cars",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF192252),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double screenWidth = constraints.maxWidth;
                          int crossAxisCount = (screenWidth ~/ 180)
                              .clamp(2, double.infinity)
                              .toInt();

                          return GridView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              mainAxisSpacing: 22,
                              crossAxisSpacing: 8,
                              childAspectRatio: 180 / 220,
                            ),
                            itemCount: 8,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/detailPage');
                                },
                                child: carCard(
                                    context: context,
                                    imageUrl: 'assets/images/bmwm5.jpg',
                                    title: "BMW M5",
                                    price: 22000,
                                    rating: "5",
                                    numOfReviews: "100",
                                    isHorizontalScroll: false),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
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
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Your location",
                        style: TextStyle(
                          color: Color(0xFF848FAC),
                          fontSize: 18,
                          fontFamily: "Urbanist",
                        ),
                      ),
                      SizedBox(width: 10),
                      ImageIcon(AssetImage('assets/images/arrow-down.png')),
                    ],
                  ),
                  Text(
                    "Moscow, Russia",
                    style: TextStyle(
                      color: Color(0xFF192252),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const ImageIcon(
                    AssetImage('assets/images/search.png'),
                    color: Color(0xFF192252),
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const ImageIcon(
                    AssetImage('assets/images/sms.png'),
                    color: Color(0xFF192252),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget carCard({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required int price,
    required String rating,
    required String numOfReviews,
    bool isHorizontalScroll = false,
  }) {
    int numOfReviewsInt = int.parse(numOfReviews.replaceAll(RegExp(r'\D'), ''));
    String formattedReviews;
    if (numOfReviewsInt >= 100) {
      formattedReviews = "(100+ reviews)";
    } else if (numOfReviewsInt == 1) {
      formattedReviews = "($numOfReviews) review";
    } else {
      formattedReviews = "($numOfReviews) reviews";
    }

    return Container(
      width: 180,
      height: 219,
      margin: isHorizontalScroll
          ? const EdgeInsets.only(right: 16, bottom: 10, left: 8)
          : const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF192252),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                const ImageIcon(
                  AssetImage('assets/images/star.png'),
                  color: Color(0xFFFFBD16),
                ),
                const SizedBox(width: 3),
                Text(
                  rating,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFFFFBD16),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  formattedReviews,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF192252),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
            child: Text(
              '$price ₽ / day',
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF192252),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
