part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomePriceBoardLoading extends HomeState {}

final class HomePriceBoardLoaded extends HomeState {
  final List<PriceBoardModel> priceBoard;

  const HomePriceBoardLoaded(this.priceBoard);

  @override
  List<Object> get props => [priceBoard];
}

final class HomePriceBoardFailure extends HomeState {}
