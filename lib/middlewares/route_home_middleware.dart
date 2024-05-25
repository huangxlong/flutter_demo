import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/controller/user_service.dart';
import 'package:flutter_demo/ui/home/home_page.dart';
import 'package:flutter_demo/ui/login/login_page.dart';
import 'package:get/get.dart';

class RouteHomeMiddleware extends GetMiddleware{

  @override
  RouteSettings? redirect(String? route) {
    var userService = Get.find<UserService>();
    if(userService.isLogin){
      return null;
    }else{
      return const RouteSettings(name: LoginPage.routerName);
    }
  }
}