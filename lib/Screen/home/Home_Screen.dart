import 'package:car_yatri1/Screen/home/booking.dart';
import 'package:car_yatri1/Screen/home/widget/slider_screen.dart';
import 'package:car_yatri1/Theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = AppTheme.lightTheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("assets/logo.png", height: 50),
                    const Icon(
                      Icons.notifications_active,
                      color: Colors.white, // Changed from white to black for visibility
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: "India's Leading",
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Ensure text is visible
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' Inter-City\nOne Way',
                        style: theme.textTheme.titleLarge!.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      TextSpan(
                        text: ' Cab Service Provider',
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Ensure text is visible
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const SliderScreen(),
                const SizedBox(height: 20),
                const BookingTab(),
                const SizedBox(height: 20),
                Container(
                  child: Image.asset('assets/image.png'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
