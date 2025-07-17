
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/MenuItemController.dart';
import '../coree/constant/AppColors.dart';

class CartScreen extends GetView<MenuItemController> {
  @override
  Widget build(BuildContext context) {
    // استخدم اللون الأساسي من AppColors
    const primaryColor = AppColors.primaryButton;

    return Scaffold(
      appBar: AppBar(
        title: const Text("سلة الطلبات"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.cart.isEmpty) {
          return Center(
            child: Text(
              "لا توجد عناصر في السلة",
              style: TextStyle(
                color: AppColors.primary, // لون النص
                fontSize: 16,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "الطلبات:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemCount: controller.cart.length,
                  separatorBuilder: (_, __) => Divider(color: AppColors.primaryLight),
                  itemBuilder: (context, index) {
                    final item = controller.cart[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        item["item"].Name,
                        style: TextStyle(fontSize: 16, color: AppColors.secondary),
                      ),
                      subtitle: Text(
                        "الكمية: ${item["quantity"]}",
                        style: TextStyle(color: AppColors.primaryLight),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        color: AppColors.buttonRejectedText,
                        onPressed: () => controller.removeFromCart(index),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "اختر نوع الحجز:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
              Obx(() => Row(
                children: [
                  Radio<String>(
                    value: "room",
                    groupValue: controller.orderType.value,
                    activeColor: primaryColor,
                    onChanged: (val) => controller.orderType.value = val!,
                  ),
                  Text(
                    "غرفة",
                    style: TextStyle(color: AppColors.secondary),
                  ),
                  const SizedBox(width: 16),
                  Radio<String>(
                    value: "table",
                    groupValue: controller.orderType.value,
                    activeColor: primaryColor,
                    onChanged: (val) => controller.orderType.value = val!,
                  ),
                  Text(
                    "طاولة",
                    style: TextStyle(color: AppColors.secondary),
                  ),
                ],
              )),
              const SizedBox(height: 10),
              Obx(() {
                if (controller.orderType.value == "room") {
                  return Column(
                    children: [
                      TextField(
                        controller: controller.numberController,
                        decoration: InputDecoration(
                          labelText: "رقم الغرفة",
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          labelStyle: TextStyle(color: AppColors.primary),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: controller.durationController,
                        decoration: InputDecoration(
                          labelText: "المدة بالساعة",
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          labelStyle: TextStyle(color: AppColors.primary),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      TextField(
                        controller: controller.numberController,
                        decoration: InputDecoration(
                          labelText: "رقم الطاولة",
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          labelStyle: TextStyle(color: AppColors.primary),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: controller.peopleController,
                        decoration: InputDecoration(
                          labelText: "عدد الأشخاص",
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          labelStyle: TextStyle(color: AppColors.primary),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: controller.durationController,
                        decoration: InputDecoration(
                          labelText: "المدة بالساعة",
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          labelStyle: TextStyle(color: AppColors.primary),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  );
                }
              }),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.submitOrder(
                      orderType: controller.orderType.value,
                      tableOrRoomNumber:
                      int.tryParse(controller.numberController.text) ?? 0,
                      bookedDuration:
                      int.tryParse(controller.durationController.text) ?? 1,
                      numberOfPeople: controller.orderType.value == "table"
                          ? int.tryParse(controller.peopleController.text) ?? 1
                          : null,
                    );
                  },
                  icon: const Icon(Icons.send,color:Colors.white ),
                  label: const Text("إرسال الطلب",style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
