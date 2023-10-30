import 'dart:io';

import 'package:cafeteria_ofline/cubit/Categoryx/category_cubit.dart';
import 'package:cafeteria_ofline/cubit/Seat/seat_cubit.dart';
import 'package:cafeteria_ofline/cubit/reservation/reservation_cubit.dart';
import 'package:cafeteria_ofline/pag/Categoryadd.dart';
import 'package:cafeteria_ofline/pag/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI~
    sqfliteFfiInit();
  }

  databaseFactory = databaseFactoryFfi;
  runApp(const homestart());
}

class homestart extends StatelessWidget {
  const homestart({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SeatCubit()),
        BlocProvider(create: (context) => CategoryCubit()),
        BlocProvider(create: (context) => ReservationCubit()),
      ],
      child: MaterialApp(
        routes: {
          'Home': (context) => Home(),
          'Categoryadd': (context) => Categoryadd(),
        },
        initialRoute: 'Home',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
