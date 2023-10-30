part of 'seat_cubit.dart';

@immutable
sealed class SeatState {}

final class SeatInitial extends SeatState {}

class DataLoading extends SeatState {}

class DataLoaded extends SeatState {
  final List<dynamic> data;

  DataLoaded(this.data);
}

class DataAdded extends SeatState {}

class DataError extends SeatState {
  final String error;

  DataError(this.error);
}
