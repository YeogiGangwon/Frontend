import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/place_model.dart';

class PlaceService {
  static List<Place>? _cachedPlaces;

  static Future<List<Place>> loadPlaces() async {
    if (_cachedPlaces != null) {
      return _cachedPlaces!;
    }

    try {
      final String response = await rootBundle.loadString(
        'assets/data/places.json',
      );
      final List<dynamic> data = json.decode(response);
      _cachedPlaces = data.map((json) => Place.fromJson(json)).toList();
      return _cachedPlaces!;
    } catch (e) {
      print('Error loading places: $e');
      return [];
    }
  }

  static Place? getPlaceById(int id) {
    if (_cachedPlaces == null) return null;
    return _cachedPlaces!.firstWhere(
      (place) => place.id == id,
      orElse: () => _cachedPlaces!.first,
    );
  }
}
