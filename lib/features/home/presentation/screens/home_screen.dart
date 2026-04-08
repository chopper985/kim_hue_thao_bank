// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:kim_hue_thao_gold/core/app/languages/data/localization.dart';
import 'package:kim_hue_thao_gold/core/utils/app_bar/app_bar_title_back.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        title: Strings.home.i18n,
      ),
      body: Container(),
    );
  }
}
