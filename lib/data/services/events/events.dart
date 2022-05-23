import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../di/get_it.dart';
import '../navigation/navigation.dart';

abstract class EventService {
  Future<void> sendAllDates({required List<Event> events});
  void prompt(String url);
}

class EventServiceImpl extends EventService {
  static const scopes = [CalendarApi.calendarScope];

  Future<CalendarApi> getCalenderApi() async{
    ClientId credentials = ClientId('');
    if (Platform.isAndroid) {
      credentials = ClientId(dotenv.env['CLIENT_ID_ANDROID']!, "");
    } else if (Platform.isIOS) {
      credentials = ClientId(dotenv.env['CLIENT_ID_IOS']!, "");
    }
    debugPrint(credentials.identifier);
    AutoRefreshingAuthClient client = await clientViaUserConsent(credentials, scopes, prompt);
    return CalendarApi(client);
  }

  @override
  Future<void> sendAllDates({required List<Event> events}) async {
    getIt<NavigationServiceImpl>().pop();
    CalendarApi calendar = await getCalenderApi();
    String calendarId = "primary";
    for (int i = 0; i < events.length; i++) {
      try {
        Event value = await calendar.events.insert(events[i], calendarId);
        if (value.status == "confirmed") {
          debugPrint('Event added in google calendar');
        } else {
          debugPrint("Unable to add event in google calendar");
        }
      } catch (e) {
        debugPrint('Error creating event $e');
      }
    }
  }

  @override
  void prompt(String url) async {
    debugPrint("Please go to the following URL and grant access:");
    debugPrint("  => $url");
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

}
