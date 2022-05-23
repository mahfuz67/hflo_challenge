import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:http/http.dart' as http;

import '../../../di/get_it.dart';
import '../../../presentation/bloc/adding_events.dart';
import '../navigation/navigation.dart';
import '../snackbar/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EventService {
  Future<void> sendAllDates({required List<Event> events});
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;

  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

class EventServiceImpl extends EventService {
  SnackBarServiceImpl snackBarServicesImpl;
  NavigationServiceImpl navigationServiceImpl;
  EventServiceImpl({required this.navigationServiceImpl, required this.snackBarServicesImpl});
  static const scopes = ['openid', 'email', 'profile', CalendarApi.calendarScope];

  Future<CalendarApi?> getCalenderApi() async {
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: scopes);
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      GoogleAuthClient client = GoogleAuthClient(await googleSignInAccount.authHeaders);
      return CalendarApi(client);
    } else {
      return null;
    }
  }

  @override
  Future<void> sendAllDates({required List<Event> events}) async {
    getIt<NavigationServiceImpl>().pop();
    getIt<NavigationServiceImpl>().navigationKey.currentContext!.read<AddingEventsCubit>().setAdding(true);
    CalendarApi? calendar = await getCalenderApi();
    if (calendar != null) {
      String calendarId = "primary";
      List<bool> added = [];
      for (int i = 0; i < events.length; i++) {
        try {
          Event value = await calendar.events.insert(events[i], calendarId);
          if (value.status == "confirmed") {
            debugPrint('Event added in google calendar');
            added.add(true);
          } else {
            debugPrint("Unable to add event in google calendar");
          }
        } catch (e) {
          debugPrint('Error creating event $e');
        }
      }
      getIt<NavigationServiceImpl>().navigationKey.currentContext!.read<AddingEventsCubit>().setAdding(false);
      if (added.isNotEmpty) {
        snackBarServicesImpl.showAddedEvents(
            context: getIt<NavigationServiceImpl>().navigationKey.currentContext!, success: true);
      } else {
        snackBarServicesImpl.showAddedEvents(
            context: getIt<NavigationServiceImpl>().navigationKey.currentContext!, success: false);
      }
    }
  }

}
