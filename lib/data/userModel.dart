
class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? photo;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? 'Unknown',
      phone: json['phone'] ?? 'Unknown',
      role: json['role'] ?? 'User',
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "role": role,
      "photo": photo,
    };
  }
}
