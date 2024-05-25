import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/apis/login_api.dart';
import 'package:flutter_demo/controller/user_service.dart';
import 'package:flutter_demo/ui/home/home_page.dart';
import 'package:flutter_demo/util/toast_util.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  late final phoneEditController = TextEditingController();
  late final codeEditController = TextEditingController();
  final sendCodeStr = "发送验证码".obs;
  final maxTime = 10;
  var timeDownTime = 10;
  var _isTiming = false;
  late Timer? _timer;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    phoneEditController.text ="15800000002";
    codeEditController.text = "228686";
  }

  void sendSmsCode() {
    if (_isTiming) return;
    print("$_isTiming,开始");
    timeDownTime = maxTime;
    sendCodeStr.value = "${timeDownTime}s";
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeDownTime <= 1) {
        sendCodeStr.value = "发送验证码";
        _isTiming = false;
        _timer?.cancel();
        _timer = null;
      } else {
        timeDownTime -= 1;
        _isTiming = true;
        sendCodeStr.value = "${timeDownTime}s";
      }
    });
  }

  void login() async {
    var phone = phoneEditController.value.text.trim();
    if (phone.isEmpty) {
      ToastUtil.showToast("请输入手机号");
      return;
    }

    var code = codeEditController.value.text.trim();
    if (code.isEmpty) {
      ToastUtil.showToast("请输入验证码");
      return;
    }

    var result = await Get.find<LoginApi>().login(phone, code);
    if (result.isSuccess) {
      ToastUtil.showToast("登录成功");
      var user = result.data;
      Get.find<UserService>().setToken("${user?.tokenHead} ${user?.token}");
      Get.offAllNamed(HomePage.routerName);
    } else {
      ToastUtil.showToast(result.errorMsg);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
