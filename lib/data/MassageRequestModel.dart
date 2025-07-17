class MassageRequestModel {
  final int id;
  final int userId;
  final String preferredTime;
  final String gender;
  final String status;
  final int price;

  MassageRequestModel({
    required this.id,
    required this.userId,
    required this.preferredTime,
    required this.gender,
    required this.status,
    required this.price,
  });

  factory MassageRequestModel.fromJson(Map<String, dynamic> json) {
    return MassageRequestModel(
      id: json['id'],
      userId: json['user_id'],
      preferredTime: json['preferred_time'],
      gender: json['gender'],
      status: json['status'],
      price: json['price'],
    );
  }
}
