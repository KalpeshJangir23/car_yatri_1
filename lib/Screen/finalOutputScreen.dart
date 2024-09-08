import 'package:car_yatri1/repo/outStatRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OutputScreen extends ConsumerStatefulWidget {
  const OutputScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OutputScreenState();
}

class _OutputScreenState extends ConsumerState<OutputScreen> {
  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(outstationProvider);
    final isRoundTrip = formState['tripType'] == 'round-way';

    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Ride')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display trip plan details
            _buildTripPlanItem('Pickup', formState['pickup']),
            _buildTripPlanItem('Drop', formState['drop']),
            if (formState['stops'].isNotEmpty)
              _buildTripPlanItem('Stops', formState['pickup'] + ' -> ' + formState['stops'].join(' -> ') + ' -> ' + formState['drop']),
            _buildTripPlanItem('Time', formState['time']),
            _buildTripPlanItem('Date', formState['date']),
            const SizedBox(height: 20),

            // Display available car options
            const Text('Available Rides:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),

            // Car Option 1
            _buildCarOption(
              carImage: 'assets/sedan.jpg',
              carType: 'Sedan',
              seats: 4,
              kms: 150,
              luggage: 2,
              price: 1200,
            ),
            const SizedBox(height: 10),

            // Car Option 2
            _buildCarOption(
              carImage: 'assets/suv.png',
              carType: 'SUV',
              seats: 6,
              kms: 150,
              luggage: 3,
              price: 1800,
            ),
            const SizedBox(height: 10),

            // Car Option 3
            _buildCarOption(
              carImage: 'assets/minivan.png',
              carType: 'Minivan',
              seats: 8,
              kms: 150,
              luggage: 4,
              price: 2400,
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display each trip plan item
  Widget _buildTripPlanItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Widget _buildCarOption({
    required String carImage,
    required String carType,
    required int seats,
    required int kms,
    required int luggage,
    required int price,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            spreadRadius: 2,
          )
        ],
      ),
      child: Row(
        children: [
          // Car image
          Image.asset(carImage, width: 80, height: 80),
          const SizedBox(width: 16),

          // Car details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(carType, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('$seats seats | $kms km | $luggage luggage'),
              ],
            ),
          ),

          // Price
          Text('₹$price', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
