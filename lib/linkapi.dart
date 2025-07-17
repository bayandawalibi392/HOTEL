// class AppLink {
//   static const String server = "http://localhost:8000/api";
//   ////////////////////////User////////////////////////////
//   static const String signUp = "$server/register";
//   static const String login = "$server/login";
//   static const String getRoom = "$server/getRandomRooms";
//   static const String roomTypes = "$server/GetRoomTypes";
//   static const String getAvailableRoomByDate = "$server/getAvailableRoomsByDate";
//   static const String massageRequest = "$server/RequestMassage";
//   static const String getMenuItem = "$server/getListMenuItemsByUser";
//   static const String requestOrder = "$server/RequestOrderByUser";
//   static const String getOrderFood = "$server/getUserOrdersByUser";
//   static const String bookRoom = "$server/BookRoom";
//   // static const String login = "$server/login";
//   // static const String login = "$server/login";
// }
class AppLink {
  static const String server = "http://localhost:8000/api";

  //////////////////////// Auth ////////////////////////////
  static const String signUp = "$server/register";
  static const String login = "$server/login";

  //////////////////////// Rooms ////////////////////////////
  static const String getRoom = "$server/getRandomRooms";
  static const String roomTypes = "$server/GetRoomTypes";
  static const String getAvailableRoomByDate = "$server/getAvailableRoomsByDate";
  static const String bookRoom = "$server/BookRoom";
  static String getRoomDetails(int roomId) => "$server/getRoomDetails/$roomId";
  static String getRoomsByType(int roomTypeId) => "$server/GetRoomsByType/$roomTypeId";

  //////////////////////// Massage ////////////////////////////
  static const String massageRequest = "$server/RequestMassage";
  static String cancelMassageRequest(int requestId) => "$server/cancelMassReqByUser/$requestId";
  static String getMassageRequestsByStatus(String status) => "$server/getMyMassReqByStatus?status=$status";

  //////////////////////// Food ////////////////////////////
  static const String getMenuItem = "$server/getListMenuItemsByUser";
  static String getMenuItemByType(String type) => "$server/getMenuItemByType/$type";
  static const String requestOrder = "$server/RequestOrderByUser";
  static const String getOrderFood = "$server/getUserOrdersByUser";
  static String cancelOrder(int orderId) => "$server/cancelOrdersByUser/$orderId";

  //////////////////////// Booking ////////////////////////////
  static String getMyBookingsByStatus(String status) => "$server/getMyBookingsByStatus/$status";
  static String cancelBooking(int bookingId) => "$server/CancelBookingByGuest/$bookingId";

  /////////////////////// pool ////////////////////////////////
  static const String poolReversation = "$server/RequestPoolReservation";
}
