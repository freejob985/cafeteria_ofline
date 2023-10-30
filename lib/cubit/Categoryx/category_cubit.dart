import 'package:bloc/bloc.dart';
import 'package:cafeteria_ofline/helper/SessionManager.dart';
import 'package:cafeteria_ofline/helper/function.dart';
import 'package:cafeteria_ofline/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final Sqldb sqldb = Sqldb();

  String xx = "0";
  String? seatx;
  CategoryCubit() : super(CategoryInitial()) {
    fetchData();
    // serchex();
  }

  void serche(String keyword) async {
    List<dynamic> data_SQL = [];
    List<dynamic> data_SQL1 = [];
    try {
      final sql = "SELECT   *  FROM Category where Categoryx like ? ";
      final params = ["%$keyword%"];
      var Seat_ = await sqldb.executeQuery(sql, params);
      data_SQL = Seat_;
/*
  هذا هو تعليق متعدد الأسطر.
*/
      String? seat = await SessionManager.getSession('seat');
      seatx = seat!;
      emit(DataLoaded(data_SQL));

      /*
        هذا هو تعليق متعدد الأسطر.
      */
      final sql2 = "SELECT * FROM seat where seat  =  ? ";

      var Seat_1 = await sqldb.executeQuery(sql2, params); // Use sql2 here
      data_SQL1 = Seat_1;
      // print('Test point 2 ::=> $data_SQL1');
      List<dynamic> data_sum = [];

      var sum = await sqldb.executeQuery(
          "select sum(Total) from seat  where seat  =  ?", params);
      data_sum = sum;
      xx = sum[0]['sum(Total)'].toString();
    } catch (e) {
      emit(DataError("ERR:$e"));
      print(e);
    }
  }

  void section(String keyword) async {
    List<dynamic> data_SQL = [];
    List<dynamic> data_SQL1 = [];
    try {
      final sql = "SELECT   *  FROM Category where ty like ? ";
      final params = ["%$keyword%"];
      var Seat_ = await sqldb.executeQuery(sql, params);
      data_SQL = Seat_;
/*
  هذا هو تعليق متعدد الأسطر.
*/
      String? seat = await SessionManager.getSession('seat');
      seatx = seat!;
      emit(DataLoaded(data_SQL));

      /*
        هذا هو تعليق متعدد الأسطر.
      */
      final sql2 = "SELECT * FROM seat where seat  =  ? ";

      var Seat_1 = await sqldb.executeQuery(sql2, params); // Use sql2 here
      data_SQL1 = Seat_1;
      // print('Test point 2 ::=> $data_SQL1');
      List<dynamic> data_sum = [];

      var sum = await sqldb.executeQuery(
          "select sum(Total) from seat  where seat  =  ?", params);
      data_sum = sum;
      xx = sum[0]['sum(Total)'].toString();
    } catch (e) {
      emit(DataError("ERR:$e"));
      print(e);
    }
  }

  void fetchData() async {
    List<dynamic> data_SQL = [];
    List<dynamic> data_SQL1 = [];
    try {
      //   List<dynamic> data_SQL = [];
      emit(DataLoading());

      final sql = "SELECT * FROM Category";
      var Seat_1 = await sqldb.executeSqlAndGetList(sql);
      data_SQL = Seat_1;
      print('Test point 1 ::=> $data_SQL');
      // =============================================

      String? seat = await SessionManager.getSession('seat');
      seatx = seat!;
      print('Test point 1 ::=> $seat');

      final sql2 = "SELECT * FROM seat where seat  =  ? ";
      final params = [seat];
      var Seat_ = await sqldb.executeQuery(sql2, params); // Use sql2 here
      data_SQL1 = Seat_;
      // print('Test point 2 ::=> $data_SQL1');
      List<dynamic> data_sum = [];

      var sum = await sqldb.executeQuery(
          "select sum(Total) from seat  where seat  =  ?", params);
      data_sum = sum;
      xx = sum[0]['sum(Total)'].toString();
      // sum_all(xx);
      print("xx:::::$xx");
      //   emit(sumxm(xx));
      // emit(sumxm(xx));
      emit(DataLoaded(data_SQL, data_SQL1));

      //  emit(DataLoaded(data_SQL, data_SQL1));
    } catch (e) {
      emit(DataError("ERR:$e"));
      print(e);
    }
    emit(DataLoaded(data_SQL, data_SQL1));
  }

  Future<void> Categoryx_add(String Categoryx, String price, String ty) async {
    try {
      final insertedRowCategoryx = await sqldb.insertData(
        'Category',
        <String, Object?>{
          'Categoryx': '$Categoryx',
          'price': '$price',
          'ranking': '0',
          'ty': '$ty',
        },
      );
      emit(DataAdded());
    } catch (e) {
      emit(DataError("ERR ADD:$e"));
      print(e);
    }
  }

  Future<void> seat_add(String Product, seat, BuildContext context) async {
    try {
      final List<Map<String, dynamic>> queryResults = await sqldb.executeQuery(
          "select  *  from  seat  where  seat = '$seat'  and  Product= '$Product'");

      final List<Map<String, dynamic>> Total = await sqldb.executeQuery(
          "select  *  from  Category  where   Categoryx= '$Product'");
      //  print(Total[0]['Categoryx']);
      String Categoryx = Total[0]['Categoryx'];
      String price = Total[0]['price'];
/*
[
  جزئية الشيكات
]*/

      List<dynamic> sql_par = [
        seat,
      ];
      final List<Map<String, dynamic>> ch = await sqldb.executeQuery(
          "select  *  from  seat where    `seat`  =  ?", sql_par);

      // print(price); "
      if (queryResults.isEmpty) {
        if (ch.isEmpty) {
          Map<String, Object?> myMap = {
            'seat': seat, // تم استبدال 'Categoryx' بـ 'seat'
            'Product': Product, // تم استبدال 'price' بـ 'Product'
            'Quantity': '1', // تم استبدال 'ranking' بـ 'Quantity'
            'Total': price, // تم استبدال 'ty' بـ 'Total'
            'Check':
                generateRandomNumber(10), // تم استبدال 'ranking' بـ 'Check'
            'TIME': seat, // تم إضافة مفتاح 'TIME'
            'Section': '0', // تم إضافة مفتاح 'Section'
          };

          int? result = await sqldb.insertData(
            'seat',
            myMap,
          );
          if (result != null) {
            showNotification(context, title: "", message: "تمت الأضافة");
            print('تم إدخال $result صفوف جديدة.');
            fetchData();
          } else {
            // فشلت العملية
            print('فشل إدخال البيانات.');
            emit(DataError("ERR ADD"));
          }
        } else {
          String Check = ch[0]['Check'];

          Map<String, Object?> myMap = {
            'seat': seat, // تم استبدال 'Categoryx' بـ 'seat'
            'Product': Product, // تم استبدال 'price' بـ 'Product'
            'Quantity': '1', // تم استبدال 'ranking' بـ 'Quantity'
            'Total': price, // تم استبدال 'ty' بـ 'Total'
            'Check': Check, // تم استبدال 'ranking' بـ 'Check'
            'TIME': seat, // تم إضافة مفتاح 'TIME'
            'Section': '0', // تم إضافة مفتاح 'Section'
          };

          int? result = await sqldb.insertData(
            'seat',
            myMap,
          );
          if (result != null) {
            //   fetchData();
            showNotification(context, title: "", message: "تمت الأضافة");

            print('تم إدخال $result صفوف جديدة.');
          } else {
            // فشلت العملية
            print('فشل إدخال البيانات.');
            emit(DataError("ERR ADD"));
          }
        }
      } else {
        int quantity =
            int.parse(queryResults[0]['Quantity']); // تحويل النص إلى عدد صحيح
        quantity = quantity + 1; // إجراء العملية الحسابية
        String updatedQuantity = quantity.toString();
        int totel = quantity * int.parse(price);

/*
تنفيذ الاستعلام
*/
        List<dynamic> updateValues = [
          updatedQuantity,
          totel,
          seat,
          Product
        ]; // قيمة الاسم الجديد، العمر الجديد، ومعرف الصف الذي تريد تحديثه

        int? updato = await sqldb.executeUpdateQuery(
            "UPDATE seat  SET `Quantity`=?, `Total`=?  WHERE `seat`=? and `Product`=? ",
            updateValues);

        if (updato > 0) {
          //  fetchData();
          showNotification(context,
              title: "",
              message: "تمت اضافة $Product الي $seat العدد $updatedQuantity ");

          print('تم تحديث $updato صف.');
        } else {
          print('لم يتم تحديث أي صف.');
        }

        // تحويل العدد إلى نص مرة أخرى
      }

      print(queryResults.isEmpty);
    } catch (e) {
      emit(DataError("ERR ADD:$e"));
      print(e);
    }
  }

  void serchex() async {
    try {
      String? seat = await SessionManager.getSession('seat');
      List<dynamic> data_SQL1 = [];
      final sql = "SELECT   *  FROM seat where seat = ? ";
      final params = [seat];
      var Seat_ = await sqldb.executeQuery(sql, params);
      data_SQL1 = Seat_;
      print('Test point 1 ::=> $data_SQL1');
      emit(DataLoadedx(data_SQL1));
    } catch (e) {
      emit(DataError("ERR:$e"));
      print(e);
    }
  }
}
