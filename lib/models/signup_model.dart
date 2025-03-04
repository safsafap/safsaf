class SignupModel {
  String name;
  int phoneNumber;
  String lat;
  String lng;
  final String? password;

  SignupModel(
      {required this.name,
      required this.phoneNumber,
      required this.lat,
      required this.lng,
      this.password});

  Map<String, dynamic> toJSon() {
    return {
      'lat':lat,
      'lng':lng,
      'password':password,
      'password_confirmation':password,
      'phone_number':phoneNumber,
      'name':name
    };
  }
}
