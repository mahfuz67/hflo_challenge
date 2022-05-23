import 'package:get_it/get_it.dart';
import 'package:hormoniousflo_challenge/presentation/bloc/bottom_navigation_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../data/common/api/request_helper.dart';
import '../data/services/api/api.dart';
import '../data/services/dialog/dialog.dart';
import '../data/services/events/events.dart';
import '../data/services/navigation/navigation.dart';
import '../data/services/prefs/shared_prefs.dart';
import '../data/services/snackbar/snackbar.dart';
import '../presentation/bloc/adding_events.dart';
import '../presentation/bloc/input_bloc.dart';

final GetIt getIt = GetIt.I;

Future init() async {
  final http.Client _client = http.Client();
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPref);
  getIt.registerLazySingleton<NavigationServiceImpl>(() => NavigationServiceImpl());
  getIt.registerLazySingleton<SharedServiceImpl>(() => SharedServiceImpl(prefs: getIt()));
  getIt.registerLazySingleton<DialogServicesImpl>(() => DialogServicesImpl(navigationServiceImpl: getIt()));
  getIt.registerLazySingleton<SnackBarServiceImpl>(() => SnackBarServiceImpl());
  getIt.registerLazySingleton<http.Client>(() => _client);
  getIt.registerSingleton<RequestHelpersImpl>(
      RequestHelpersImpl(getIt()));
  getIt.registerSingleton<EventServiceImpl>(
      EventServiceImpl(snackBarServicesImpl: getIt(), navigationServiceImpl: getIt()));
  getIt.registerLazySingleton<ApiServiceImpl>(() => ApiServiceImpl(
      snackBarServicesImpl: getIt(),
      requestHelpers: getIt(),
      sharedServiceImpl: getIt(),
      navigationServiceImpl: getIt()));

  getIt.registerFactory<InputCubit>(() => InputCubit(apiServiceImpl: getIt(), navigationServiceImpl: getIt(), snackBarServicesImpl: getIt(), prefs:getIt()));
  getIt.registerFactory<BottomNavCubit>(() => BottomNavCubit());
  getIt.registerFactory<AddingEventsCubit>(() => AddingEventsCubit());
}
