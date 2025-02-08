import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Services/auth_service.dart';
import '../Models/car_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final PageController _pageController = PageController();
  NetworkService networkService = NetworkService();

  List<Map<String, dynamic>> allPromotions = [];
  List<Car> popularCars = [];
  List<Car> allCars = [];

  bool isLoading = true;

  final String baseURL = 'http://localhost:8080/';

  List<Car> convertToCarList(List<Map<String, dynamic>> carData) {
    return carData.map((data) {
      return Car(
        name: data['name'],
        imageUrl: data['photos'].isNotEmpty ? List<String>.from(data['photos'].map((photo) => baseURL + photo)) : [''],
        rentalPricePerDay: (data['rentalPricePerDay'] as num).toInt(),
        rating: data['rating'].toDouble(),
        reviewCount: (data['reviewCount'] as num).toInt(),
        description: data['description'],
        engine: data['engineType'],
        power: data['power'],
        fuel: data['fuelType'],
        color: data['color'],
        drivetrain: data['driveType'],
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchPromotions();
    fetchCarsData();
  }

  Future<void> fetchCarsData() async {
    List<Map<String, dynamic>> popular = await networkService.getPopularCars();
    List<Map<String, dynamic>> all = await networkService.getAllCars();

    setState(() {
      popularCars = convertToCarList(popular);
      allCars = convertToCarList(all);
      isLoading = false;
    });
  }

  Future<void> fetchPromotions() async {
    List<Map<String, dynamic>> promotions = await networkService.getPromotions();

    setState(() {
      allPromotions = promotions;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    await fetchPromotions();
    await fetchCarsData();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Your location',
                  style: TextStyle(
                    color: Color(0xFF848FAC), 
                    fontSize: 18,
                    fontFamily: "Urbanist"
                  ),
                ),
                SizedBox(width: 10),
                ImageIcon(
                  AssetImage('assets/images/arrow-down.png')
                )
              ],
            ),
            Text(
              'Moscow, Russia',
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            double screenWidth = constraints.maxWidth;
                            double blockHeight = (screenWidth / 3).clamp(200, 400);
                            double imageHeight = (blockHeight - 50).clamp(150, 350);

                            return SizedBox(
                              height: blockHeight,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: allPromotions.length,
                                onPageChanged: (int index) {
                                  setState(() {});
                                },
                                itemBuilder: (context, index) {
                                  final promotion = allPromotions[index];
                                  final imageUrl = promotion['photo'] ?? '';
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: imageHeight,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            color: imageUrl.isNotEmpty ? null : Colors.grey,
                                            image: imageUrl.isNotEmpty ? DecorationImage(
                                              image: NetworkImage('$baseURL$imageUrl'), 
                                              fit: BoxFit.cover) : null,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          promotion['name'] ?? 'No Name',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Urbanist",
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: allPromotions.length > 1 ? SmoothPageIndicator(
                              controller: _pageController,
                              count: allPromotions.length,
                              effect: const ExpandingDotsEffect(
                                expansionFactor: 4.0,
                                activeDotColor: Color(0xFF192252),
                                dotColor: Color(0xFFD9D9D9),
                                dotHeight: 8,
                                dotWidth: 8,
                                spacing: 4.0,
                              ),
                            ) : const SizedBox.shrink(),
                          ),
                        ),
                        const SizedBox(height: 27),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Popular cars',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'see all',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF192252),
                                  fontFamily: "Urbanist",
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 22),
                          child: SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: popularCars.length,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context, 
                                      '/detailPage',
                                      arguments: popularCars[index],
                                    );
                                  },
                                  child: carCard(
                                    imageUrl: popularCars[index].imageUrl[0],
                                    title: popularCars[index].name,
                                    price: popularCars[index].rentalPricePerDay,
                                    rating: popularCars[index].rating.toString(),
                                    numOfReviews: '(${popularCars[index].reviewCount} reviews)',
                                    isHorizontalScroll: true,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(8, 0, 22, 8),
                          child: Text(
                            'All cars',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF192252),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double screenWidth = constraints.maxWidth;
                              int crossAxisCount = (screenWidth ~/ 180).clamp(2, double.infinity).toInt();

                              return GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  mainAxisSpacing: 22,
                                  crossAxisSpacing: 8,
                                  childAspectRatio: 180 / 220,
                                ),
                                itemCount: allCars.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context, 
                                        '/detailPage',
                                        arguments: allCars[index],
                                      );
                                    },
                                      child: carCard(
                                      imageUrl: allCars[index].imageUrl[0],
                                      title: allCars[index].name,
                                      price: allCars[index].rentalPricePerDay,
                                      rating: allCars[index].rating.toString(),
                                      numOfReviews: '(${allCars[index].reviewCount} reviews)',
                                      isHorizontalScroll: false
                                      ,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  static Widget carCard({
    required String imageUrl,
    required String title,
    required int price,
    required String rating,
    required String numOfReviews,
    bool isHorizontalScroll = false,
  }) {
    String formattedReviews = int.parse(numOfReviews.replaceAll(RegExp(r'\D'), '')) >= 100
        ? '(100+ reviews)'
        : '($numOfReviews reviews)';

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
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
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
          const SizedBox(height: 8),
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
              '${NumberFormat('#,###', 'ru_RU').format(price)} ₽ / day',
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
