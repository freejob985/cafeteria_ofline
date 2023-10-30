import 'package:bloc/bloc.dart';
import 'package:cafeteria_ofline/helper/SessionManager.dart';
import 'package:cafeteria_ofline/sqldb.dart';
import 'package:meta/meta.dart';

part 'reservation_state.dart';

class ReservationCubit extends Cubit<ReservationState> {
  final Sqldb sqldb = Sqldb();

  ReservationCubit() : super(ReservationInitial()) {
    serche();
  }

  void serche() async {
    try {
      String? seat = await SessionManager.getSession('seat');
      List<dynamic> data_SQL = [];
      final sql = "SELECT   *  FROM seat where seat = ? ";
      final params = [seat];
      var Seat_ = await sqldb.executeQuery(sql, params);
      data_SQL = Seat_;
      emit(DataLoaded(data_SQL));
    } catch (e) {
      emit(DataError("ERR:$e"));
      print(e);
    }
  }
}
