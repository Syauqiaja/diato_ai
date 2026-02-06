import 'package:diato_ai/core/routes/route.dart';
import 'package:diato_ai/core/theme/theme.dart';
import 'package:diato_ai/features/auth/core/cubit/auth_cubit.dart';
import 'package:diato_ai/features/courses/presentation/cubit/course_list_cubit.dart';
import 'package:diato_ai/features/home/presentation/cubit/article_cubit.dart';
import 'package:diato_ai/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ArticleCubit()..getArticles()),
        BlocProvider(create: (context) => CourseListCubit()),
      ],
      child: MaterialApp.router(title: 'Diato AI', theme: AppTheme.lightTheme, routerConfig: AppRoutes.router, debugShowCheckedModeBanner: false),
    );
  }
}
