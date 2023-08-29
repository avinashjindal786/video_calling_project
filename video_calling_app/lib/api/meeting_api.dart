import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:video_calling_app/utils/user.dart';

String MEETING_API_URL = "http://192.168.1.24:8081//api/v1/meeting";

var client = http.Client();

Future<http.Response?> startMeeting() async {
  Map<String, String> requestHeader = {"Content-Type": 'application/json'};

  var loadUser = await loadUserId();

  var response = await client.post(Uri.parse('http://192.168.1.24:8081/api/v1/meeting/startMeeting'),
      headers: requestHeader,
      body: jsonEncode({
        "hostId": loadUser,
        "hostName": 'hostName$loadUser',
        // "startTime" : DateTime.now(),
      }));
  log(response.body);
  if (response.statusCode == 200) {
    return response;
  } else {
    return null;
  }
}

// Future<http.Response?> joinMeeting(String meetingId,) async {

//   Map<String, String> requestHeader = {"Content-Type": 'application/json'};
//   var response = await client.post(Uri.parse("$MEETING_API_URL/"), headers: headerWithToken, body: jsonEncode({"socketId": "", "meetingId": meetingId, "joined": true, "name": userName, "isAlive": true, "userId": userId}));
//   if (response.statusCode == 200) {
//     log(response.body);
//     return response;
//   } else {
//     return null;
//   }
// }

Future<http.Response?> joinMeeting(String meetingId) async {
  var queryUrl = "http://192.168.1.24:8081/api/v1/meeting/meeting/join?meetingId=$meetingId";
  var response = await http.get(
    Uri.parse(queryUrl),
  );
  if (response.statusCode == 200 && response.statusCode < 400) {
    return response;
  }
  throw UnsupportedError("Not valid MeetingId");
}
