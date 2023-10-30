import 'package:cafeteria_ofline/Interfaces/Interfaces.dart';
import 'package:cafeteria_ofline/cubit/Seat/seat_cubit.dart';
import 'package:cafeteria_ofline/helper/SessionManager.dart';
import 'package:cafeteria_ofline/helper/function.dart';
import 'package:cafeteria_ofline/pag/Requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataCubit = context.read<SeatCubit>();
    return Scaffold(
      appBar: AppBar_Interfaces(context),
      body: BlocBuilder<SeatCubit, SeatState>(
        builder: (context, state) {
          if (state is DataLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DataLoaded) {
            return GridView.builder(
              itemCount: state.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                final item = state.data[index];
                return GestureDetector(
                  onTap: () {
                    SessionManager.setSession('seat', item['seat']);
                    //    navigateToPage(context, Requests());
                    // print(item);
                    // Navigator.of(context).pop();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Requests(data: item['seat']),
                      ),
                    );
                  },
                  child: GridTile(
                    child: Container(
                      // تخصيص عناصر الشبكة هنا
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.view_module, // استخدام أيقونة مثل نجمة
                            size: 48.0, // حجم الأيقونة
                            color:
                                Color.fromARGB(255, 45, 3, 124), // لون الأيقونة
                          ),
                          Text(
                            item['seat'], // نص المرافق للأيقونة
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is DataError) {
            return Center(
              child: Text('حدث خطأ: ${state.error}'),
            );
          }
          return Container(); // إضافة تعليمة return هنا لإرجاع الافتراضي
        },
      ),
    );
  }
}
