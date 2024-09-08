// ignore_for_file: library_private_types_in_public_api, camel_case_types

import 'package:car_yatri1/Screen/finalOutputScreen.dart';
import 'package:car_yatri1/Screen/search/my_search.dart';
import 'package:car_yatri1/Theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:car_yatri1/repo/outStatRepo.dart';

class localForm extends ConsumerStatefulWidget {
  const localForm({super.key});

  @override
  _localFormState createState() => _localFormState();
}

class _localFormState extends ConsumerState<localForm> {
  late TextEditingController _pickPointController;

  @override
  void initState() {
    super.initState();
    _pickPointController = TextEditingController();
  }

  @override
  void dispose() {
    _pickPointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(outstationProvider);
    var theme = AppTheme.lightTheme;
    return Form(
      child: ListView(
        children: [
          _buildLocationField(
            icon: Icons.location_on,
            label: "Pick Location",
            value: formState['pickup'],
            defaultText: 'Select Pickup Point',
            onTap: () => _selectLocation(context, 'pickup', ''),
          ),
          const SizedBox(height: 16),
          _buildLocationField(
            icon: Icons.location_on,
            label: "Drop Location",
            value: formState['drop'],
            defaultText: 'Select Drop Point',
            onTap: () => _selectLocation(context, 'drop', formState['pickup']),
            trailing: IconButton(
              icon: const Icon(Icons.add_location_alt),
              onPressed: () => _selectLocation(context, 'stop', formState['pickup']),
            ),
          ),
          const SizedBox(height: 16),
          _buildDateTimePicker(
            icon: Icons.access_time,
            label: "Time",
            value: formState['time'],
            defaultText: 'Select Time',
            onTap: () => _selectTime(context),
          ),
          const SizedBox(height: 16),
          _buildDateTimePicker(
            icon: Icons.calendar_month,
            label: "Date",
            value: formState['date'],
            defaultText: 'Select Date',
            onTap: () => _selectDate(context),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _showTripPlan(context, formState);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OutputScreen()));
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField({
    required IconData icon,
    required String label,
    required String value,
    required String defaultText,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.green),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    value.isNotEmpty ? value : defaultText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: value.isNotEmpty ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimePicker({
    required IconData icon,
    required String label,
    required String value,
    required String defaultText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.green),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : defaultText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: value.isNotEmpty ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectLocation(BuildContext context, String type, String excludeLocation) async {
    final location = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen(excludeLocation: excludeLocation)),
    );
    if (location != null) {
      if (type == 'pickup') {
        ref.read(outstationProvider.notifier).updatePickup(location);
        if (ref.read(outstationProvider)['drop'] == location) {
          ref.read(outstationProvider.notifier).updateDrop('');
        }
      } else if (type == 'drop') {
        ref.read(outstationProvider.notifier).updateDrop(location);
      } else if (type == 'stop') {
        ref.read(outstationProvider.notifier).addStop(location);
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      ref.read(outstationProvider.notifier).updateTime(time.format(context));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      ref.read(outstationProvider.notifier).updateDate(date.toString().split(' ')[0]);
    }
  }

  void _showTripPlan(BuildContext context, Map<String, dynamic> formState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Trip Plan'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTripPlanItem('Pickup', formState['pickup']),
              _buildTripPlanItem('Drop', formState['drop']),
              if (formState['stops'].isNotEmpty) _buildTripPlanItem('Stops', formState['stops'].join(", ")),
              _buildTripPlanItem('Time', formState['time']),
              _buildTripPlanItem('Date', formState['date']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildTripPlanItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
