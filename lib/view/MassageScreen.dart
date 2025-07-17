
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:proj001/coree/constant/routes.dart';
import '../controller/MassageRequestController.dart';
import '../coree/constant/AppColors.dart';

class MassageScreen extends StatelessWidget {
  final controller = Get.put(MassageRequestController(), permanent: true);
  final gender = 'female'.obs;
  final selectedDateTime = Rxn<DateTime>();

  // القوائم المطلوبة للاختيار
  final List<String> genders = ['male', 'female'];
  final Map<String, String> gendersAr = {
    'male': 'ذكر',
    'female': 'أنثى',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tablesBackground,
      appBar: AppBar(
        title: const Text("طلب مساج"),
        backgroundColor: AppColors.tablesBackground,
        foregroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: "عرض الطلبات السابقة",
            onPressed: () => Get.toNamed(AppRout.MassageOrdersScreen),
            color: AppColors.primary,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "اختر الجنس:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => Row(
                    children: genders.map((g) {
                      final selected = gender.value == g;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => gender.value = g,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: selected ? AppColors.primaryButton : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.primaryButton),
                            ),
                            child: Center(
                              child: Text(
                                gendersAr[g]!,
                                style: TextStyle(
                                  color: selected ? Colors.white : AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Card(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity, // عرض كامل الشاشة
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        "حدد الوقت المفضل:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 30)),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: AppColors.primary,
                                  onPrimary: Colors.white,
                                  onSurface: AppColors.secondary,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (date != null) {
                          TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: AppColors.primary,
                                    onPrimary: Colors.white,
                                    onSurface: AppColors.secondary,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (time != null) {
                            final combined = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                            selectedDateTime.value = combined;
                          }
                        }
                      },
                      icon: Icon(Icons.access_time, color: AppColors.primary),
                      label: Text("اختيار الوقت",
                          style: TextStyle(color: AppColors.primary)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryLight,
                        elevation: 0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (selectedDateTime.value != null)
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 20, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('yyyy-MM-dd HH:mm:ss')
                                .format(selectedDateTime.value!),
                            style:
                            TextStyle(fontSize: 16, color: AppColors.primary),
                          ),
                        ],
                      ),
                  ],
                )),
              ),
            ),

            const SizedBox(height: 230),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (selectedDateTime.value == null) {
                    Get.snackbar("تنبيه", "يرجى اختيار وقت المساج",
                        backgroundColor: Colors.orangeAccent,
                        snackPosition: SnackPosition.TOP);
                    return;
                  }
                  controller.requestMassage(
                    preferredTime:
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDateTime.value!),
                    gender: gender.value,
                  );
                  selectedDateTime.value = null;
                  gender.value = "female";
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                label: const Text(
                  'طلب المساج',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                  backgroundColor: AppColors.primaryButton,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }
}


