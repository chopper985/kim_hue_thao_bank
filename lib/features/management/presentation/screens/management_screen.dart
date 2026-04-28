// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';

// Project imports:
import 'package:kht_gold/core/app/colors/app_colors.dart';
import 'package:kht_gold/core/app/languages/data/localization.dart';
import 'package:kht_gold/core/app/styles/app_style_colors.dart';
import 'package:kht_gold/core/types/extensions/int_extension.dart';
import 'package:kht_gold/core/types/extensions/string_extension.dart';
import 'package:kht_gold/features/home/data/models/index.dart';
import 'package:kht_gold/features/home/presentation/cubit/home_cubit.dart';
import 'package:kht_gold/features/management/presentation/cubit/management_cubit.dart';
import 'package:kht_gold/features/management/presentation/widgets/daily_price_management_view.dart';
import 'package:kht_gold/features/management/presentation/widgets/gold_types_management_view.dart';
import 'package:kht_gold/features/management/presentation/widgets/management_menu_view.dart';
import 'package:kht_gold/features/settings/presentation/widgets/text_with_obligatory.dart';

class ManagementAppBarState {
  final String? title;
  final List<Widget>? actions;
  final bool canPop;
  final VoidCallback? onBackPressed;

  const ManagementAppBarState({
    this.title,
    this.actions,
    this.canPop = false,
    this.onBackPressed,
  });
}

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({
    super.key,
    this.embedded = false,
    this.onAppBarStateChanged,
  });

  final bool embedded;
  final ValueChanged<ManagementAppBarState>? onAppBarStateChanged;

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  final DateFormat _displayDateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ManagementCubit>();
    if (cubit.state.status == ManagementStatus.initial) {
      cubit.loadManagementData();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifyAppBar());
  }

  @override
  void didUpdateWidget(covariant ManagementScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifyAppBar());
  }

  void _notifyAppBar() {
    if (!mounted) return;
    widget.onAppBarStateChanged?.call(
      _currentAppBarState(context.read<ManagementCubit>().state),
    );
  }

  ManagementAppBarState _currentAppBarState(ManagementState state) {
    return switch (state.view) {
      ManagementView.menu => ManagementAppBarState(
        title: Strings.management.i18n,
      ),
      ManagementView.dailyPrice => ManagementAppBarState(
        title: Strings.dailyGoldPriceBoard.i18n,
        canPop: true,
        onBackPressed: _backToMenu,
        actions: [
          TextButton(
            onPressed:
                state.hasPendingPriceChanges &&
                    !state.isSavingPriceBoard &&
                    !state.isLoading
                ? () => context.read<ManagementCubit>().savePriceBoard()
                : null,
            child: state.isSavingPriceBoard
                ? SizedBox(
                    height: 15.sp,
                    width: 15.sp,
                    child: SpinKitSpinningLines(
                      color: AppStyleColors.textSecondary,
                      lineWidth: 2.2,
                      size: 20.sp,
                    ),
                  )
                : Text(
                    Strings.save.i18n,
                    style: TextStyle(
                      color: state.hasPendingPriceChanges
                          ? AppStyleColors.textSecondary
                          : AppStyleColors.textMuted,
                      fontWeight: .w600,
                      fontSize: 15.5.sp,
                    ),
                  ),
          ),
        ],
      ),
      ManagementView.goldTypes => ManagementAppBarState(
        title: Strings.manageGoldTypes.i18n,
        canPop: true,
        onBackPressed: _backToMenu,
        actions: [
          IconButton(
            onPressed: state.hasGoldTypeMutation ? null : _showGoldTypeForm,
            icon: state.isCreatingGoldType
                ? SpinKitSpinningLines(
                    color: colorText,
                    lineWidth: 2.2,
                    size: 20.sp,
                  )
                : const Icon(Icons.add_circle_outline_rounded),
            tooltip: Strings.addNewGoldType.i18n,
          ),
        ],
      ),
    };
  }

  void _backToMenu() {
    context.read<ManagementCubit>().setView(ManagementView.menu);
  }

  Future<void> _pickEffectiveDate() async {
    final DateTime initialDate = context
        .read<ManagementCubit>()
        .state
        .effectiveDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (!mounted || picked == null) return;
    await context.read<ManagementCubit>().changeEffectiveDate(picked);
  }

  Future<void> _showGoldTypeForm([GoldTypeModel? goldType]) async {
    final _GoldTypeFormResult? result =
        await showModalBottomSheet<_GoldTypeFormResult>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => _GoldTypeFormSheet(initialValue: goldType),
        );

    if (!mounted || result == null) return;

    await context.read<ManagementCubit>().saveGoldType(
      existing: goldType,
      name: result.name,
      sortOrder: result.sortOrder,
    );
  }

  Future<void> _deleteGoldType(GoldTypeModel goldType) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(Strings.confirmDeleteGoldType.i18n),
          content: Text(Strings.confirmDeleteGoldTypeMessage.i18n),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(Strings.cancel.i18n),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                Strings.delete.i18n,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldDelete != true) return;

    await context.read<ManagementCubit>().deleteGoldType(goldType);
  }

  PreferredSizeWidget _buildStandaloneAppBar(ManagementState state) {
    final ManagementAppBarState appBarState = _currentAppBarState(state);
    return AppBar(
      backgroundColor: AppStyleColors.appBarTint,
      foregroundColor: colorText,
      iconTheme: const IconThemeData(color: colorText),
      leading: appBarState.canPop
          ? IconButton(
              onPressed: appBarState.onBackPressed,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            )
          : null,
      title: Text(
        appBarState.title ?? Strings.management.i18n,
        style: TextStyle(color: colorText, fontWeight: .w700, fontSize: 17.sp),
      ),
      actions: appBarState.actions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManagementCubit, ManagementState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.message != current.message ||
          previous.hasPendingPriceChanges != current.hasPendingPriceChanges,
      listener: (context, state) {
        if ((state.message ?? '').isNotEmpty) {
          state.message?.showToast(
            ManagementStatus.failure == state.status
                ? ToastificationType.error
                : ToastificationType.success,
          );
        }

        if (state.status == ManagementStatus.priceBoardSaved ||
            state.status == ManagementStatus.goldTypeSaved ||
            state.status == ManagementStatus.goldTypeDeleted) {
          context.read<HomeCubit>().refreshIfViewingDate(
            date: state.effectiveDate,
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) => _notifyAppBar());
      },
      builder: (context, state) {
        final Widget body = SafeArea(
          top: false,
          bottom: false,
          child: AnimatedSwitcher(
            duration: 250.milliseconds,
            child: switch (state.view) {
              ManagementView.menu => const ManagementMenuView(),
              ManagementView.dailyPrice => DailyPriceManagementView(
                state: state,
                effectiveDateText: _displayDateFormat.format(
                  state.effectiveDate,
                ),
                onPickEffectiveDate: _pickEffectiveDate,
              ),
              ManagementView.goldTypes => GoldTypesManagementView(
                state: state,
                onEditGoldType: _showGoldTypeForm,
                onDeleteGoldType: _deleteGoldType,
              ),
            },
          ),
        );

        WidgetsBinding.instance.addPostFrameCallback((_) => _notifyAppBar());

        if (widget.embedded) {
          return body;
        }

        return Scaffold(appBar: _buildStandaloneAppBar(state), body: body);
      },
    );
  }
}

class _GoldTypeFormSheet extends StatefulWidget {
  const _GoldTypeFormSheet({this.initialValue});

  final GoldTypeModel? initialValue;

  @override
  State<_GoldTypeFormSheet> createState() => _GoldTypeFormSheetState();
}

class _GoldTypeFormSheetState extends State<_GoldTypeFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _sortOrderController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool get _isEdit => widget.initialValue != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialValue?.name ?? '',
    );
    _sortOrderController = TextEditingController(
      text: widget.initialValue?.sortOrder.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sortOrderController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      _GoldTypeFormResult(
        name: _nameController.text.trim(),
        sortOrder: int.parse(_sortOrderController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: mCL,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.sp)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.sp, 16.sp, 16.sp, 20.sp),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xffA67C00), AppStyleColors.brandGold],
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 28.sp,
                          width: 28.sp,
                          decoration: BoxDecoration(
                            color: mCL.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12.sp),
                          ),
                          child: Icon(
                            Icons.monetization_on_outlined,
                            color: mCL,
                            size: 22.sp,
                          ),
                        ),
                        SizedBox(width: 12.sp),
                        Expanded(
                          child: Text(
                            _isEdit
                                ? Strings.editGoldType.i18n
                                : Strings.addNewGoldType.i18n,
                            style: TextStyle(
                              color: mCL,
                              fontWeight: .w700,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.sp),
                  TextWithObligatory(title: Strings.goldTypeName.i18n),
                  SizedBox(height: 10.sp),
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return Strings.goldTypeNameRequired.i18n;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: Strings.exampleGoldType.i18n,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.sp),
                        borderSide: BorderSide(
                          color: AppStyleColors.brandGoldDark,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.sp),
                  TextWithObligatory(title: Strings.sortOrder.i18n),
                  SizedBox(height: 10.sp),
                  TextFormField(
                    controller: _sortOrderController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return Strings.sortOrderRequired.i18n;
                      }
                      if (int.tryParse(value!.trim()) == null) {
                        return Strings.sortOrderRequired.i18n;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.sp),
                        borderSide: BorderSide(
                          color: AppStyleColors.brandGoldDark,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.sp),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppStyleColors.surfaceInfo.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 24.sp,
                          width: 8.5.sp,
                          decoration: BoxDecoration(
                            color: AppStyleColors.brandGoldBanner,
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(12.sp),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.sp),
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: AppStyleColors.iconInfo,
                                size: 17.sp,
                              ),
                              SizedBox(width: 8.sp),
                              Expanded(
                                child: Text(
                                  Strings.smallerSortOrderHint.i18n,
                                  style: TextStyle(
                                    color: AppStyleColors.iconInfo,
                                    fontSize: 14.sp,
                                    fontWeight: .w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.sp),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: fCD,
                            padding: EdgeInsets.symmetric(vertical: 12.sp),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.sp),
                            ),
                          ),
                          icon: const Icon(Icons.close_rounded),
                          label: Text(Strings.cancel.i18n),
                        ),
                      ),
                      SizedBox(width: 14.sp),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: Color(0xffA67C00),
                            foregroundColor: mCL,
                            padding: EdgeInsets.symmetric(vertical: 12.sp),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.sp),
                            ),
                          ),
                          icon: const Icon(Icons.check_rounded),
                          label: Text(Strings.saveChanges.i18n),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoldTypeFormResult {
  final String name;
  final int sortOrder;

  const _GoldTypeFormResult({required this.name, required this.sortOrder});
}
