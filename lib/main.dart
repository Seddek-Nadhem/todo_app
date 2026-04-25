import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_app/core/service_locator.dart' as di;
import 'package:todo_app/l10n/app_localizations.dart';
import 'package:todo_app/presentation/cubits/locale_cubit.dart';
import 'package:todo_app/presentation/cubits/todo_cubit.dart';
import 'package:todo_app/presentation/pages/home_page.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling native code (SQLite)
  WidgetsFlutterBinding.ensureInitialized();

  // Initilaize the Service Locator
  await di.init();

  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<TodoCubit>()..loadTodos()),
        BlocProvider(create: (context) => di.sl<LocaleCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Modern Clean Todo',
            locale: locale,

            // 4. Register the localization delegates
            localizationsDelegates: const [
              AppLocalizations.delegate, // Your generated delegate
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // 5. Tell the app which locales we support
            supportedLocales: const [
              Locale('en'), // English
              Locale('ar'), // Arabic
            ],
            
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blueAccent,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
