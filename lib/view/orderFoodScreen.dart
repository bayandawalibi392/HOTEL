
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/orderFoodController.dart';
import '../coree/constant/AppColors.dart';

class orderFoodScreen extends StatelessWidget {
  final orderFoodController controller = Get.put(orderFoodController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tablesBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('My Orders', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.refreshOrders,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value, style: TextStyle(color: AppColors.primary)),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryButton,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: controller.refreshOrders,
                  child: const Text('Retry', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }

        if (controller.orders.isEmpty) {
          return Center(
              child: Text(
                'No orders found',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ));
        }

        return ListView.builder(
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            final bool isPending = order.status == 'pending';
            return Card(
              margin: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: ExpansionTile(
                title: Text('Order #${order.id}'),
                subtitle: Text(
                  '${order.orderType.toUpperCase()} | ${order.status.toUpperCase()}',
                  style: TextStyle(
                    color: isPending ? AppColors.warning : AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location: ${order.locationNumber}'),
                        const SizedBox(height: 4),
                        Text(order.peopleOrDuration),
                        const SizedBox(height: 4),
                        Text('Preferred Time: ${order.preferredTime}'),
                        const SizedBox(height: 4),
                        Text('Total Price: \$${order.totalPrice}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Divider(),
                        const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ...order.items.map(
                              (item) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'http://localhost:8000/${item.menuItem.photo}'),
                            ),
                            title: Text(item.menuItem.enName),
                            subtitle:
                            Text('Qty: ${item.quantity} | \$${item.totalPrice}'),
                          ),
                        ),
                        if (isPending) ...[
                          const Divider(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(

                              icon: const Icon(Icons.cancel, color: AppColors.buttonRejectedText),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.backgroundButtonRejected,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                              ),
                              label: const Text(
                                "إلغاء الطلب",
                                style: TextStyle(color: AppColors.buttonRejectedText),
                              ),
                              onPressed: () {
                                controller.cancelOrder(order.id);
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
