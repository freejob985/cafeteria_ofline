import 'package:bloc/bloc.dart';
import 'package:cafeteria_ofline/helper/SessionManager.dart';
import 'package:cafeteria_ofline/helper/function.dart';
import 'package:cafeteria_ofline/model/Seat.dart';
import 'package:cafeteria_ofline/pag/home.dart';
import 'package:cafeteria_ofline/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'seat_state.dart';

class SeatCubit extends Cubit<SeatState> {
  final Sqldb sqldb = Sqldb();
  SeatCubit() : super(SeatInitial()) {
    fetchData();
  }

  void serche(String seat) async {
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

  Future<void> greet() async {
    final sql = "SELECT * FROM Category";
    String deleteQuery = 'DELETE FROM seat WHERE 1;';
    int rowsDeleted = await sqldb.executeDeleteQuery(deleteQuery);
    fetchData();
  }

  void fetchData() async {
    try {
      List<dynamic> data_SQL = [];
      emit(DataLoading());
      final sql = "SELECT DISTINCT  seat  FROM seat";
      var Seat_ = await sqldb.executeSqlAndGetList(sql);
      data_SQL = Seat_;
      emit(DataLoaded(data_SQL));
      print(data_SQL);
    } catch (e) {
      // emit(DataError("ERR:$e"));
      // print("");
    }
  }

  Future<void> showReservationDialog(BuildContext context) async {
    TextEditingController reservationController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('نافذة حجز'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: reservationController,
                decoration: InputDecoration(
                  labelText: 'الاسم',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                emit(DataLoading());
                try {
                  String res =
                      reservationController.text; // استخراج النص من حقل النص
                  final Seatx = Seat(
                      seat: res,
                      Product: "Book",
                      Quantity: "0",
                      Total: "0",
                      Check: "0",
                      TIME: "0",
                      Section: "0");

                  final Seatmap = Seatx.toMap();

                  final insertedRowCategoryx = await sqldb.insertData(
                    'seat', // اسم الجدول
                    Seatmap,
                  );
                  showNotification(context, title: "", message: "تمت الأضافة");
                  fetchData();

                  emit(DataAdded());
                } catch (e) {
                  emit(DataError("ERR ADD:$e"));
                  print(e);
                }
                // لإغلاق المربع الحواري
              },
              child: Text('حفظ'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // لإغلاق المربع الحواري
              },
              child: Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }
}
