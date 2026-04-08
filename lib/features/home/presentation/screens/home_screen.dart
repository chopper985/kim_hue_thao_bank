// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:intl/intl.dart';
import 'package:kht_gold/features/home/presentation/widgets/drawer_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:kht_gold/core/app/colors/app_colors.dart';
import 'package:kht_gold/core/app/languages/data/localization.dart';
import 'package:kht_gold/core/app/languages/service/model.dart';
import 'package:kht_gold/core/app/languages/service/service.dart';
import 'package:kht_gold/core/constants/constants.dart';
import 'package:kht_gold/core/navigator/app_router.dart';
import 'package:kht_gold/core/utils/custom_list/pagination_list.dart';
import 'package:kht_gold/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kht_gold/features/home/data/models/index.dart';
import 'package:kht_gold/features/home/presentation/cubit/home_cubit.dart';
import 'package:kht_gold/features/settings/presentation/screens/settings_screen.dart';

const List<PriceBoardModel> _skeletonPriceBoard = [
  PriceBoardModel(
    goldTypeId: '',
    goldTypeName: 'Vàng 9999',
    sortOrder: 1,
    buyPriceDisplay: '15.500.000',
    sellPriceDisplay: '15.600.000',
    updatedAt: null,
  ),
  PriceBoardModel(
    goldTypeId: '',
    goldTypeName: 'Vàng 98',
    sortOrder: 2,
    buyPriceDisplay: '15.100.000',
    sellPriceDisplay: '15.400.000',
    updatedAt: null,
  ),
  PriceBoardModel(
    goldTypeId: '',
    goldTypeName: 'Vàng 97',
    sortOrder: 3,
    buyPriceDisplay: '15.000.000',
    sellPriceDisplay: '15.100.000',
    updatedAt: null,
  ),
  PriceBoardModel(
    goldTypeId: '',
    goldTypeName: 'Vàng 999',
    sortOrder: 4,
    buyPriceDisplay: '14.900.000',
    sellPriceDisplay: '15.000.000',
    updatedAt: null,
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  HomeDrawerDestination _selectedDestination = HomeDrawerDestination.home;
  late Language _selectedLanguage = LanguageService().getLocale();

  String get _selectedDateText =>
      DateFormat('dd/MM/yyyy').format(_selectedDate);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<HomeCubit>().getPriceBoard(date: _selectedDate);
    });
  }

  Future<void> _pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (date == null) return;
    if (!mounted) return;

    setState(() {
      _selectedDate = date;
    });

    context.read<HomeCubit>().getPriceBoard(date: date);
  }

  void _selectDestination(HomeDrawerDestination destination) {
    setState(() {
      _selectedDestination = destination;
    });
  }

  void _changeLanguage(Language language) {
    LanguageService().saveLocale(language.langCode);
    context.locale = language.locale;

    setState(() {
      _selectedLanguage = language;
    });
  }

  String _titleForDestination(HomeDrawerDestination destination) {
    return switch (destination) {
      HomeDrawerDestination.settings => Strings.settings.i18n,
      HomeDrawerDestination.management => Strings.management.i18n,
      HomeDrawerDestination.home => appName,
    };
  }

  Widget _buildBody(HomeDrawerDestination destination) {
    return switch (destination) {
      HomeDrawerDestination.settings => SafeArea(
        child: SettingsContent(
          selectedLanguage: _selectedLanguage,
          onLanguageSelected: _changeLanguage,
        ),
      ),
      HomeDrawerDestination.management => Center(
        child: Text(
          Strings.management.i18n,
          style: TextStyle(fontSize: 16.sp, fontWeight: .w700),
        ),
      ),
      HomeDrawerDestination.home => _HomePriceBoardBody(
        selectedDate: _selectedDate,
        selectedDateText: _selectedDateText,
        onPickDate: _pickDate,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final bool isAuthenticated = state is AuthAuthenticated;
        final HomeDrawerDestination selectedDestination =
            !isAuthenticated &&
                _selectedDestination == HomeDrawerDestination.management
            ? HomeDrawerDestination.home
            : _selectedDestination;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: colorText.withValues(alpha: 0.05),
            foregroundColor: colorText,
            iconTheme: const IconThemeData(color: colorText),
            title: Text(
              _titleForDestination(selectedDestination),
              style: TextStyle(
                color: colorText,
                fontWeight: .w700,
                fontSize: 17.sp,
              ),
            ),
          ),
          drawer: Drawer(
            child: DrawerWidget(
              isAuthenticated: isAuthenticated,
              selectedDestination: selectedDestination,
              onDestinationSelected: _selectDestination,
              onLoginSelected: () {
                LoginRoute().push(context);
              },
              onLogoutSelected: () {
                context.read<AuthCubit>().logout();
                _selectDestination(HomeDrawerDestination.home);
              },
            ),
            width: 75.w,
          ),
          body: _buildBody(selectedDestination),
        );
      },
    );
  }
}

class _HomePriceBoardBody extends StatelessWidget {
  final DateTime selectedDate;
  final String selectedDateText;
  final VoidCallback onPickDate;

  const _HomePriceBoardBody({
    required this.selectedDate,
    required this.selectedDateText,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.sp),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.sp),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 12.sp,
                  vertical: 8.5.sp,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFCF2),
                  borderRadius: BorderRadius.circular(10.sp),
                  border: Border.all(color: colorText, width: 1.5),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: const Color(0xFF5A0500),
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.sp),
                    Text(
                      '${Strings.selectDate.i18n}:',
                      style: TextStyle(
                        color: const Color(0xFF5A0500),
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(width: 10.sp),
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(6.sp),
                        onTap: onPickDate,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.sp,
                            vertical: 8.5.sp,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.sp),
                            border: Border.all(color: colorText, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 4.sp),
                              Expanded(
                                child: Text(
                                  selectedDateText,
                                  style: TextStyle(
                                    color: const Color(0xFF30333A),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.5.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.sp),
                              Icon(
                                Icons.calendar_today,
                                color: Colors.black,
                                size: 16.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.sp),
            Expanded(child: _GoldPriceBoard(selectedDate: selectedDate)),
          ],
        ),
      ),
    );
  }
}

class _GoldPriceBoard extends StatelessWidget {
  final DateTime selectedDate;

  const _GoldPriceBoard({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomePriceBoardLoading || state is HomeInitial) {
          return Skeletonizer(
            child: _GoldPriceBoardContent(
              priceBoard: _skeletonPriceBoard,
              lastUpdatedText: '00:00 00/00/0000',
              selectedDate: selectedDate,
            ),
          );
        }

        if (state is HomePriceBoardFailure) {
          return Center(child: Text(Strings.loadGoldPriceFailed.i18n));
        }

        final List<PriceBoardModel> priceBoard = state is HomePriceBoardLoaded
            ? state.priceBoard
            : [];
        final String lastUpdatedText = priceBoard.isNotEmpty
            ? DateFormat(
                'HH:mm dd/MM/yyyy',
              ).format(priceBoard.first.updatedAt?.toLocal() ?? DateTime.now())
            : '--:-- --/--/----';

        return _GoldPriceBoardContent(
          priceBoard: priceBoard,
          lastUpdatedText: lastUpdatedText,
          selectedDate: selectedDate,
        );
      },
    );
  }
}

class _GoldPriceBoardContent extends StatelessWidget {
  final List<PriceBoardModel> priceBoard;
  final String lastUpdatedText;
  final DateTime selectedDate;

  const _GoldPriceBoardContent({
    required this.priceBoard,
    required this.lastUpdatedText,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _GoldPriceHeader(total: priceBoard.length),
        SizedBox(height: 6.sp),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 12.sp),
            child: Text(
              '${Strings.lastUpdated.i18n}: $lastUpdatedText',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11.5.sp,
                fontWeight: .w500,
              ),
            ),
          ),
        ),
        SizedBox(height: 10.sp),
        Expanded(
          child: PaginationListView(
            itemCount: priceBoard.isEmpty ? 1 : priceBoard.length,
            childShimmer: const SizedBox.shrink(),
            callBackRefresh: (done) async {
              await context.read<HomeCubit>().getPriceBoard(date: selectedDate);
              done();
            },
            itemBuilder: (context, index) {
              if (priceBoard.isEmpty) {
                return SizedBox(
                  height: 40.h,
                  child: Center(child: Text(Strings.emptyGoldPrice.i18n)),
                );
              }

              return Padding(
                padding: EdgeInsets.only(bottom: 10.sp),
                child: _GoldPriceCard(price: priceBoard[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GoldPriceHeader extends StatelessWidget {
  final int total;

  const _GoldPriceHeader({required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.sp),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.only(left: 12.sp),
              child: Text(
                '${Strings.goldType.i18n.toUpperCase()} ($total)',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13.5.sp,
                  fontWeight: .w600,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              Strings.buyPrice.i18n.toUpperCase(),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13.5.sp,
                fontWeight: .w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              Strings.sellPrice.i18n.toUpperCase(),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13.5.sp,
                fontWeight: .w600,
                letterSpacing: 1,
              ),
            ),
          ),
          SizedBox(width: 22.sp),
        ],
      ),
    );
  }
}

class _GoldPriceCard extends StatelessWidget {
  final PriceBoardModel price;

  const _GoldPriceCard({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 12.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.5.sp),
        border: Border.all(
          color: colorText.withValues(alpha: 0.45),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price.goldTypeName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF1F2128),
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5.sp),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.sp,
                    vertical: 4.sp,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F6EE),
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                  child: Text(
                    '${Strings.spread.i18n}: ${_spreadText(price)}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: _GoldPriceValue(
              price: price.buyPriceDisplay,
              priceColor: const Color(0xFF007A36),
            ),
          ),
          Expanded(
            flex: 3,
            child: _GoldPriceValue(
              price: price.sellPriceDisplay,
              priceColor: const Color(0xFFD70018),
            ),
          ),
        ],
      ),
    );
  }

  String _spreadText(PriceBoardModel price) {
    final int? buyPrice = _parsePrice(price.buyPriceDisplay);
    final int? sellPrice = _parsePrice(price.sellPriceDisplay);

    if (buyPrice == null || sellPrice == null) {
      return '-';
    }

    return '${NumberFormat.decimalPattern('vi_VN').format(sellPrice - buyPrice)} đ';
  }

  int? _parsePrice(String price) {
    return int.tryParse(price.replaceAll(RegExp('[^0-9]'), ''));
  }
}

class _GoldPriceValue extends StatelessWidget {
  final String price;
  final Color priceColor;

  const _GoldPriceValue({required this.price, required this.priceColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      price,
      textAlign: TextAlign.right,
      style: TextStyle(
        color: priceColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
