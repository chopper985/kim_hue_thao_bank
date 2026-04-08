// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:kht_gold/core/app/colors/app_colors.dart';
import 'package:kht_gold/core/app/languages/data/localization.dart';
import 'package:kht_gold/core/constants/constants.dart';
import 'package:kht_gold/gen/assets.gen.dart';

enum HomeDrawerDestination { home, settings, management }

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
    required this.isAuthenticated,
    required this.selectedDestination,
    required this.onDestinationSelected,
    required this.onLoginSelected,
    required this.onLogoutSelected,
  });

  final bool isAuthenticated;
  final HomeDrawerDestination selectedDestination;
  final ValueChanged<HomeDrawerDestination> onDestinationSelected;
  final VoidCallback onLoginSelected;
  final VoidCallback onLogoutSelected;

  void _selectDestination(
    BuildContext context,
    HomeDrawerDestination destination,
  ) {
    Navigator.of(context).pop();
    onDestinationSelected(destination);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.sp).add(EdgeInsets.only(top: 24.sp)),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFCF2),
              border: Border(
                bottom: BorderSide(color: colorText.withValues(alpha: 0.35)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 26.sp,
                  width: 26.sp,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(3.sp),
                    child: Image.asset(
                      Assets.icons.icKhtGold.path,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: 16.sp),
                Expanded(
                  child: Text(
                    '${Strings.goldStore.i18n} $appName',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF5A0500),
                      fontSize: 16.sp,
                      fontWeight: .w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8.sp),
              children: [
                ListTile(
                  selectedColor: colorText,
                  leading: const Icon(Icons.home_outlined),
                  title: Text(Strings.home.i18n),
                  selected: selectedDestination == HomeDrawerDestination.home,
                  onTap: () {
                    _selectDestination(context, HomeDrawerDestination.home);
                  },
                ),
                ListTile(
                  selectedColor: colorText,
                  leading: const Icon(Icons.settings_outlined),
                  title: Text(Strings.settings.i18n),
                  selected:
                      selectedDestination == HomeDrawerDestination.settings,
                  onTap: () {
                    _selectDestination(context, HomeDrawerDestination.settings);
                  },
                ),
                if (isAuthenticated)
                  ListTile(
                    selectedColor: colorText,
                    leading: const Icon(Icons.dashboard_outlined),
                    title: Text(Strings.management.i18n),
                    selected:
                        selectedDestination == HomeDrawerDestination.management,
                    onTap: () {
                      _selectDestination(
                        context,
                        HomeDrawerDestination.management,
                      );
                    },
                  )
                else
                  ListTile(
                    selectedColor: colorText,
                    leading: const Icon(Icons.login_outlined),
                    title: Text(Strings.login.i18n),
                    onTap: () {
                      Navigator.of(context).pop();
                      onLoginSelected();
                    },
                  ),
                if (isAuthenticated)
                  ListTile(
                    selectedColor: colorText,
                    leading: const Icon(Icons.logout_outlined),
                    title: Text(Strings.logout.i18n),
                    onTap: () {
                      Navigator.of(context).pop();
                      onLogoutSelected();
                    },
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.sp),
            child: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final String version = snapshot.data == null
                    ? ''
                    : ' v${snapshot.data!.version}';

                return Align(
                  child: Text(
                    '${Strings.versionLabel.i18n}$version',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13.5.sp,
                      fontWeight: .w500,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20.sp),
        ],
      ),
    );
  }
}
