
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/MassageOrdersController.dart';
import '../coree/constant/AppColors.dart';

class MassageOrdersScreen extends StatelessWidget {
  MassageOrdersScreen({super.key});

  final controller = Get.put(MassageOrdersController());

  final List<String> statuses = ['pending', 'confirmed', 'cancelled'];
  final List<String> statusTitles = ['المعلقة', 'المؤكدة', 'الملغاة'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: statuses.length,
      child: Scaffold(
        backgroundColor: AppColors.tablesBackground,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text("طلباتي للمساج"),
          bottom: TabBar(
            indicatorColor: AppColors.primaryLight,
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.primaryLight.withOpacity(0.7),
            tabs: statusTitles.map((title) => Tab(text: title)).toList(),
            onTap: (index) {
              controller.fetchMyMassageRequests(status: statuses[index]);
            },
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error.isNotEmpty) {
            return Center(
              child: Text(
                controller.error.value,
                style: TextStyle(
                  color: AppColors.danger,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          if (controller.massageRequests.isEmpty) {
            return Center(
              child: Text(
                "لا توجد طلبات في هذه الحالة.",
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            itemCount: controller.massageRequests.length,
            itemBuilder: (context, index) {
              final req = controller.massageRequests[index];
              final bool isPending = req.status == 'pending';
              final bool isCancelled = req.status == 'cancelled';

              Color statusColor = isPending
                  ? AppColors.warning
                  : (isCancelled ? AppColors.danger : AppColors.success);

              Color cardColor = AppColors.backgroundButtonApproved.withOpacity(0.3);
              if (isPending) {
                cardColor = AppColors.backgroundButtonRejected.withOpacity(0.2);
              } else if (isCancelled) {
                cardColor = AppColors.backgroundButtonRejected;
              }

              return Card(
                elevation: 3,
                shadowColor: AppColors.primary.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // التفاصيل اليسرى
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "الوقت المفضل: ${req.preferredTime}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "الجنس: ${req.gender}",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.secondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "الحالة: ${req.status}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${req.price} \$",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (isPending)
                            ElevatedButton.icon(
                              icon: const Icon(Icons.cancel, color: AppColors.buttonRejectedText),
                              label: const Text("إلغاء الطلب",style: TextStyle(color: AppColors.buttonRejectedText),),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.backgroundButtonRejected,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                              onPressed: () {
                                controller.cancelRequest(req.id);
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
