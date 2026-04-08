// Project imports:
import 'package:kim_hue_thao_gold/core/error/failure.dart';

class Result<T> {
  final T? value;
  final Failure? error;

  Result._({this.value, this.error});

  bool get isSuccess => value != null;
  bool get isFailure => error != null;

  static Result<T> success<T>(T value) => Result._(value: value);
  static Result<T> failure<T>(Failure error) => Result._(error: error);
}
