import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orca_social_media_admin/constants/media_query.dart';
import 'package:orca_social_media_admin/controller/web/admin_panel_controller.dart';
import 'package:orca_social_media_admin/view/mobile/admin_panel/admin_panel_bottom_nav.dart';
import 'package:orca_social_media_admin/view/screens/academy/academy.dart';
import 'package:orca_social_media_admin/view/screens/dashboard/dashborad.dart';
import 'package:orca_social_media_admin/view/screens/users/users.dart';
import 'package:orca_social_media_admin/view/widgets/custom_admin_listout.dart';

class AdminPanel extends StatelessWidget {
  final String? selectedPage;
  
  AdminPanel({super.key, this.selectedPage}) {
    final controller = Get.put(AdminPanelController());
    controller.selectedPage.value = selectedPage ?? 'dashboard';
  }

  final AdminPanelController controller = Get.put(AdminPanelController());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return Scaffold(
      body: mediaQuery.isMobile ? AdminPanelMobile() :
      Row(
        children: <Widget>[
          // Custom Sidebar with icon and text in a row
          Container(
            width: 300,
            color: Colors.blueGrey[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.admin_panel_settings, size: 30),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Admin Panel',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                
                // Navigation items with `isSelected` condition
                Obx(() => CustomNavItem(
                      icon: Icons.dashboard,
                      label: 'Dashboard',
                      isSelected: controller.selectedPage.value == 'dashboard',
                      onTap: () => controller.changePage('dashboard'),
                    )),
                Obx(() => CustomNavItem(
                      icon: Icons.person,
                      label: 'Users',
                      isSelected: controller.selectedPage.value == 'users',
                      onTap: () => controller.changePage('users'),
                    )),
                Obx(() => CustomNavItem(
                      icon: Icons.confirmation_num,
                      label: 'Academy',
                      isSelected: controller.selectedPage.value == 'Academy',
                      onTap: () => controller.changePage('Academy'),
                    )),
              ],
            ),
          ),

          // Dashboard content area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                if (controller.selectedPage.value == 'dashboard') {
                  return const DashboradContents();
                } else if (controller.selectedPage.value == 'users') {
                  return const UsersContents();
                } else if (controller.selectedPage.value == 'Academy') {
                  return AcademyContents();
                } else {
                  return const Center(child: Text('Select a page'));
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
