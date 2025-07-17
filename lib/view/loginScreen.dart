import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proj001/view/signupScreen.dart';
import '../controller/loginController.dart';
import '../coree/function/inputValid.dart';
class loginScreen extends StatelessWidget {
  const loginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginControllerImp());

    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            Get.find<LoginControllerImp>().changeTabIndex(tabController.index);
          });

          return Scaffold(
            body: GetBuilder<LoginControllerImp>(
              builder: (controller) => Stack(
                children: [
                  Container(color: const Color(0xFF007AFF)),
                  SizedBox.expand(
                    child: Image.asset(
                      controller.currentTabIndex == 0
                     ? 'assets/images/Frame 11.png'
                      : 'assets/images/Frame 10.png' ,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: 30,
                    child: Text(
                      controller.currentTabIndex == 0
                          ? "Welcome back\nLogin"
                          : "Create\nAccount",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            blurRadius: 5,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                        left: 30,
                        right: 30,
                        top: 150,
                        bottom: 100,
                      ),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 30),
                            const TabBar(
                              labelColor: Color(0xFF3B0BFA),
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Color(0xFFFFBE85),
                              tabs: [
                                Tab(text: 'تسجيل الدخول'),
                                Tab(text: 'إنشاء حساب'),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 400,
                              child: TabBarView(
                                children: [
                                  _buildLoginForm(),
                                  const SignUpScreen(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginForm() {
    final controller = Get.find<LoginControllerImp>();
    return Form(
      key: controller.loginFormKey,
      child: Column(
        children: [
          const SizedBox(height: 30),
          TextFormField(
            validator: (value) => validInput(value!, 5, 100, "email"),
            controller: controller.email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'البريد الإلكتروني',
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            validator: (value) => validInput(value!, 5, 30, "password"),
            controller: controller.password,
            obscureText: controller.isPassword,
            decoration: InputDecoration(
              labelText: 'كلمة المرور',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: const Icon(Icons.remove_red_eye_outlined),
                onPressed: controller.showPassword,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 30),
          MaterialButton(
            onPressed: controller.login,
            color: const Color(0xFFFFBE85),
            height: 50,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'تسجيل الدخول',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
