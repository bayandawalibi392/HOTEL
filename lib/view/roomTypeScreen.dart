
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proj001/coree/constant/routes.dart';
import 'package:proj001/data/roomTypeModel.dart';
import 'package:proj001/view/roomDetailsScreen.dart';
import '../controller/homeController/RoomTypeController.dart';
import '../controller/roomByTypeController.dart';
import '../coree/constant/AppColors.dart';
import '../view/availableRoomsScreen.dart';
import '../data/roomModel.dart';

class RoomTypeScreen extends StatelessWidget {
  const RoomTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RoomTypeController typeController = Get.put(RoomTypeController());
    final RoomByTypeController roomController = Get.put(RoomByTypeController());

    final Map<String, dynamic>? args = Get.arguments;
    final int? initialIndex = args?['initialIndex'];
    final int? roomTypeId = args?['roomTypeId'];

    return Obx(() {
      if (typeController.isLoading.value) {
        return const Scaffold(
          backgroundColor: AppColors.tablesBackground,
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final types = typeController.roomTypes;

      if (roomController.roomTypes.isEmpty && roomTypeId != null) {
        roomController.fetchRoomsByType(roomTypeId);
      }

      return DefaultTabController(
        initialIndex: initialIndex ?? 0,
        length: types.length,
        child: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: AppColors.tablesBackground,
              appBar: AppBar(
                backgroundColor: AppColors.primary,
                title: const Text('أنواع الغرف', style: TextStyle(color: Colors.white)),
                centerTitle: true,
                bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.primaryLight,
                  onTap: (index) {
                    roomController.fetchRoomsByType(types[index].id);
                  },
                  tabs: types.map((room) => Tab(text: room.typeName)).toList(),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Get.toNamed(AppRout.ViewOrderScreen);
                    },
                    color: Colors.white,
                  ),
                ],
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          final tabController = DefaultTabController.of(context);
                          if (tabController == null) return;

                          final selectedIndex = tabController.index;
                          final selectedRoomTypeId = types[selectedIndex].id;

                          Get.toNamed(
                            AppRout.AvailableRoomsScreen,
                            arguments: {'roomTypeId': selectedRoomTypeId},
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryButton,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          minimumSize: const Size(double.infinity, 0),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              "بحث عن غرف متاحة حسب التاريخ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (roomController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (roomController.roomTypes.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.hotel, size: 60, color: AppColors.primaryLight),
                              const SizedBox(height: 16),
                              Text(
                                "لا توجد غرف متاحة لهذا النوع",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: roomController.roomTypes.length,
                          itemBuilder: (context, index) {
                            final room = roomController.roomTypes[index];
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRout.RoomDetailsScreen,
                                    arguments: {'roomId': room.id});
                              },
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                        child: Image.network(
                                          room.image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'الغرفة ${room.number}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: AppColors.secondary,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.attach_money,
                                                  size: 16,
                                                  color: Colors.green),
                                              const SizedBox(width: 4),
                                              Text(
                                                room.price.toString(),
                                                style: const TextStyle(color: Colors.green),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                size: 12,
                                                color: room.status == 'available'
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                room.status,
                                                style: TextStyle(
                                                  color: room.status == 'available'
                                                      ? AppColors.buttonApprovedText
                                                      : AppColors.buttonRejectedText,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
