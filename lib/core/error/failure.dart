// Package imports:
import 'package:equatable/equatable.dart';
import 'package:toastification/toastification.dart';

// Project imports:
import 'package:kht_gold/core/app/languages/data/localization.dart';
import 'package:kht_gold/core/types/extensions/string_extension.dart';

abstract class Failure extends Equatable {
  final String? message;

  const Failure({this.message});
  @override
  List<Object> get props => [];

  void showToastFailure({String? defaultText}) {
    final String? messageText = (message?.isEmpty ?? false ? null : message);

    String? data = messageText ?? defaultText;

    if (data?.isEmpty ?? true) {
      data = Strings.serverFailure.i18n;
    }

    return data?.showToast(ToastificationType.error);
  }
}

// General failures
class GoldFailure extends Failure {
  const GoldFailure({super.message});
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NullValue extends Failure {}
