import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


class splashScreen extends StatelessWidget {
  const splashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // يبدأ العداد عند بناء الواجهة
    Timer(const Duration(seconds: 10), () {
      Get.offNamed('/login');
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEAF4FF), // خلفية فاتحة
              Color(0xFFD0E5FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Positioned(
            //   bottom: 0,
            //   child: Image.asset(
            //     'assets/waves.png',
            //     width: MediaQuery.of(context).size.width,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.home_work_outlined, size: 100, color: Color(0xFFFF9900)), // لون برتقالي فاتح
                SizedBox(height: 20),
                Text(
                  "AL-YARMOK",
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xFF007AFF), // أزرق أساسي
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "HOTEL",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF007AFF),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}