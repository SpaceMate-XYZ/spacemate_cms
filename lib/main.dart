import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:spacemate/core/di/injection_container.dart' as di;
import 'package:spacemate/core/theme/app_theme.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/pages/menu_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: "assets/.env");

  // Initialize FFI for sqflite on desktop
  // if (kIsWindows || kIsLinux || kIsMacOS) {
  //   sqflite_ffi.sqfliteFfiInit();
  // }

  // Initialize dependency injection, passing the Strapi URL
  await di.init(baseUrl: dotenv.env['STRAPI_BASE_URL']!);

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<MenuBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Spacemate',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const MenuPage(
          placeId: 'default_place_id',
          initialCategory: 'home',
          appBarTitle: 'Spacemate Menu',
        ),
      ),
    );
  }
}

