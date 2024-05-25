import 'package:flutter_demo/apis/login_api.dart';
import 'package:flutter_demo/controller/user_service.dart';
import 'package:get/get.dart';
import '../http/http_provider.dart';

///异步注入构造方法中的对象 用于Api网络请求相关的注入
///主要是在App初始化的时候就注入到依赖注入的池里面，并单例持久化
class AppBinding extends Bindings {
  @override
  void dependencies() async {
    // Get.put(ApiProvider(), permanent: true);
    Get.put(HttpProvider(), permanent: true);

    Get.lazyPut(() => LoginApi(Get.find()));

    // 用户信息服务（用户信息相关业务类）
    //controller
    Get.lazyPut(() => UserService(Get.find()));
    }
}
