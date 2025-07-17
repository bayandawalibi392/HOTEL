
class ViewOrderModel {
  final int id;
  final String checkIn;
  final String checkOut;
  final String totalPrice;
  final String status;
  final int roomNumber;
  final String roomStatus;
  final String roomTypeAr;

  ViewOrderModel({
    required this.id,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.status,
    required this.roomNumber,
    required this.roomStatus,
    required this.roomTypeAr,
  });

  factory ViewOrderModel.fromJson(Map<String, dynamic> json) {
    return ViewOrderModel(
      id: json['id'],
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      totalPrice: json['total_price'],
      status: json['status'],
      roomNumber: json['room']['number'],
      roomStatus: json['room']['status'],
      roomTypeAr: json['room']['room_type']['type_name_ar'],
    );
  }
}
