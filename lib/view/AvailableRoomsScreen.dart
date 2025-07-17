
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proj001/coree/constant/routes.dart';
import '../coree/constant/AppColors.dart';
import '../controller/AvailableRoomsController.dart';

class AvailableRoomsScreen extends StatelessWidget {
  final AvailableRoomsController controller = Get.put(AvailableRoomsController());
  final RxInt roomTypeId = 0.obs;
  final RxString checkIn = ''.obs;
  final RxString checkOut = ''.obs;

  Future<void> pickDate(BuildContext context, RxString dateVar) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary, // لون رئيسي من كلاس الألوان
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dateVar.value = picked.toIso8601String().split('T').first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = Get.arguments;
    if (roomTypeId.value == 0) {
      roomTypeId.value = args?['roomTypeId'] ?? 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Available Rooms', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Obx(() => TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Check In Date',
                labelStyle: TextStyle(color: AppColors.primaryLight),
                hintText: 'Select check-in date',
                suffixIcon: Icon(Icons.calendar_today, color: AppColors.primary),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondary),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              controller: TextEditingController(text: checkIn.value),
              onTap: () => pickDate(context, checkIn),
            )),
            const SizedBox(height: 16),
            Obx(() => TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Check Out Date',
                labelStyle: TextStyle(color: AppColors.primaryLight),
                hintText: 'Select check-out date',
                suffixIcon: Icon(Icons.calendar_today, color: AppColors.primary),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondary),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              controller: TextEditingController(text: checkOut.value),
              onTap: () => pickDate(context, checkOut),
            )),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (checkIn.value.isEmpty || checkOut.value.isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Get.snackbar(
                      'warning',
                      'Please select both check-in and check-out dates',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.orangeAccent,
                      colorText: Colors.white,
                    );
                  });
                  return;
                }

                controller.fetchAvailableRooms(
                  roomTypeId: roomTypeId.value.toString(),
                  checkIn: checkIn.value,
                  checkOut: checkOut.value,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: const Text(
                'Search Available Rooms',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator(color: AppColors.primary));
                } else if (controller.error.isNotEmpty) {
                  return Center(child: Text(controller.error.value));
                } else if (controller.availableRooms.isEmpty) {
                  return const Center(child: Text('No rooms available'));
                } else {
                  return ListView.builder(
                    itemCount: controller.availableRooms.length,
                    itemBuilder: (context, index) {
                      final room = controller.availableRooms[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: room.normalImage.isNotEmpty
                              ? Image.network(
                            room.normalImage,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                              : const SizedBox(width: 80, height: 80),
                          title: Text(
                            'Room #${room.number}',
                            style: const TextStyle(color: AppColors.primary),
                          ),
                          subtitle: Text(
                            'Status: ${room.status}',
                            style: TextStyle(color: AppColors.primaryLight),
                          ),
                          isThreeLine: true,
                          onTap: () {
                            // انتقل إلى شاشة تفاصيل الغرفة مع تمرير roomId
                            Get.toNamed(AppRout.RoomDetailsScreen, arguments: {'roomId': room.id});
                          },
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
