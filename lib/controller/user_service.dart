import 'dart:core';
import 'package:flutter_demo/apis/login_api.dart';
import 'package:flutter_demo/base/constant.dart';
import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';

import '../util/log_utils.dart';

/// 用户相关的单例服务，保存了Token，UserProfile等信息
class UserService extends GetxService {
  static UserService get to => Get.find();

  final LoginApi _authRepository;

  UserService(this._authRepository);

  //用户登录Token
  String? token;

  //用户是否已经登录 - 可变字段
  Rx<bool> haslogin = false.obs;

  // 用户详情信息 - 可变字段
  // Rx<UserProfile> userProfile = UserProfile().obs;
  //
  //用户密码的类型 - 可变字段
  RxString passwordType = ''.obs;

  //极光推送的 registrationId - 可变字段
  RxString registrationId = ''.obs;

  //当前用户的未读消息数量
  RxInt unreadNotificationsCount = 0.obs;

  bool get hasToken => token?.isNotEmpty ?? false;

  bool get isLogin => haslogin.value;

  // UserProfile get getUserProfile => userProfile.value;

  String get getRegistrationId => registrationId.value;

  int get getUnreadNotificationsCount => unreadNotificationsCount.value;

  /// 设置全局的Token，同时更新haslogin 的值，赋值时机如下
  /*
      1. 在登录或注册成功的时候赋值
      2. 在main.dart中初始化的时候查询是否有Token,如果有的话需要赋值
      3. 退出登录的时候需要赋值
   */
  void setToken(String? token) {
    this.token = token;

    if (token == null || token.isEmpty) {
      haslogin.value = false;
      SpUtil.remove(Constant.CACHE_TOKEN);
    } else {
      haslogin.value = true;
      SpUtil.putString(Constant.CACHE_TOKEN, token);
    }

    Log.d('UserService =========> 设置Token为：$token');
  }

  // /// 请求接口获取用户详情
  // Future<UserProfile?> fetchUserProfile() async {
  //   //获取到数据
  //   var result = await _authRepository.fetchUserProfile();
  //
  //   //处理数据
  //   if (result.isSuccess) {
  //     final userProfile = result.data;
  //     if (userProfile != null) {
  //       //赋值给Rx对象
  //       this.userProfile.value = userProfile;
  //       passwordType.value = userProfile.passwordType ?? '';
  //
  //       bus.emit(AppConstant.eventProfileRefreshFinish, true);
  //       return userProfile;
  //     } else {
  //       bus.emit(AppConstant.eventProfileRefreshFinish, true);
  //       return null;
  //     }
  //   } else {
  //     SmartDialog.showToast(result.errorMsg ?? '');
  //     bus.emit(AppConstant.eventProfileRefreshFinish, true);
  //     return null;
  //   }
  // }

  /// 处理退出登录之后的数据清除
  void handleLogoutParams() {
    SpUtil.remove(Constant.CACHE_TOKEN);
    haslogin.value = false;
    // userProfile.value = UserProfile();
  }

  @override
  void onInit() {
    super.onInit();
    String? token = SpUtil.getString(Constant.CACHE_TOKEN);
    Log.d('UserService - 查询SP token：$token');
    setToken(token);
  }
}
