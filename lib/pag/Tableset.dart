// صفحة لعرض تفاصيل السعر

import 'package:cafeteria_ofline/cubit/Categoryx/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Tableset extends StatefulWidget {
  const Tableset({Key? key}) : super(key: key);

  @override
  State<Tableset> createState() => _TablesetState();
}

class _TablesetState extends State<Tableset> {
  final CategoryCubit categoryCubit = CategoryCubit();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dataCubit = context.read<CategoryCubit>();
    String sum = dataCubit.xx;
    dataCubit.fetchData();
    setState(() {});

    // categoryCubit.fetchData();

    return Scaffold(
      body: BlocConsumer<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is DataLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DataLoaded) {
            return ListView.builder(
              itemCount: state.data2?.length, // عدد العناصر التجريبية
              itemBuilder: (context, index) {
                final item = state.data2?[index];
                int id = item['id'];
                String seat = item['seat'];
                String product = item['Product'];
                String quantity = item['Quantity'];
                String total = item['Total'];
                String check = item['Check'];
                String time = item['TIME'];
                String section = item['Section'];
                return Card(
                  color: Color.fromARGB(255, 236, 236, 236),
                  child: ListTile(
                    leading: Icon(Icons.category), // الأيقونة
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$product  "),
                        SizedBox(height: 10.0),
                        Text('العدد :$quantity' + "    " + "السعر : $total"),
                      ],
                    ), // اسم الصنف
                    subtitle: Column(
                      children: [
                        SizedBox(height: 10.0), // مسافة بين السعر والأزرار
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // تنفيذ الإجراء الأول (كمبيوتر)
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.add), // الأيقونة
                                  // نص الزر
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green, // لون الخلفية
                                minimumSize:
                                    Size(screenWidth * 0.1, 0), // الحجم
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // تنفيذ الإجراء الأول (بريستا)
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.remove), // الأيقونة
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red, // لون الخلفية
                                minimumSize:
                                    Size(screenWidth * 0.1, 0), // الحجم
                              ),
                            )
                          ],
                        ),
                      ],
                    ), // السعر والعدد
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            print(item);
                            // تنفيذ الإجراء الأول (كمبيوتر)
                          },
                          child: Text('كمبيوتر'),
                        ),
                      ],
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
          return Container();
        },
        listener: (BuildContext context, CategoryState state) {},
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          // عرض تفاصيل السعر عند الضغط على الزر
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.green, // لون الخلفية
          minimumSize: Size(screenWidth, 40), // الحجم
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monetization_on), // الأيقونة تمثل السعر
            Text(sum), // نص يمثل تفاصيل السعر
          ],
        ),
      ),
    );
  }
}
