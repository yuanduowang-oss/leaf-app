import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'core/di/injection_container.dart';
import 'firebase_options.dart';
import 'features/home/presentation/pages/main_page.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/admin/presentation/pages/admin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Firebase（失败时降级处理，不崩溃）
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase 初始化失败: $e');
    debugPrint('应用将以离线模式运行');
  }

  // 设置状态栏透明（深色主题）
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // 初始化依赖注入
  await initDependencies();

  runApp(const LeafApp());
}

class LeafApp extends StatelessWidget {
  const LeafApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '叶子',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // Web: /admin 进入管理后台
        if (settings.name == '/admin') {
          return MaterialPageRoute(builder: (_) => const AdminPage());
        }
        // Default: 主页
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<HomeBloc>(
                create: (context) => getIt<HomeBloc>(),
              ),
            ],
            child: const MainPage(),
          ),
        );
      },
    );
  }
}
