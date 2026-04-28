// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:kht_gold/core/types/extensions/int_extension.dart';

extension ScrollControllerExtension on ScrollController {
  void get scrollToStartScreen {
    if (!hasClients || offset == Offset.zero.dx) return;

    animateTo(
      Offset.zero.dx,
      duration: 500.milliseconds,
      curve: Curves.easeOut,
    );
  }
}
