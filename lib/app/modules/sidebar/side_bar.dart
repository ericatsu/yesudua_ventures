import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:yesudua_ventures/app/modules/sidebar/sidebar_controller.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SidebarController>();
    final theme = Theme.of(context);

    return SidebarX(
      controller: controller.sidebarXController,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.zero,
        ),
        hoverColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        textStyle: TextStyle(color: Colors.grey[800], fontSize: 15),
        selectedTextStyle: TextStyle(
          color: theme.colorScheme.primary,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        hoverTextStyle: TextStyle(
          color: theme.colorScheme.primary,
          fontSize: 15,
        ),
        itemTextPadding: const EdgeInsets.only(left: 12),
        selectedItemTextPadding: const EdgeInsets.only(left: 12),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          border: const Border(),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
          border: Border(
            left: BorderSide(color: theme.colorScheme.primary, width: 4),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.grey[700], size: 22),
        selectedIconTheme: IconThemeData(
          color: theme.colorScheme.primary,
          size: 22,
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 250,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.05),
        ),
      ),
      footerDivider: Divider(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        height: 1,
      ),
      headerBuilder: (context, extended) {
        return Container(
          height: 80,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.1),
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child:
              extended
                  ? Text(
                    'Yesu Dea Ventures',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  )
                  : Icon(
                    Icons.store,
                    size: 28,
                    color: theme.colorScheme.primary,
                  ),
        );
      },
      items: [
        SidebarXItem(icon: Icons.point_of_sale, label: 'Sales'),
        SidebarXItem(icon: Icons.dashboard, label: 'Dashboard'),
        SidebarXItem(icon: Icons.inventory, label: 'Inventory'),
        SidebarXItem(icon: Icons.people_alt_outlined, label: 'Debtors'),
        SidebarXItem(icon: Icons.local_shipping_outlined, label: 'Suppliers'),
        SidebarXItem(icon: Icons.bar_chart, label: 'All Sales'),
      ],
      footerBuilder: (context, extended) {
        return Column(
          children: [
            // User profile area
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.03),
              ),
              child: Row(
                mainAxisAlignment:
                    extended
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
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
                  if (extended)
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
            // Logout button
            _buildLogoutButton(extended, theme, controller),
          ],
        );
      },
    );
  }

  Widget _buildLogoutButton(
    bool extended,
    ThemeData theme,
    SidebarController controller,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: controller.logout,
        splashColor: Colors.redAccent.withValues(alpha: 0.1),
        highlightColor: Colors.redAccent.withValues(alpha: 0.05),
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: extended ? 16 : 8),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment:
                extended ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, size: 22, color: Colors.redAccent),
              if (extended)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
