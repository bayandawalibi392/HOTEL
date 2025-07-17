import 'package:get/get.dart';
import 'package:proj001/view/AvailableRoomsScreen.dart';
import 'package:proj001/view/MassageOrdersScreen.dart';
import 'package:proj001/view/RoomDetailsScreen.dart';
import 'package:proj001/view/cartScreen.dart';
import 'package:proj001/view/homeScreen.dart';
import 'package:proj001/view/loginScreen.dart';
import 'package:proj001/view/navbar.dart';
import 'package:proj001/view/orderFoodScreen.dart';
import 'package:proj001/view/restaurantScreen.dart';
import 'package:proj001/view/roomTypeScreen.dart';
import 'package:proj001/view/signupScreen.dart';
import 'package:proj001/view/splashScreen.dart';
import 'package:proj001/view/viewOrderScreen.dart';

import 'coree/constant/routes.dart';



List<GetPage<dynamic>>? routes = [
  GetPage(name: "/", page: () => splashScreen()),
  GetPage(name: AppRout.login ,page: () =>  loginScreen()),
  //     middlewares: [MidleWare()]
  // ),
  // GetPage(name: AppRout.login ,page: () => const loginScreen()),
  GetPage(name: AppRout.signupScreen ,page: () => const SignUpScreen()),
  GetPage(name: AppRout.HomeScreen ,page: () => const HomeScreen()),
  GetPage(name: AppRout.RoomTypeScreen ,page: () =>  RoomTypeScreen()),
  GetPage(name: AppRout.Navbar ,page: () => const Navbar()),
  GetPage(name: AppRout.cartScreen ,page: () =>  CartScreen()),
  GetPage(name: AppRout.RestaurantScreen ,page: () =>  RestaurantScreen()),
  GetPage(name: AppRout.AvailableRoomsScreen ,page: () =>  AvailableRoomsScreen()),
  GetPage(name: AppRout.ViewOrderScreen ,page: () =>  ViewOrderScreen()),
  GetPage(name: AppRout.RoomDetailsScreen ,page: () =>  RoomDetailsScreen()),
  GetPage(name: AppRout.orderFoodScreen ,page: () =>  orderFoodScreen()),
  GetPage(name: AppRout.MassageOrdersScreen ,page: () =>  MassageOrdersScreen()),
];

