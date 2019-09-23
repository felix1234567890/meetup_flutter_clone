import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:meetup/src/models/meetup.dart';

class MeetupApiService {
  final String url = Platform.isIOS
      ? 'http://localhost:3001/api/v1'
      : 'http://10.0.2.2:3001/api/v1';
  static final MeetupApiService _singleton = MeetupApiService._internal();
  factory MeetupApiService() {
    return _singleton;
  }
  MeetupApiService._internal();

  Future<List<Meetup>> fetchMeetups() async {
    final response = await http.get('$url/meetups');
    final List parsedMeetups = json.decode(response.body);
    return parsedMeetups.map((val) => Meetup.fromJSON(val)).toList();
  }

  Future<Meetup> fetchMeetupById(String id) async {
    final res = await http.get('$url/meetups/$id');
    final parsedMeetup = json.decode(res.body);
    return Meetup.fromJSON(parsedMeetup);
  }
}
