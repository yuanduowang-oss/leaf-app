// 依赖注入容器
import 'package:get_it/get_it.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // 注册 BLoC
  getIt.registerLazySingleton<HomeBloc>(() => HomeBloc());
}