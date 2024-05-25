import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{

  late final refreshControl = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true
  );

  Future<dynamic> onRefresh() async{

  }

  Future<dynamic> onLoad() async{

  }
}