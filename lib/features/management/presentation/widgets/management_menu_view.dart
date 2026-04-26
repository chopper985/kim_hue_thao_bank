// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:kht_gold/core/app/languages/data/localization.dart';
import 'package:kht_gold/core/app/styles/app_style_colors.dart';
import 'package:kht_gold/features/management/presentation/cubit/management_cubit.dart';
import 'package:kht_gold/features/settings/presentation/screens/settings_screen.dart';

class ManagementMenuView extends StatelessWidget {
  const ManagementMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('management-menu'),
      padding: EdgeInsets.all(16.sp),
      children: [
        _ManagementOptionCard(
          icon: Icons.currency_exchange_rounded,
          title: Strings.dailyGoldPriceBoard.i18n,
          subtitle: Strings.updateGoldPrice.i18n,
          onTap: () => context.read<ManagementCubit>().setView(
            ManagementView.dailyPrice,
          ),
        ),
        SizedBox(height: 12.sp),
        _ManagementOptionCard(
          icon: Icons.view_list_rounded,
          title: Strings.manageGoldTypes.i18n,
          subtitle: Strings.goldType.i18n,
          onTap: () =>
              context.read<ManagementCubit>().setView(ManagementView.goldTypes),
        ),
      ],
    );
  }
}

class _ManagementOptionCard extends StatelessWidget {
  const _ManagementOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureWrapper(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.sp),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAF7),
          borderRadius: BorderRadius.circular(16.sp),
          border: Border.all(color: AppStyleColors.borderBrand),
          boxShadow: const [
            BoxShadow(
              color: AppStyleColors.shadowSoft,
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 28.sp,
              width: 28.sp,
              decoration: BoxDecoration(
                color: AppStyleColors.brandGoldSurface,
                borderRadius: BorderRadius.circular(12.sp),
              ),
              child: Icon(icon, color: AppStyleColors.brandGold, size: 18.sp),
            ),
            SizedBox(width: 12.sp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppStyleColors.textSecondary,
                      fontSize: 15.sp,
                      fontWeight: .w700,
                    ),
                  ),
                  SizedBox(height: 4.sp),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppStyleColors.textMutedDark,
                      fontSize: 13.sp,
                      fontWeight: .w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppStyleColors.textMutedDark,
              size: 14.sp,
            ),
          ],
        ),
      ),
    );
  }
}
