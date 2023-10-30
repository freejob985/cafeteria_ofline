part of 'reservation_cubit.dart';

@immutable
sealed class ReservationState {}

final class ReservationInitial extends ReservationState {}

/*
  هذا هو تعليق متعدد الأسطر.
*/
class DataError extends ReservationState {
  final String error;

  DataError(this.error);
}

class DataLoaded extends ReservationState {
  final List<dynamic> data;

  DataLoaded(this.data);
}

class DataLoading extends ReservationState {}
