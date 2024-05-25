import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/home/home_controller.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  static const routerName = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Home1")),
      body: Center(
        child: _buildListView(),
      ),
    );
  }

  Widget _buildListView() {
    return EasyRefresh.builder(
      controller: controller.refreshControl,
      onRefresh: () {
        controller.onRefresh();
      },
      onLoad: () {
        controller.onLoad();
      },
      childBuilder: (ctx, p) {
        return CustomScrollView(
          physics: p,
          slivers: [
            SliverList(
                delegate: SliverChildBuilderDelegate((ctx, index) {
              return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: const EdgeInsets.fromLTRB(11, 12, 13, 14),
                  child: Text("data$index"));
            }, childCount: 200))
          ],
        );
      },
    );
  }
}
