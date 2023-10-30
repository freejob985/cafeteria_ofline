import 'package:cafeteria_ofline/Interfaces/Interfaces.dart';
import 'package:cafeteria_ofline/cubit/Categoryx/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Categoryadd extends StatefulWidget {
  const Categoryadd({Key? key}) : super(key: key);

  @override
  _CategoryaddState createState() => _CategoryaddState();
}

class _CategoryaddState extends State<Categoryadd> {
  String selectedCategory = 'عصائر'; // القسم المحدد
  TextEditingController nameController = TextEditingController();
  TextEditingController itemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dataCubit = context.read<CategoryCubit>();
    return Scaffold(
      appBar: AppBar_Interfaces(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Input(nameController, "الأسم"),
            SizedBox(height: 12),
            Input(itemController, "السعر"),
            SizedBox(height: 12),
            DropdownButton<String>(
              value: selectedCategory,
              items: <String>['عصائر', 'سخن', 'اساسي']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Colors.blue, // لون القائمة المنسدلة
                        fontSize: 18, // حجم النص
                        fontWeight: FontWeight.bold, // نوع الخط
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              style: TextStyle(
                color: Colors.blue, // لون النص الحالي
              ),
              underline: Container(
                height: 2,
                color: Color.fromARGB(
                    255, 240, 239, 239), // لون الخط السفلي للقائمة المنسدلة
              ),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.blue, // لون السهم
                size: 30, // حجم السهم
              ),
              isExpanded: true, // لجعل القائمة تمتد عبر العرض
              elevation: 8, // ارتفاع القائمة المنسدلة عند الفتح
              iconSize: 30,
              dropdownColor: Colors.grey[200], // تحديد لون خلفية قائمة الانسداد
// حجم السهم
              iconEnabledColor:
                  Colors.blue, // لون السهم عندما يكون المنسدل مفتوحًا
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String name = nameController.text;
                String item = itemController.text;
                dataCubit.Categoryx_add(name, item, selectedCategory);
                // يمكنك استخدام name و item و selectedCategory هنا في عملية الإضافة
                // اقرأ القيم وأنفذ الإضافة كما تحتاج.
              },
              child: Text('إضافة'),
            ),
            BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, state) {
                if (state is DataLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is DataAdded) {
                  return Center(
                    child: Text('تمت إضافة البيانات بنجاح.'),
                  );
                } else if (state is DataError) {
                  return Center(
                    child: Text('حدث خطأ: ${state.error}'),
                  );
                } else {
                  return SizedBox(); // عند البداية أو في أي حالة أخرى ترغب في عرضها
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
