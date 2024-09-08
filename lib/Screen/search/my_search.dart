import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final String excludeLocation;

  SearchScreen({super.key, required this.excludeLocation});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // List of all locations
  final List<String> locations = [
    'Mumbai',
    'Pune',
    'Nashik',
    'Aurangabad',
    'Nagpur',
    'Kolhapur',
    'Lonavala',
    'Mahabaleshwar',
    'Shirdi',
    'Ratnagiri',
    'Alibaug',
    'Sindhudurg',
    'Satara',
    'Solapur',
    'Amravati'
  ];

  // Variable to store filtered locations
  List<String> filteredLocations = [];

  // Controller for the search bar
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the filtered list by excluding the pickup location
    filteredLocations = locations.where((location) => location != widget.excludeLocation).toList();

    // Listen for changes in the search bar
    searchController.addListener(() {
      filterLocations();
    });
  }

  // Function to filter the list of locations based on search input
  void filterLocations() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredLocations = locations.where((location) => location != widget.excludeLocation && location.toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location')),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            // List of filtered locations
            child: ListView.builder(
              itemCount: filteredLocations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    filteredLocations[index],
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    // Return the selected location to the previous screen
                    Navigator.pop(context, filteredLocations[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the controller when no longer needed
    searchController.dispose();
    super.dispose();
  }
}
