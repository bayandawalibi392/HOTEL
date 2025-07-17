import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/PoolReservationController.dart';
import '../coree/constant/AppColors.dart';

class PoolScreen extends StatelessWidget {
  PoolScreen({super.key});

  final PoolReservationController controller = Get.put(PoolReservationController());

  final List<String> times = ['morning', 'evening'];
  final Map<String, String> timesAr = {
    'morning': 'صباحًا',
    'evening': 'مساءً',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tablesBackground,
      appBar: AppBar(
        backgroundColor: AppColors.tablesBackground,
        elevation: 0,
        title: Text("حجز المسبح", style: TextStyle(color: AppColors.primary)),
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Text("عدد الأشخاص", style: TextStyle(color: AppColors.secondary)),
              const SizedBox(height: 6),
              TextField(
                keyboardType: TextInputType.number,
                controller: controller.peopleCountController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "أدخل عدد الأشخاص",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text("تاريخ الحجز", style: TextStyle(color: AppColors.secondary)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => controller.showCalendarPicker(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Text(
                        controller.selectedDate.value.isEmpty
                            ? "اختر التاريخ"
                            : controller.selectedDate.value,
                        style: TextStyle(
                          color: controller.selectedDate.value.isEmpty
                              ? Colors.grey
                              : AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Text("الفترة", style: TextStyle(color: AppColors.secondary)),
              const SizedBox(height: 6),
              Row(
                children: times.map((t) {
                  return Obx(() {
                    final selected = controller.selectedTime.value == t;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => controller.selectedTime.value = t,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.primaryButton : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.primary),
                          ),
                          child: Center(
                            child: Text(
                              timesAr[t]!,
                              style: TextStyle(
                                color: selected ? Colors.white : AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                }).toList(),
              ),

              const Spacer(),
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  child: controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: () async {
                      final number = controller.peopleCountController.text.trim();
                      final date = controller.selectedDate.value;
                      final time = controller.selectedTime.value;

                      if (number.isEmpty || date.isEmpty) {
                        Get.snackbar(
                          "تنبيه",
                          "يرجى تعبئة جميع الحقول",
                          backgroundColor: Colors.orangeAccent,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      await controller.requestPoolReservation(
                        numberOfPeople: number,
                        date: date,
                        time: time,
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryButton,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("تأكيد الحجز", style: TextStyle(color: Colors.white)),
                  ),
                );
              }),
            ],
          );
        }),
      ),
    );
  }
}
