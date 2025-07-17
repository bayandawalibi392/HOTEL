
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/viewOrderController.dart';
import '../coree/constant/AppColors.dart';


class ViewOrderScreen extends StatelessWidget {
  ViewOrderScreen({Key? key}) : super(key: key);

  final ViewOrderController controller = Get.put(ViewOrderController());

  final List<String> bookingStatuses = ['pending', 'confirmed', 'cancelled'];
  final List<String> bookingStatusTitles = ['المعلقة', 'المؤكدة', 'الملغاة'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: bookingStatuses.length,
      child: Scaffold(
        backgroundColor: AppColors.tablesBackground,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text("الحجوزات", style: TextStyle(color: Colors.white)),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.primaryLight,
            tabs: bookingStatusTitles.map((title) => Tab(text: title)).toList(),
            onTap: (index) {
              controller.fetchBookingsByStatus(bookingStatuses[index]);
            },
          ),
        ),
        body: TabBarView(
          children: bookingStatuses.map((status) {
            return Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.error.isNotEmpty) {
                return Center(child: Text(controller.error.value));
              }
              if (controller.bookings.isEmpty) {
                return Center(child: Text("لا توجد حجوزات $status"));
              }

              return ListView.builder(
                itemCount: controller.bookings.length,
                itemBuilder: (context, index) {
                  final booking = controller.bookings[index];

                  return Card(
                    margin: const EdgeInsets.all(8),
                    color: Colors.white,
                    shadowColor: AppColors.primaryLight,
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        "الغرفة: ${booking.roomNumber} - ${booking.roomTypeAr}",
                        style: const TextStyle(color: AppColors.secondary),
                      ),
                      subtitle: Text(
                        "من ${booking.checkIn} إلى ${booking.checkOut}\nالحالة: ${booking.status}",
                        style: const TextStyle(color: AppColors.primary),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "السعر: \$${booking.totalPrice}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),

                            if (status == 'pending')
                              ElevatedButton(
                                onPressed: () => controller.cancelBooking(booking.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.backgroundButtonRejected,
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  minimumSize: Size.zero,
                                ),
                                child: const Text(
                                  "إلغاء",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.buttonRejectedText,
                                  ),
                                ),
                              ),
                            if (status == 'confirmed')
                              ElevatedButton(
                                onPressed: () => controller.cancelBooking(booking.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.backgroundButtonApproved,
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  minimumSize: Size.zero,
                                ),
                                child: const Text(
                                  "إلغاء",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.buttonApprovedText,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            });
          }).toList(),
        ),
      ),
    );
  }
}
