import 'package:flutter/material.dart';
import 'package:flutter_demo/base/app_colors.dart';
import 'package:flutter_demo/ui/login/login_controller.dart';
import 'package:flutter_demo/widget/custom_elevated_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  static const routerName = "/login";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 59.w, 12.w, 12.h),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/bg_login.png"), fit: BoxFit.fill),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeText(),
          SizedBox(
            height: 39.h,
          ),
          _buildLoginInputWidget(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Text(
              "客服电话 028-88888",
              style: TextStyle(fontSize: 15.sp, color: const Color(0x50FFFFFF)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Text(
      "您好，\n欢迎使用云集慧金采",
      style: TextStyle(fontSize: 26.sp, color: Colors.white),
    );
  }

  Widget _buildLoginInputWidget() {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.fromLTRB(20.w, 28.w, 20.w, 48.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.w),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "手机号",
                  style: TextStyle(
                      fontSize: 18.sp, color: AppColors.text_color_dark),
                ),
                TextField(
                  maxLength: 11,
                  maxLines: 1,
                  controller: controller.phoneEditController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                      color: AppColors.text_color_dark, fontSize: 15.sp),
                  decoration: InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                      hintText: "请输入手机号",
                      hintStyle: TextStyle(
                          color: AppColors.text_color_hint, fontSize: 15.sp)),
                ),
                Divider(
                  height: 0.5.w,
                  color: AppColors.divider_color,
                ),
                SizedBox(height: 24.h),
                Text(
                  "验证码",
                  style: TextStyle(
                      fontSize: 18.sp, color: AppColors.text_color_dark),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: controller.codeEditController,
                          maxLength: 8,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color: AppColors.text_color_dark,
                              fontSize: 15.sp),
                          decoration: InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            hintText: "请输入验证码",
                            hintStyle: TextStyle(
                                color: AppColors.text_color_hint,
                                fontSize: 15.sp),
                          )),
                    ),
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.w),
                        child: Row(
                          children: [
                            Obx(() => Text(
                                  controller.sendCodeStr.value,
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      color: AppColors.mainColor),
                                ))
                          ],
                        ),
                      ),
                      onTap: () {
                        controller.sendSmsCode();
                      },
                    )
                  ],
                ),
                Divider(
                  height: 0.5.w,
                  color: AppColors.divider_color,
                ),
                SizedBox(
                  height: 44.h,
                ),
                CustomElevatedButton(
                    onPressed: () {
                      controller.login();
                    },
                    text: "登录"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
