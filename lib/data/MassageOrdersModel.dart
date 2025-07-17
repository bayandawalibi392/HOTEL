
class MassageOrdersModel {
  final int id;
  final String preferredTime;
  final String price;
  final String gender;
  final String status;
  final int userId;
  final int? approvedBy;
  final int? employeeId;

  MassageOrdersModel({
    required this.id,
    required this.preferredTime,
    required this.price,
    required this.gender,
    required this.status,
    required this.userId,
    this.approvedBy,
    this.employeeId,
  });

  factory MassageOrdersModel.fromJson(Map<String, dynamic> json) {
    return MassageOrdersModel(
      id: json['id'],
      preferredTime: json['preferred_time'],
      price: json['price'],
      gender: json['gender'],
      status: json['status'],
      userId: json['user_id'],
      approvedBy: json['approved_by'],
      employeeId: json['employee_id'],
    );
  }
}
