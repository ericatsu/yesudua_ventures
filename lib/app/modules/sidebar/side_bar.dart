import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/modules/sidebar/sidebar_controller.dart';
import 'package:yesudua_ventures/app/routes/app_routes.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    // Make sidebar width responsive based on screen size
    final sidebarWidth = screenSize.width < 600 ? 60.0 : 250.0;
    final bool isCompact = sidebarWidth <= 60;

    return Container(
      width: sidebarWidth,
      color: theme.colorScheme.primary.withOpacity(0.05),
      child: Column(
        children: [
          // App logo or title area
          Container(
            height: 80,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child:
                isCompact
                    ? Icon(
                      Icons.store,
                      size: 28,
                      color: theme.colorScheme.primary,
                    )
                    : Text(
                      'Yesu Dea Ventures',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
          ),

          // Navigation items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  route: AppRoutes.DASHBOARD,
                  isCompact: isCompact,
                ),
                _buildNavItem(
                  icon: Icons.point_of_sale,
                  title: 'Sales',
                  route: AppRoutes.SALES,
                  isCompact: isCompact,
                ),
                _buildNavItem(
                  icon: Icons.inventory,
                  title: 'Inventory',
                  route: AppRoutes.INVENTORY,
                  isCompact: isCompact,
                ),
                _buildNavItem(
                  icon: Icons.people_alt_outlined,
                  title: 'Debtors',
                  route: AppRoutes.DEBTORS,
                  isCompact: isCompact,
                ),
                _buildNavItem(
                  icon: Icons.local_shipping_outlined,
                  title: 'Suppliers',
                  route: AppRoutes.SUPPLIERS,
                  isCompact: isCompact,
                ),
                _buildNavItem(
                  icon: Icons.bar_chart,
                  title: 'Reports',
                  route: AppRoutes.REPORTS,
                  isCompact: isCompact,
                ),
              ],
            ),
          ),

          // User profile or footer area
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: theme.colorScheme.primary,
                  child: const Icon(
                    Icons.person,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                if (!isCompact)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Admin User',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'admin@yesudea.com',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required String route,
    required bool isCompact,
  }) {
    return GetBuilder<SidebarController>(
      builder: (_) {
        final isSelected = Get.currentRoute == route;
        final theme = Get.theme;

        return InkWell(
          onTap: () {
            if (Get.currentRoute != route) {
              Get.toNamed(route);
            }
          },
          child: Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: isCompact ? 8 : 16),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? theme.colorScheme.primary.withOpacity(0.1)
                      : Colors.transparent,
              border: Border(
                left: BorderSide(
                  color:
                      isSelected
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                  width: 4,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color:
                      isSelected ? theme.colorScheme.primary : Colors.grey[700],
                ),
                if (!isCompact)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color:
                            isSelected
                                ? theme.colorScheme.primary
                                : Colors.grey[800],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}