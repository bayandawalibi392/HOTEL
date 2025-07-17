
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/MenuItemController.dart';
import '../coree/constant/AppColors.dart';
import '../coree/constant/routes.dart';
import 'cartScreen.dart';

class RestaurantScreen extends StatelessWidget {
  final Map<String, IconData> typeIcons = {
    "All": Icons.list,
    "Appetizers": Icons.fastfood,
    "Main_Course": Icons.restaurant,
    "Desserts": Icons.cake,
    "Drinks": Icons.local_drink,
  };

  RestaurantScreen({super.key});
  final controller = Get.put(MenuItemController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tablesBackground,
      appBar: AppBar(
        backgroundColor: AppColors.tablesBackground,
        title: const Text("Menu", style: TextStyle(color: AppColors.primary)),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: AppColors.primary),
            onSelected: (value) {
              if (value == 'cart') {
                Get.toNamed(AppRout.cartScreen);
              } else if (value == 'orders') {
                Get.toNamed(AppRout.orderFoodScreen);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'cart',
                child: Text('السلة'),
              ),
              const PopupMenuItem<String>(
                value: 'orders',
                child: Text('الطلبات'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(() => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: controller.types.map((type) {
                final isSelected = controller.selectedType.value == type;
                return GestureDetector(
                  onTap: () => controller.fetchItemsByType(type),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryButton
                          : Colors.black12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          typeIcons[type],
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          type.replaceAll("_", " "),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          )),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.menuItems.isEmpty) {
                return const Center(child: Text("No items found"));
              }

              return ListView.builder(
                itemCount: controller.menuItems.length,
                itemBuilder: (context, index) {
                  final item = controller.menuItems[index];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(item.photo, width: 60, height: 60, fit: BoxFit.cover),
                      ),
                      title: Text(item.Name),
                      subtitle: Text(item.description),
                      trailing: Text("${item.price} \$", style: TextStyle(color: AppColors.secondary)),
                      onTap: () {
                        controller.setSelectedItem(item);
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (_) {
                            return Obx(() {
                              final selected = controller.selectedItem.value;
                              if (selected == null) return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                        child: Container(
                                          width: 50,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        )),
                                    const SizedBox(height: 16),
                                    Text(
                                      selected.Name,
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(selected.description),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Quantity", style: TextStyle(fontSize: 16)),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove_circle),
                                              onPressed: controller.decreaseQuantity,
                                            ),
                                            Obx(() => Text(
                                              "${controller.quantity.value}",
                                              style: const TextStyle(fontSize: 18),
                                            )),
                                            IconButton(
                                              icon: const Icon(Icons.add_circle),
                                              onPressed: controller.increaseQuantity,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        controller.addToCart(
                                            controller.selectedItem.value!,
                                            controller.quantity.value);
                                        controller.selectedItem.value = null;
                                        controller.quantity.value = 1;
                                        Navigator.pop(context);
                                        Get.to(() => CartScreen());
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryButton,
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12)),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Add to cart",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                          },
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
