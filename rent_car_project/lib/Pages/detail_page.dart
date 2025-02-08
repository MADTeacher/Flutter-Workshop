import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Models/car_model.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  
  final Car car;

  const DetailPage({super.key, required this.car});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final PageController _pageController = PageController();

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
                expandedHeight: 260,
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
                            children: widget.car.imageUrl.map((image) {
                              return Image.network(
                                image,
                                fit: BoxFit.cover,
                              );
                            }).toList(),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: widget.car.imageUrl.length > 1 
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: SmoothPageIndicator(
                                      controller: _pageController,
                                      count: widget.car.imageUrl.length,
                                      effect: const ExpandingDotsEffect(
                                        expansionFactor: 4.0,
                                        activeDotColor: Color(0xFF192252),
                                        dotColor: Color(0xFFD9D9D9),
                                        dotHeight: 8,
                                        dotWidth: 8,
                                        spacing: 8.0,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          IgnorePointer(
                            child: Container(
                              color: Colors.white.withOpacity(top <= kToolbarHeight + 50 ? 1.0 : 0.0),
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
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          widget.car.name,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF192252),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                             const ImageIcon(
                              AssetImage('assets/images/star.png'),
                              size: 30,
                              color: Color(0xFFFFBD16),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${widget.car.rating}',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color(0xFFFFBD16),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '(${widget.car.reviewCount > 100 ? 100 : widget.car.reviewCount}+ reviews)',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF192252),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        child: Text(widget.car.description,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF848FAC),
                            fontSize: 15,
                            fontFamily: 'Urbanist'
                            ),
                          ),
                        ),
                      const Padding(
                        padding: EdgeInsets.only(top: 5, left: 16, right: 16, bottom: 20),
                        child: Text(
                          'CAR INFO',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF192252),
                          ),
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 150, left: 16, right: 16),
                        child: Column(
                          children: [
                            InfoRow(label: 'Engine', value: widget.car.engine),
                            const SizedBox(height: 20),
                            InfoRow(label: 'Power', value: '${widget.car.power} hp'),
                            const SizedBox(height: 20),
                            InfoRow(label: 'Fuel', value: widget.car.fuel),
                            const SizedBox(height: 20),
                            InfoRow(label: 'Color', value: widget.car.color),
                            const SizedBox(height: 20),
                            InfoRow(label: 'Drivetrain', value: widget.car.drivetrain),
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
                          widget.car.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF192252),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${NumberFormat('#,###', 'ru_RU').format(widget.car.rentalPricePerDay)} ₽ / day',
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
                      onPressed: () {
    
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 14),
                        child: Text(
                          'Rent Car',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white
                          ),
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
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF848FAC),
            fontWeight: FontWeight.normal,
          ),
        ),
        const Spacer(),
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
