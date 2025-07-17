class PoolReservationModel {
  final int id;
  final int userId;
  final String priceForPerson;
  final String numberOfPeople;
  final int totalPrice;
  final String date;
  final String time;
  final String status;

  PoolReservationModel({
    required this.id,
    required this.userId,
    required this.priceForPerson,
    required this.numberOfPeople,
    required this.totalPrice,
    required this.date,
    required this.time,
    required this.status,
  });

  factory PoolReservationModel.fromJson(Map<String, dynamic> json) {
    return PoolReservationModel(
      id: json['id'],
      userId: json['user_id'],
      priceForPerson: json['price_for_person'],
      numberOfPeople: json['number_of_people'],
      totalPrice: json['total_price'],
      date: json['date'],
      time: json['time'],
      status: json['status'],
    );
  }
}
