import 'package:car_yatri1/Screen/home/widget/airportTrip.dart';
import 'package:car_yatri1/Screen/home/widget/localTrip.dart';
import 'package:car_yatri1/Screen/home/widget/outStation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingTab extends StatefulWidget {
  const BookingTab({Key? key}) : super(key: key);

  @override
  State<BookingTab> createState() => _BookingTabState();
}

class _BookingTabState extends State<BookingTab> {
  List<String> items = [
    "Destination\nTrip",
    "Local\ntrip",
    "Airport\nTransfer",
  ];

  List<IconData> icons = [Icons.location_on, Icons.directions_car, Icons.airplanemode_active];
  int current = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.5,
      margin: const EdgeInsets.all(2),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 80,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          current = index;
                        });
                        pageController.animateToPage(
                          current,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.ease,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 70,
                        decoration: BoxDecoration(
                          color: current == index ? Colors.green : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                icons[index],
                                size: 24,
                                color: current == index ? Colors.white : Colors.black,
                              ),
                              Text(
                                items[index],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: current == index ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: PageView.builder(
                itemCount: items.length,
                controller: pageController,
                itemBuilder: (context, index) {
                  return _buildForm(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(int index) {
    switch (index) {
      case 0:
        return OutstationTripForm();
      case 1:
        return const localForm();
      case 2:
        return const aiportForm();
      default:
        return Container();
    }
  }
}
