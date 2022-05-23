import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hormoniousflo_challenge/presentation/bloc/adding_events.dart';
import 'package:hormoniousflo_challenge/presentation/bloc/bottom_navigation_bloc.dart';
import 'package:hormoniousflo_challenge/presentation/bloc/input_bloc.dart';
import 'package:hormoniousflo_challenge/presentation/router.dart';
import 'package:hormoniousflo_challenge/presentation/themes/colors.dart';
import 'data/services/navigation/navigation.dart';

import 'di/get_it.dart' as get_it;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  get_it.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: AppColors.transparent));
    runApp(const App());
  });
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late InputCubit _inputCubit;
  late BottomNavCubit _bottomNavCubit;
  late AddingEventsCubit _addingEventsCubit;

  @override
  void initState() {
    _inputCubit = get_it.getIt<InputCubit>();
    _bottomNavCubit = get_it.getIt<BottomNavCubit>();
    _addingEventsCubit = get_it.getIt<AddingEventsCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _bottomNavCubit.close();
    _inputCubit.close();
    _addingEventsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InputCubit>.value(value: _inputCubit),
        BlocProvider<BottomNavCubit>.value(value: _bottomNavCubit),
        BlocProvider<AddingEventsCubit>.value(value: _addingEventsCubit),
      ],
      child: MaterialApp(
        navigatorKey: get_it.getIt<NavigationServiceImpl>().navigationKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: AppColors.white
        ),
        title: 'HFLO Test',
        initialRoute: '/',
        onGenerateRoute: (settings)=> CustomRouter.generateRoutes(settings),
      ),
    );
  }
}




