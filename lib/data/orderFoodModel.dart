import 'package:get/get.dart';
import 'MenuItemModel.dart';


class OrderListResponse {
  final List<Order> orders;

  OrderListResponse({required this.orders});

  factory OrderListResponse.fromJson(Map<String, dynamic> json) {
    var ordersList = json['orders'] as List;
    List<Order> orders = ordersList.map((i) => Order.fromJson(i)).toList();
    return OrderListResponse(orders: orders);
  }
}

class Order {
  final int id;
  final int? tableNumber;
  final int? roomNumber;
  final int? numberOfPeople;
  final String preferredTime;
  final String tablePrice;
  final String orderType;
  final String status;
  final String? reservationEndTime;
  final int bookedDuration;
  final String totalPrice;
  final int userId;
  final int? approvedOrRejectedBy;
  final List<OrderItem> items;

  Order({
    required this.id,
    this.tableNumber,
    this.roomNumber,
    this.numberOfPeople,
    required this.preferredTime,
    required this.tablePrice,
    required this.orderType,
    required this.status,
    this.reservationEndTime,
    required this.bookedDuration,
    required this.totalPrice,
    required this.userId,
    this.approvedOrRejectedBy,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<OrderItem> items = itemsList.map((i) => OrderItem.fromJson(i)).toList();

    return Order(
      id: json['id'],
      tableNumber: json['table_number'],
      roomNumber: json['room_number'],
      numberOfPeople: json['number_of_people'],
      preferredTime: json['preferred_time'],
      tablePrice: json['table_price'].toString(),
      orderType: json['order_type'],
      status: json['status'],
      reservationEndTime: json['reservation_end_time'],
      bookedDuration: json['booked_duration'],
      totalPrice: json['total_price'].toString(),
      userId: json['user_id'],
      approvedOrRejectedBy: json['approved_or_rejected_by'],
      items: items,
    );
  }

  String get locationNumber {
    return orderType == 'table'
        ? '${'Table'.tr} ${tableNumber ?? ''}'
        : '${'Room'.tr} ${roomNumber ?? ''}';
  }

  String get peopleOrDuration {
    return orderType == 'table'
        ? '${'People'.tr}: ${numberOfPeople ?? ''} | ${'Duration'.tr}: ${bookedDuration}h'
        : '${'Duration'.tr}: ${bookedDuration}h';
  }

  String get formattedStatus {
    return status.tr;
  }

  String get formattedOrderType {
    return orderType.tr;
  }
}

class OrderItem {
  final int id;
  final int quantity;
  final String totalPrice;
  final int restaurantOrderId;
  final int menuItemId;
  final MenuItemModel menuItem;

  OrderItem({
    required this.id,
    required this.quantity,
    required this.totalPrice,
    required this.restaurantOrderId,
    required this.menuItemId,
    required this.menuItem,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      quantity: json['quantity'],
      totalPrice: json['total_price'].toString(),
      restaurantOrderId: json['restaurant_order_id'],
      menuItemId: json['menu_item_id'],
      menuItem: MenuItemModel.fromJson(json['menu_item']),
    );
  }
}