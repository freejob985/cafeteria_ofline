import 'package:cafeteria_ofline/Interfaces/Interfaces.dart';
import 'package:cafeteria_ofline/cubit/Categoryx/category_cubit.dart';
import 'package:cafeteria_ofline/helper/SessionManager.dart';
import 'package:cafeteria_ofline/helper/function.dart';
import 'package:cafeteria_ofline/pag/Tableset.dart';
import 'package:cafeteria_ofline/pag/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Requests extends StatefulWidget {
  final String data;

  const Requests({Key? key, required this.data}) : super(key: key);

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.index == 1) {
      final dataCubit = context.read<CategoryCubit>();
      dataCubit.fetchData();

    }
  }

  @override
  Widget build(BuildContext context) {
    final dataCubit = context.read<CategoryCubit>();
    String sets = widget.data;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 4, 57, 100),
          actions: <Widget>[buildIconButtonRow(context)],
          title: Text('حجز :  $sets'),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'الأصناف'),
              Tab(text: 'الحجز'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            GridViewPage(),
            Tableset(),
          ],
        ),
      ),
    );
  }
}

class GridViewPage extends StatefulWidget {
  @override
  State<GridViewPage> createState() => _GridViewPageState();
}

class _GridViewPageState extends State<GridViewPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is DataLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is DataLoaded) {
          return Column(
            children: [
              // حقل البحث
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (text) {
                          final dataCubit = context.read<CategoryCubit>();
                          dataCubit.serche(text);
                        },
                        decoration: InputDecoration(
                          hintText: 'ابحث عن الصنف',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        // تنفيذ البحث هنا
                      },
                    ),
                  ],
                ),
              ),
              // الأزرار
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final dataCubit = context.read<CategoryCubit>();
                      dataCubit.section("اساسي");
                    },
                    child: const Text('اساسي'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final dataCubit = context.read<CategoryCubit>();
                      dataCubit.section("اساسي");
                    },
                    child: const Text('سخن'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final dataCubit = context.read<CategoryCubit>();
                      dataCubit.section("اساسي");
                      // تنفيذ إجراء 3
                    },
                    child: const Text('عصائر'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final dataCubit = context.read<CategoryCubit>();
                      dataCubit.section("اساسي");
                      // تنفيذ إجراء 4
                    },
                    child: const Text('أخري'),
                  ),
                ],
              ),
              // GridView مع بيانات ثابتة
              Expanded(
                child: GridView.builder(
                  itemCount: state.data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.9,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final item = state.data[index];
                    return GestureDetector(
                      onTap: () async {
                        item['Categoryx'];
                        print(item);
                        String? seat = await SessionManager.getSession('seat');
                        final dataCubit = context.read<CategoryCubit>();

                        var e = dataCubit.seat_add(
                            item['Categoryx'], seat, context);
                      },
                      child: Card(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.category,
                              size: 20.0,
                              color: Color.fromARGB(255, 45, 3, 124),
                            ),
                            Text(
                              item['Categoryx'],
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // زر الرجوع
              ElevatedButton(
                onPressed: () {
                  ;
                  navigateToPage(context, Home());
                },
                child: Text('رجوع إلى الحجوزات'),
              ),
            ],
          );
        } else if (state is DataError) {
          return Center(
            child: Text('حدث خطأ: ${state.error}'),
          );
        }
        return Container(
            // child: ElevatedButton(
            //   onPressed: () {
            //     final dataCubit = context.read<CategoryCubit>();
            //     dataCubit.fetchData();
            //     //   navigateToPage(context, Home());
            //   },
            //   child: Text('رجوع إلى الحجوزات'),
            // ),
            );
      },
      listener: (BuildContext context, CategoryState state) {
        // final dataCubit = context.read<CategoryCubit>();
        // print("SSSSSSSSSSSSSSSSSSSSSSSSSS");
        // dataCubit.fetchData();
      },
    );
  }
}
