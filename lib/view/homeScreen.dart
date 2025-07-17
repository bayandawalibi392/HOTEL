
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:proj001/controller/homeController/RoomTypeController.dart';
import '../controller/homeController/RandomRoomController.dart';
import '../coree/constant/AppColors.dart';
import '../coree/constant/routes.dart';
import '../coree/localaization/changeLocal.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RandomRoomController controller = Get.put(RandomRoomController());
    final RoomTypeController controller1 = Get.put(RoomTypeController());

    final List<String> sliderImages = [
      'assets/images/hotel.jpg',
      'assets/images/restaurant.jpg',
      'assets/images/pool.jpg',
      'assets/images/hall.jpg',
    ];

    final List<List<IconData>> roomTypeIcons = [
      [Icons.bed_outlined],
      [Icons.bed, Icons.bed],
      [Icons.bed, Icons.bed, Icons.bed],
      [Icons.workspace_premium_outlined],
      [Icons.accessible_forward],
      [Icons.smoking_rooms],
    ];

    return Scaffold(
      backgroundColor: AppColors.tablesBackground,
      appBar: AppBar(
        backgroundColor: AppColors.tablesBackground,
        title: Text(
          "Al_Yarmok Hotel",
          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.translate, color: AppColors.primary),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text('Choose Languages'.tr, style: TextStyle(color: AppColors.primary)),
                    children: <Widget>[
                      SimpleDialogOption(
                        onPressed: () {
                          Get.find<LocaleController>().changeLang("ar");
                          Get.back();
                        },
                        child: Text('2'.tr, style: TextStyle(color: AppColors.secondary)),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          Get.find<LocaleController>().changeLang("en");
                          Get.back();
                        },
                        child: Text('3'.tr, style: TextStyle(color: AppColors.secondary)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.dark_mode, color: AppColors.primary),
            onPressed: () {

            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value || controller1.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final randomRooms = controller.randomRoom;
        final roomTypes = controller1.roomTypes;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 180,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                aspectRatio: 16 / 9,
                autoPlayInterval: const Duration(seconds: 3),
              ),
              items: sliderImages.map((path) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(path, fit: BoxFit.cover, width: double.infinity),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Text(
              "أنواع الغرف",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: roomTypes.asMap().entries.map((entry) {
                  int index = entry.key;
                  final roomType = entry.value;
                  final icons = roomTypeIcons.length > index
                      ? roomTypeIcons[index]
                      : [Icons.bed]; // fallback

                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        AppRout.RoomTypeScreen,
                        arguments: {
                          'initialIndex': index,
                          'roomTypes': roomTypes,
                          'roomTypeId': roomType.id,
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: icons.map((icon) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: Icon(icon, size: 26, color: AppColors.secondary),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            roomType.typeName,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "الغرف المقترحة",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: randomRooms.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3 / 2,
              ),
              itemBuilder: (context, index) {
                final room = randomRooms[index];
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(room.image),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Text(
                      room.number.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black45,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}


