// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Project imports:
import 'package:kht_gold/core/app/colors/app_colors.dart';
import 'package:kht_gold/core/app/languages/data/localization.dart';
import 'package:kht_gold/core/app/styles/app_style_colors.dart';
import 'package:kht_gold/core/types/extensions/scroll_extension.dart';
import 'package:kht_gold/core/utils/custom_list/pagination_list.dart';
import 'package:kht_gold/features/management/presentation/cubit/management_cubit.dart';
import 'package:kht_gold/gen/assets.gen.dart';

class DailyPriceManagementView extends StatefulWidget {
  const DailyPriceManagementView({
    super.key,
    required this.state,
    required this.effectiveDateText,
    required this.onPickEffectiveDate,
  });

  final ManagementState state;
  final String effectiveDateText;
  final Future<void> Function() onPickEffectiveDate;

  static const List<ManagementPriceItem> skeletonPriceItems = [
    ManagementPriceItem(
      goldTypeId: 'skeleton-1',
      goldTypeName: 'Vang 9999',
      sortOrder: 1,
      buyPrice: '14,000,000',
      sellPrice: '15,000,000',
    ),
    ManagementPriceItem(
      goldTypeId: 'skeleton-2',
      goldTypeName: 'Vang 98',
      sortOrder: 2,
      buyPrice: '14,000,000',
      sellPrice: '16,000,000',
    ),
    ManagementPriceItem(
      goldTypeId: 'skeleton-3',
      goldTypeName: 'Vang 97',
      sortOrder: 3,
      buyPrice: '14,000,000',
      sellPrice: '17,000,000',
    ),
  ];

  @override
  State<DailyPriceManagementView> createState() =>
      _DailyPriceManagementViewState();
}

class _DailyPriceManagementViewState extends State<DailyPriceManagementView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.scrollToStartScreen;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<ManagementPriceItem> items = widget.state.isLoading
        ? DailyPriceManagementView.skeletonPriceItems
        : widget.state.priceItems;

    return Column(
      key: const ValueKey('management-daily-price'),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(14.sp, 14.sp, 14.sp, 12.sp),
          child: Container(
            width: 100.w,
            padding: EdgeInsets.all(14.sp),
            decoration: BoxDecoration(
              color: AppStyleColors.brandGold,
              borderRadius: BorderRadius.circular(14.sp),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${Strings.updateGoldPrice.i18n} - ${widget.effectiveDateText}',
                  style: TextStyle(
                    color: AppStyleColors.textOnBrand,
                    fontSize: 15.5.sp,
                    fontWeight: .w800,
                  ),
                ),
                SizedBox(height: 10.sp),
                OutlinedButton.icon(
                  onPressed: widget.state.isLoading
                      ? null
                      : widget.onPickEffectiveDate,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppStyleColors.textOnBrand,
                    side: const BorderSide(color: AppStyleColors.borderOnBrand),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                  ),
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: Text(Strings.chooseDate.i18n),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: widget.state.isLoading
              ? Skeletonizer(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(14.sp, 14.sp, 14.sp, 24.sp),
                    itemCount:
                        DailyPriceManagementView.skeletonPriceItems.length,
                    itemBuilder: (context, index) {
                      return _PriceCard(
                        item:
                            DailyPriceManagementView.skeletonPriceItems[index],
                      );
                    },
                  ),
                )
              : PaginationListView(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(14.sp, 14.sp, 14.sp, 24.sp),
                  itemCount: max(1, items.length),
                  childShimmer: _PriceCard(
                    item: DailyPriceManagementView.skeletonPriceItems.first,
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

                    return _PriceCard(item: items[index]);
                  },
                ),
        ),
      ],
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({required this.item});

  final ManagementPriceItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.sp),
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: AppStyleColors.surfaceWarm,
        borderRadius: BorderRadius.circular(14.sp),
        border: Border.all(color: mCL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 26.sp,
                width: 26.sp,
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  color: AppStyleColors.brandGoldSoft.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  Assets.icons.icGold.path,
                  width: 16.sp,
                  height: 16.sp,
                ),
              ),
              SizedBox(width: 12.sp),
              Expanded(
                child: Text(
                  item.goldTypeName,
                  style: TextStyle(
                    color: AppStyleColors.textSecondary,
                    fontSize: 17.5.sp,
                    fontWeight: .w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.sp),
          _EditablePriceField(
            label: Strings.buyPricePerChi.i18n,
            initialValue: item.buyPrice,
            onChanged: (value) => context
                .read<ManagementCubit>()
                .updatePriceField(item.goldTypeId, true, value),
          ),
          SizedBox(height: 10.sp),
          _EditablePriceField(
            label: Strings.sellPricePerChi.i18n,
            initialValue: item.sellPrice,
            onChanged: (value) => context
                .read<ManagementCubit>()
                .updatePriceField(item.goldTypeId, false, value),
          ),
        ],
      ),
    );
  }
}

class _EditablePriceField extends StatefulWidget {
  const _EditablePriceField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<_EditablePriceField> createState() => _EditablePriceFieldState();
}

class _EditablePriceFieldState extends State<_EditablePriceField> {
  late final TextEditingController _controller;
  final NumberFormat _formatter = NumberFormat.decimalPattern('vi_VN');

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant _EditablePriceField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.value = TextEditingValue(
        text: widget.initialValue,
        selection: TextSelection.collapsed(offset: widget.initialValue.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    final String digits = value.replaceAll(RegExp('[^0-9]'), '');
    final String formatted = digits.isEmpty
        ? '0'
        : _formatter.format(int.parse(digits));

    if (formatted != value) {
      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    widget.onChanged(formatted);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: AppStyleColors.textPrimary,
            fontWeight: .w700,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(height: 10.sp),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          onChanged: _handleChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: mCL,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.sp,
              vertical: 11.sp,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.sp),
              borderSide: BorderSide(color: AppStyleColors.brandGoldDark),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.sp),
              borderSide: BorderSide(color: mCL),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.sp),
              borderSide: BorderSide(color: mCL),
            ),
          ),
        ),
      ],
    );
  }
}
