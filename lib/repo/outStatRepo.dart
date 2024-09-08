import 'package:flutter_riverpod/flutter_riverpod.dart';

class OutstationNotifier extends StateNotifier<Map<String, dynamic>> {
  OutstationNotifier() : super({'tripType': 'one-way', 'pickup': '', 'drop': '', 'time': '', 'date': '', 'stops': []});

  void toggleTripType(String type) {
    state = {...state, 'tripType': type};
  }

  void updatePickup(String value) {
    state = {...state, 'pickup': value};
  }

  void updateDrop(String value) {
    if (value != state['pickup']) {
      state = {...state, 'drop': value};
    }
  }

  void updateTime(String value) {
    state = {...state, 'time': value};
  }

  void updateDate(String value) {
    state = {...state, 'date': value};
  }

  void addStop(String stop) {
    final stops = List<String>.from(state['stops']);
    stops.add(stop);
    state = {...state, 'stops': stops};
  }

  void removeStop(String stop) {
    final stops = List<String>.from(state['stops']);
    stops.remove(stop);
    state = {...state, 'stops': stops};
  }

  void clearStops() {
    state = {...state, 'stops': []};
  }
}

final outstationProvider = StateNotifierProvider<OutstationNotifier, Map<String, dynamic>>((ref) {
  return OutstationNotifier();
});
