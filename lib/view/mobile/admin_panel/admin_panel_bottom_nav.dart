import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orca_social_media_admin/constants/media_query.dart';
import 'package:orca_social_media_admin/controller/web/admin_panel_controller.dart';
import 'package:orca_social_media_admin/view/mobile/admin_panel/academy.dart';
import 'package:orca_social_media_admin/view/mobile/dashborad.dart';
import 'package:orca_social_media_admin/view/mobile/users.dart';
import 'package:orca_social_media_admin/view/widgets/custom_tween_container.dart';

class AdminPanelMobile extends StatelessWidget {
  final String? selectePage;
  AdminPanelMobile({super.key, this.selectePage}) {
    final controller = Get.put(AdminPanelController());
    controller.selectedPage.value = selectePage ?? 'dashboard';
  }

  final AdminPanelController controller = Get.put(AdminPanelController());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.selectedPage.value == 'dashboard') {
                return const Dashborad();
              } else if (controller.selectedPage.value == 'users') {
                return const UsersList();
              } else if (controller.selectedPage.value == 'Academy') {
                return const Academy();
              } else {
                return const Center(child: Text('No page found'));
              }
            }),
          ),
          Container(
            width: mediaQuery.screenWidth,
            height: mediaQuery.screenHeight * 0.08,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                color: Colors.grey),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Obx(
                  () => CustomTweenContainer(
                      onTap: () => controller.changePage('dashboard'),
                      label: 'Dashboard',
                      isSelected: controller.selectedPage.value == 'dashboard',
                      icon: Icons.dashboard),
                ),
                Obx(
                  () => CustomTweenContainer(
                      onTap: () => controller.changePage('users'),
                      label: 'Users',
                      isSelected: controller.selectedPage.value == 'users',
                      icon: Icons.person),
                ),
                Obx(
                  () => CustomTweenContainer(
                      onTap: () => controller.changePage('Academy'),
                      label: 'Academy',
                      isSelected: controller.selectedPage.value == 'Academy',
                      icon: Icons.confirmation_num),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
