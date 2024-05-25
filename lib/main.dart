import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/controller/user_service.dart';
import 'package:flutter_demo/router/app_router.dart';
import 'package:flutter_demo/theme/light_theme.dart';
import 'package:flutter_demo/ui/home/home_page.dart';
import 'package:flutter_demo/ui/login/login_page.dart';
import 'package:flutter_demo/widget/loading.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'binding/app_binding.dart';

void main() {
  appInit();
  runApp(LaunchApp());
  FlutterNativeSplash.remove();
}

void appInit() {
  //状态栏透明
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  //splash
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// 全局设置 EasyRefresh 的样式
  EasyRefresh.defaultHeaderBuilder = () => ClassicHeader(
    dragText: '下拉刷新'.tr,
    armedText: '释放刷新'.tr,
    readyText: '刷新中...'.tr,
    processingText: '刷新中...'.tr,
    processedText: '成功'.tr,
    noMoreText: '没有更多数据'.tr,
    failedText: '失败'.tr,
    messageText: '最近更新于 %T'.tr,
  );
  EasyRefresh.defaultFooterBuilder = () => ClassicFooter(
    dragText: '上拉加载更多'.tr,
    armedText: '释放刷新'.tr,
    readyText: '加载中...'.tr,
    processingText: '加载中...'.tr,
    processedText: '成功'.tr,
    noMoreText: '没有更多数据'.tr,
    failedText: '成功'.tr,
    showMessage: false,
    triggerOffset: 50,
    iconDimension: 22,
  );

  Loading();
}

class LaunchApp extends StatelessWidget {
  final _count = 0.obs;

  LaunchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: GetMaterialApp(
        title: "第一个Flutter",
        builder: (ctx, child) {
          child = EasyLoading.init()(ctx, child);
          child = FlutterSmartDialog.init()(ctx, child);
          return child;
        },
        getPages: AppRouter.routes,
        initialRoute: HomePage.routerName,
        initialBinding: AppBinding(),
        theme: lightTheme(),
      ),
    );
  }
}

Widget home(){
  return Scaffold(
    appBar: AppBar(
        title: const Center(
            child: Text("评分demo",
                style: TextStyle(fontSize: 18, color: Colors.white))),
        backgroundColor: Colors.blue),
    body: Column(
      children: [
        ElevatedButton(
            onPressed: () {
              Get.find<UserService>().handleLogoutParams();
              Get.offAllNamed(LoginPage.routerName);
            },
            child: const Text("关闭Loading")),
        ElevatedButton(
          child: Obx(() => Text("点击试试")),
          onPressed: () {
            Loading.show("");
            // Loading.toast("text");
          },
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Get.toNamed(HomePage.routerName);
      },
    ),
  );
}

class MyStarRating extends StatefulWidget {
  final double rating;
  final double totalRating = 10;
  final int starNum;

  const MyStarRating(this.rating, {super.key, this.starNum = 5});

  @override
  State<MyStarRating> createState() => _MyStarRatingState();
}

class _MyStarRatingState extends State<MyStarRating> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(mainAxisSize: MainAxisSize.min, children: buildUnStarWight()),
        Row(mainAxisSize: MainAxisSize.min, children: buildStarWight()),
      ],
    );
  }

  List<Widget> buildUnStarWight() {
    List<Widget> stars = [];
    List.generate(widget.starNum, (index) {
      stars.add(const Icon(Icons.star_border, size: 20));
    });
    return stars;
  }

  Widget star = const Icon(Icons.star, color: Colors.red, size: 20);

  List<Widget> buildStarWight() {
    List<Widget> stars = [];
    double oneValue = widget.totalRating / widget.starNum;
    var num = (widget.rating / oneValue).floor();
    double leftNum = (widget.rating / oneValue - num) * 20;
    for (var i = 0; i < num; i++) {
      stars.add(star);
    }
    stars.add(ClipRect(
      clipper: MyClipper(leftNum),
      child: star,
    ));
    return stars;
  }
}

class MyClipper extends CustomClipper<Rect> {
  final double leftSize;

  MyClipper(this.leftSize);

  @override
  bool shouldReclip(MyClipper oldClipper) {
    return leftSize != oldClipper.leftSize;
  }

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, leftSize, size.height);
  }
}
