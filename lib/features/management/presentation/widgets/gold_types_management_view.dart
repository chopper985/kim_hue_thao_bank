// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Project imports:
import 'package:kht_gold/core/app/colors/app_colors.dart';
import 'package:kht_gold/core/app/languages/data/localization.dart';
import 'package:kht_gold/core/app/styles/app_style_colors.dart';
import 'package:kht_gold/core/utils/custom_list/pagination_list.dart';
import 'package:kht_gold/features/home/data/models/index.dart';
import 'package:kht_gold/features/management/presentation/cubit/management_cubit.dart';
import 'package:kht_gold/gen/assets.gen.dart';

class GoldTypesManagementView extends StatelessWidget {
  const GoldTypesManagementView({
    super.key,
    required this.state,
    required this.onEditGoldType,
    required this.onDeleteGoldType,
  });

  final ManagementState state;
  final Future<void> Function(GoldTypeModel goldType) onEditGoldType;
  final void Function(GoldTypeModel goldType) onDeleteGoldType;

  static const List<GoldTypeModel> skeletonGoldTypes = [
    GoldTypeModel(id: 'skeleton-gold-1', name: 'Vang 9999', sortOrder: 1),
    GoldTypeModel(id: 'skeleton-gold-2', name: 'Vang 98', sortOrder: 2),
    GoldTypeModel(id: 'skeleton-gold-3', name: 'Vang 97', sortOrder: 3),
  ];

  @override
  Widget build(BuildContext context) {
    final List<GoldTypeModel> items = state.isLoading
        ? skeletonGoldTypes
        : state.goldTypes;

    return Padding(
      key: const ValueKey('management-gold-types'),
      padding: EdgeInsets.only(top: 12.sp),
      child: Skeletonizer(
        enabled: state.isLoading,
        child: PaginationListView(
          padding: EdgeInsets.fromLTRB(14.sp, 0, 14.sp, 24.sp),
          itemCount: max(1, items.length),
          childShimmer: _GoldTypeCard(
            item: skeletonGoldTypes.first,
            isSavingGoldType: true,
            onEditGoldType: onEditGoldType,
            onDeleteGoldType: onDeleteGoldType,
          ),
          callBackRefresh: (done) async {
            await context.read<ManagementCubit>().loadManagementData();
            done();
          },
          itemBuilder: (context, index) {
            if (items.isEmpty) {
              return SizedBox(
                height: 40.h,
                child: Center(child: Text(Strings.emptyGoldPrice.i18n)),
              );
            }

            return _GoldTypeCard(
              item: items[index],
              isSavingGoldType: state.isSavingGoldType,
              onEditGoldType: onEditGoldType,
              onDeleteGoldType: onDeleteGoldType,
            );
          },
        ),
      ),
    );
  }
}

class _GoldTypeCard extends StatelessWidget {
  const _GoldTypeCard({
    required this.item,
    required this.isSavingGoldType,
    required this.onEditGoldType,
    required this.onDeleteGoldType,
  });

  final GoldTypeModel item;
  final bool isSavingGoldType;
  final Future<void> Function(GoldTypeModel goldType) onEditGoldType;
  final void Function(GoldTypeModel goldType) onDeleteGoldType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.sp),
      decoration: BoxDecoration(
        color: mCL,
        borderRadius: BorderRadius.circular(14.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 12.sp),
            decoration: BoxDecoration(
              color: AppStyleColors.brandGold.withValues(alpha: 0.85),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14.sp)),
            ),
            child: Row(
              children: [
                Image.asset(
                  Assets.icons.icGold2.path,
                  color: mCL,
                  width: 20.sp,
                  height: 20.sp,
                ),
                SizedBox(width: 12.sp),
                Text(
                  item.name,
                  style: TextStyle(
                    color: mCL,
                    fontSize: 16.5.sp,
                    fontWeight: .w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.sp),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${Strings.sortOrder.i18n}: ${item.sortOrder}',
                    style: TextStyle(
                      color: AppStyleColors.textPrimary,
                      fontWeight: .w700,
                      fontSize: 14.5.sp,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: isSavingGoldType
                      ? null
                      : () => onEditGoldType(item),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2E6BC5),
                    side: const BorderSide(color: Color(0xFF2E6BC5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                  ),
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(Strings.edit.i18n),
                ),
                SizedBox(width: 12.sp),
                FilledButton.icon(
                  onPressed: () => onDeleteGoldType(item),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppStyleColors.actionDanger,
                    foregroundColor: mCL,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                  ),
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: Text(Strings.delete.i18n),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
