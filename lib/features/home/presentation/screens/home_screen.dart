// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:kht_gold/core/app/colors/app_colors.dart';
import 'package:kht_gold/core/constants/constants.dart';
import 'package:kht_gold/core/navigator/app_router.dart';
import 'package:kht_gold/features/auth/presentation/cubit/auth_cubit.dart';

const int _goldPriceTotal = 97;

const List<_GoldPrice> _goldPrices = [
  _GoldPrice(
    name: 'Bao Tin 9999',
    spread: '300.000 đ',
    buyPrice: '17.120.000',
    sellPrice: '17.420.000',
    buyChange: '30.000',
    sellChange: '30.000',
    isDown: true,
  ),
  _GoldPrice(
    name: 'Bảo Tín KK 610',
    spread: '750.000 đ',
    buyPrice: '9.400.000',
    sellPrice: '10.150.000',
    buyChange: '+200.000',
    sellChange: '+200.000',
  ),
  _GoldPrice(
    name: 'Bảo Tín KK 980',
    spread: '500.000 đ',
    buyPrice: '15.200.000',
    sellPrice: '15.700.000',
    buyChange: '+50.000',
    sellChange: '+150.000',
  ),
  _GoldPrice(
    name: 'Bảo Tín KK 99,9',
    spread: '500.000 đ',
    buyPrice: '15.600.000',
    sellPrice: '16.100.000',
    buyChange: '+300.000',
    sellChange: '+300.000',
  ),
  _GoldPrice(
    name: 'Bảo Tín Mạnh Hải',
    spread: '300.000 đ',
    buyPrice: '17.120.000',
    sellPrice: '17.420.000',
    buyChange: '30.000',
    sellChange: '30.000',
    isDown: true,
  ),
  _GoldPrice(
    name: 'Bảo Tín Minh Châu',
    spread: '300.000 đ',
    buyPrice: '17.120.000',
    sellPrice: '17.420.000',
    buyChange: '30.000',
    sellChange: '30.000',
    isDown: true,
  ),
  _GoldPrice(
    name: 'Bao Tin SJC',
    spread: '400.000 đ',
    buyPrice: '17.100.000',
    sellPrice: '17.500.000',
    buyChange: '50.000',
    sellChange: '50.000',
    isDown: true,
  ),
  _GoldPrice(
    name: 'BTLV Nhẫn tròn 9999',
    spread: '300.000 đ',
    buyPrice: '16.000.000',
    sellPrice: '16.300.000',
    buyChange: '+200.000',
    sellChange: '+200.000',
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();

  String get _selectedDateText =>
      DateFormat('dd/MM/yyyy').format(_selectedDate);

  Future<void> _pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final bool isAuthenticated = state is AuthAuthenticated;

        return Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness:
                  Theme.of(context).brightness ==
                      (Platform.isAndroid ? Brightness.dark : Brightness.light)
                  ? Brightness.light
                  : Brightness.dark,
              statusBarIconBrightness:
                  Theme.of(context).brightness ==
                      (Platform.isAndroid ? Brightness.dark : Brightness.light)
                  ? Brightness.light
                  : Brightness.dark,
            ),
            foregroundColor: colorText,
            iconTheme: const IconThemeData(color: colorText),
            title: Text(
              appName,
              style: TextStyle(
                color: colorText,
                fontWeight: .w700,
                fontSize: 17.sp,
              ),
            ),
          ),
          drawer: Drawer(
            child: SafeArea(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    title: const Text('Trang chủ'),
                    onTap: () {
                      Navigator.of(context).pop();
                      RootRoute().go(context);
                    },
                  ),
                  if (isAuthenticated)
                    ListTile(
                      title: const Text('Quản lý'),
                      onTap: () {
                        Navigator.of(context).pop();
                        ManagementRoute().go(context);
                      },
                    )
                  else
                    ListTile(
                      title: const Text('Đăng nhập'),
                      onTap: () {
                        Navigator.of(context).pop();
                        LoginRoute().go(context);
                      },
                    ),
                  if (isAuthenticated)
                    ListTile(
                      title: const Text('Đăng xuất'),
                      onTap: () {
                        context.read<AuthCubit>().logout();
                        Navigator.of(context).pop();
                        RootRoute().go(context);
                      },
                    ),
                ],
              ),
            ),
          ),
          body: Padding(
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
                            'Chọn ngày:',
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
                              onTap: _pickDate,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.sp,
                                  vertical: 8.5.sp,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.sp),
                                  border: Border.all(
                                    color: colorText,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.12,
                                      ),
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
                                        _selectedDateText,
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
                  _GoldPriceHeader(
                    dateText: DateFormat('HH:mm').format(DateTime.now()),
                  ),
                  SizedBox(height: 8.sp),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return _GoldPriceCard(price: _goldPrices[index]);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10.sp);
                      },
                      itemCount: _goldPrices.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GoldPrice {
  final String name;
  final String spread;
  final String buyPrice;
  final String sellPrice;
  final String buyChange;
  final String sellChange;
  final bool isDown;

  const _GoldPrice({
    required this.name,
    required this.spread,
    required this.buyPrice,
    required this.sellPrice,
    required this.buyChange,
    required this.sellChange,
    this.isDown = false,
  });
}

class _GoldPriceHeader extends StatelessWidget {
  final String dateText;

  const _GoldPriceHeader({required this.dateText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.sp),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text.rich(
              TextSpan(
                text: 'LOẠI VÀNG ',
                children: [
                  TextSpan(
                    text: '($_goldPriceTotal)',
                    style: const TextStyle(color: colorText),
                  ),
                  TextSpan(
                    text: ' ($dateText)',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'MUA VÀO',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'BÁN RA',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
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
  final _GoldPrice price;

  const _GoldPriceCard({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.sp),
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
                  price.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF1F2128),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5.sp),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 7.sp,
                    vertical: 2.sp,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF7EF),
                    borderRadius: BorderRadius.circular(6.sp),
                  ),
                  child: Text(
                    'Chênh: ${price.spread}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 10.5.sp,
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
              price: price.buyPrice,
              change: price.buyChange,
              isDown: price.isDown,
              priceColor: const Color(0xFF007A36),
            ),
          ),
          Expanded(
            flex: 3,
            child: _GoldPriceValue(
              price: price.sellPrice,
              change: price.sellChange,
              isDown: price.isDown,
              priceColor: const Color(0xFFD70018),
            ),
          ),
          SizedBox(width: 8.sp),
          Icon(Icons.star_border, color: Colors.grey.shade700, size: 20.sp),
        ],
      ),
    );
  }
}

class _GoldPriceValue extends StatelessWidget {
  final String price;
  final String change;
  final bool isDown;
  final Color priceColor;

  const _GoldPriceValue({
    required this.price,
    required this.change,
    required this.isDown,
    required this.priceColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color changeColor = isDown
        ? const Color(0xFFD70018)
        : const Color(0xFF007A36);
    final String prefix = isDown ? '↘ ' : '↗ ';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Text(
            price,
            style: TextStyle(
              color: priceColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SizedBox(height: 3.sp),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Text(
            '$prefix$change',
            style: TextStyle(
              color: changeColor,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
