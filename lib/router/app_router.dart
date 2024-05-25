import 'package:flutter_demo/middlewares/route_home_middleware.dart';
import 'package:flutter_demo/ui/home/home_binding.dart';
import 'package:flutter_demo/ui/home/home_page.dart';
import 'package:flutter_demo/ui/login/login_binding.dart';
import 'package:flutter_demo/ui/login/login_page.dart';
import 'package:get/get.dart';

class AppRouter {
  static final List<GetPage> routes = [
    GetPage(
        name: LoginPage.routerName,
        page: () => const LoginPage(),
        binding: LoginBinding()),
    GetPage(
        name: HomePage.routerName,
        page: () => const HomePage(),
        binding: HomeBinding(),
        middlewares: [RouteHomeMiddleware()]),
  ];
}
