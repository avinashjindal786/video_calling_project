import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:flutter/material.dart';
import 'package:video_calling_app/api/meeting_api.dart';
import 'package:video_calling_app/model/meeting_details.dart';
import 'package:video_calling_app/pages/join_meeting.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final GlobalKey<FormState> key = GlobalKey<FormState>();

  String meetingId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meeting"),
        backgroundColor: Colors.redAccent,
      ),
      body: Form(
        key: key,
        child: formUi(),
      ),
    );
  }

  formUi() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            "Welcome to Web Meeting",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          FormHelper.inputFieldWidget(context, "meetingId", "Enter your Meeting Id", (on) {
            if (on.isEmpty) {
              return "Meeting id cam't be null";
            }

            return null;
          }, (onSaved) {
            meetingId = onSaved;
          }, borderRadius: 10, borderFocusColor: Colors.redAccent, borderColor: Colors.redAccent, hintColor: Colors.grey),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FormHelper.submitButton("Join Meeting", () {
                if (validateAndSave()) {
                  validateMeetingId(meetingId);
                }
              }),
              FormHelper.submitButton("Start Meeting", () async {
                log("message");
                var response = await startMeeting();
                final body = jsonDecode(response!.body);

                final meetId = body['data'];
                log(meetId["id"]);
                validateMeetingId(meetId["id"]);
              }),
            ],
          )
        ]),
      ),
    );
  }

  void validateMeetingId(String meetingId) async {
    try {
      Response? response = await joinMeeting(meetingId);
      var data = jsonDecode(response!.body);
      final meetingDetails = MeetingDetails.fromJson(data["data"]);
      goToMeetingScreen(meetingDetails);
    } catch (e) {
      FormHelper.showSimpleAlertDialog(context, "Meeting App", "Invalid Meeting iD", "Ok", (onPressed) {
        Navigator.pop(context);
      });
    }
  }

  goToMeetingScreen(MeetingDetails details) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return JioMeeting(
        meetingDetails: details,
      );
    }));
  }

  bool validateAndSave() {
    final form = key.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }

    return false;
  }
}
