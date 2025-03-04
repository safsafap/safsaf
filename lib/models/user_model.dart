import 'package:multi_vendor/models/signup_model.dart';

class User extends SignupModel {
  final int id;
  final String token;

  User({
    required this.id,
    required int phoneNumber,
    required String lat,
    required String name,
    required String lng,
    required this.token,
  }) : super(
            name: name,
            phoneNumber: phoneNumber,
            lat: lat,
            lng: lng,);

  // Factory constructor to parse JSON into a User object
  factory User.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] ?? {}; // Ensure 'user' is not null.
    return User(
      id: userData['id'] is int ? userData['id'] : int.tryParse(userData['id'].toString()) ?? 0,
      name: userData['name'] as String,
      phoneNumber: userData['phone_number'] as int,
      lat: userData['lat'] as String,
      lng: userData['lng'] as String,
      token: json['token'] as String,
    );
  }

  // Method to convert a User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'lat': lat,
      'lng': lng,
      'token': token,
    };
  }

    // Method to convert a User object to JSON
  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'phone_number': phoneNumber,
      'lat': lat,
      'lng': lng,
    };
  }
}
