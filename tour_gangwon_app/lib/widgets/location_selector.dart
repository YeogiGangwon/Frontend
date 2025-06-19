import 'package:flutter/material.dart';

class LocationSelector extends StatelessWidget {
  final String selectedLocation;
  final List<String> locations;
  final ValueChanged<String?> onChanged;

  const LocationSelector({super.key, required this.selectedLocation, required this.locations, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedLocation,
      icon: const Icon(Icons.arrow_drop_down),
      onChanged: onChanged,
      items: locations.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
} 