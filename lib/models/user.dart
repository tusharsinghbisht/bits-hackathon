class User {
  final String id;
  final String name;
  final String mobile;
  final DateTime dob;
  final String gender;
  final String aadhaar;
  final double? height;
  final double? weight;
  final String? bloodGroup;
  final List<String> surgeries;
  final List<String> acuteConditions;
  final List<String> chronicConditions;
  final List<String> allergies;
  final List<String> family;

  User({
    required this.id,
    required this.name,
    required this.mobile,
    required this.dob,
    required this.gender,
    required this.aadhaar,
    this.height,
    this.weight,
    this.bloodGroup,
    this.surgeries = const [],
    this.acuteConditions = const [],
    this.chronicConditions = const [],
    this.allergies = const [],
    this.family = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      mobile: json['mobile'],
      dob: DateTime.parse(json['dob']),
      gender: json['gender'],
      aadhaar: json['aadhaar'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      bloodGroup: json['bloodGroup'],
      surgeries: List<String>.from(json['surgeries'] ?? []),
      acuteConditions: List<String>.from(json['acuteConditions'] ?? []),
      chronicConditions: List<String>.from(json['chronicConditions'] ?? []),
      allergies: List<String>.from(json['allergies'] ?? []),
      family: List<String>.from(json['family'] ?? []),
    );
  }
}