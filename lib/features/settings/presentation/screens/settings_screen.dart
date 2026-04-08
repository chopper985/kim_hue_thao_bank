// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:i18n_extension/i18n_extension.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:kht_gold/core/app/colors/app_colors.dart';
import 'package:kht_gold/core/app/languages/data/localization.dart';
import 'package:kht_gold/core/app/languages/service/model.dart';
import 'package:kht_gold/core/app/languages/service/service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Language _selectedLanguage = LanguageService().getLocale();

  void _changeLanguage(Language language) {
    LanguageService().saveLocale(language.langCode);
    context.locale = language.locale;

    setState(() {
      _selectedLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: colorText,
        iconTheme: const IconThemeData(color: colorText),
        title: Text(
          Strings.settings.i18n,
          style: TextStyle(
            color: colorText,
            fontWeight: .w700,
            fontSize: 17.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: SettingsContent(
          selectedLanguage: _selectedLanguage,
          onLanguageSelected: _changeLanguage,
        ),
      ),
    );
  }
}

class SettingsContent extends StatelessWidget {
  final Language selectedLanguage;
  final ValueChanged<Language> onLanguageSelected;

  const SettingsContent({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.language.i18n,
            style: TextStyle(
              color: const Color(0xFF5A0500),
              fontSize: 15.sp,
              fontWeight: .w700,
            ),
          ),
          SizedBox(height: 10.sp),
          _LanguageTile(
            language: Language.vietnam,
            isSelected: selectedLanguage == Language.vietnam,
            onTap: () => onLanguageSelected(Language.vietnam),
          ),
          SizedBox(height: 12.sp),
          _LanguageTile(
            language: Language.english,
            isSelected: selectedLanguage == Language.english,
            onTap: () => onLanguageSelected(Language.english),
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final Language language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureWrapper(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 10.sp),
        decoration: BoxDecoration(
          color: isSelected
              ? colorText.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10.sp),
          border: Border.all(color: isSelected ? colorText : mCU),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.text.i18n,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF5A0500)
                          : Colors.grey.shade800,
                      fontSize: 14.5.sp,
                      fontWeight: isSelected ? .w700 : .w500,
                    ),
                  ),
                  SizedBox(height: 2.sp),
                  Text(
                    language.base,
                    style: TextStyle(
                      color: fCD,
                      fontSize: 13.5.sp,
                      fontWeight: .w400,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: colorText, size: 18.sp),
          ],
        ),
      ),
    );
  }
}

class GestureWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const GestureWrapper({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: child,
    );
  }
}
