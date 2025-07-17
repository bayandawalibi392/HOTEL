
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import '../controller/RoomDetailsController.dart';
import '../coree/constant/AppColors.dart';

class RoomDetailsScreen extends StatelessWidget {
  const RoomDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RoomDetailsController controller = Get.put(RoomDetailsController());

    final int roomId = Get.arguments['roomId'];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchRoomDetails(roomId);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('تفاصيل الغرفة', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final room = controller.room.value;
        if (room == null) {
          return const Center(child: Text('فشل في تحميل بيانات الغرفة'));
        }

        final bool isAvailable = room.status.toLowerCase() == "available";
        final panoramaImages = room.images.where((img) => img.imageType == 'panorama').toList();
        final normalImage = room.images.firstWhere(
              (img) => img.imageType == 'normal',
          orElse: () => room.images.first,
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (panoramaImages.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        insetPadding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            width: double.infinity,
                            height: 400,
                            child: PanoramaViewer(
                              child: Image.network(
                                panoramaImages[0].imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    Get.snackbar('تنبيه', 'لا توجد صورة بانورامية للعرض');
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 250,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(normalImage.imagePath, fit: BoxFit.cover),
                  ),
                ),
              ),

              if (panoramaImages.length > 1) ...[
                const Text(
                  'صور بانورامية إضافية',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 10),
                ...panoramaImages.skip(1).map(
                      (img) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: PanoramaViewer(
                        child: Image.network(img.imagePath, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              Row(
                children: [
                  const Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? AppColors.backgroundButtonApproved
                          : AppColors.backgroundButtonRejected,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isAvailable ? room.status : 'محجوزة',
                      style: TextStyle(
                        color: isAvailable
                            ? AppColors.buttonApprovedText
                            : AppColors.buttonRejectedText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (room.description != null && room.description!.isNotEmpty)
                Text(room.description!, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),

              const Text(
                'الخدمات الإضافية',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  ServiceItem(icon: Icons.wifi, label: 'Wi-Fi'),
                  ServiceItem(icon: Icons.tv, label: 'TV'),
                  ServiceItem(icon: Icons.ac_unit, label: 'مكيف'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  ServiceItem(icon: Icons.bathtub, label: 'حمام'),
                  ServiceItem(icon: Icons.lock, label: 'خزنة'),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'حدد تاريخ الإقامة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Obx(() => ElevatedButton(
                      onPressed: () => controller.pickDate(isStart: true, context: context),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryLight),
                      child: Text(
                        controller.startDate.value != null
                            ? 'من: ${controller.startDate.value!.toLocal().toString().split(' ')[0]}'
                            : 'اختر تاريخ البداية',
                        style: const TextStyle(color: AppColors.secondary),
                      ),
                    )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Obx(() => ElevatedButton(
                      onPressed: () => controller.pickDate(isStart: false, context: context),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryLight),
                      child: Text(
                        controller.endDate.value != null
                            ? 'إلى: ${controller.endDate.value!.toLocal().toString().split(' ')[0]}'
                            : 'اختر تاريخ النهاية',
                        style: const TextStyle(color: AppColors.secondary),
                      ),
                    )),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        final room = controller.room.value;
        if (room == null) return const SizedBox();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'السعر: \$${room.price} / الليلة',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () => controller.bookRoom(roomId: room.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryButton,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : const Text('حجز الغرفة', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ServiceItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const ServiceItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: AppColors.secondary),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14, color: AppColors.secondary)),
        ],
      ),
    );
  }
}
