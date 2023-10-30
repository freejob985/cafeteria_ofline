part of 'category_cubit.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

class DataLoading extends CategoryState {}

class DataLoaded extends CategoryState {
  final List<dynamic> data;
  final List<dynamic>? data2;

  DataLoaded(this.data,
      [this.data2]); // استخدام القوس المعلوماتي واستخدام قوس مربعي لجعل المتغير الثاني اختياري
}

class sumxm extends CategoryState {
  String? sumxx;
  sumxm(this.sumxx);
}

class DataLoadedx extends CategoryState {
  final List<dynamic> datax;
  DataLoadedx(this.datax);
}

class DataAdded extends CategoryState {}

class DataError extends CategoryState {
  final String error;

  DataError(this.error);
}
