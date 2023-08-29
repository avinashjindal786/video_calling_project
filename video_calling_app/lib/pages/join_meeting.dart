import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:video_calling_app/model/meeting_details.dart';
import 'package:video_calling_app/pages/meeting_screen.dart';

class JioMeeting extends StatefulWidget {
  final MeetingDetails? meetingDetails;
  const JioMeeting({this.meetingDetails});

  @override
  State<JioMeeting> createState() => _JioMeetingState();
}

class _JioMeetingState extends State<JioMeeting> {
  static final GlobalKey<FormState> key = GlobalKey<FormState>();

  String userName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Join Meeting"),
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
          SizedBox(
            height: 20,
          ),
          FormHelper.inputFieldWidget(context, "userId", "Enter your name", (on) {
            if (on.isEmpty) {
              return "name cam't be null";
            }

            return null;
          }, (onSaved) {
            userName = onSaved;
          }, borderRadius: 10, borderFocusColor: Colors.redAccent, borderColor: Colors.redAccent, hintColor: Colors.grey),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FormHelper.submitButton("Join", () {
                if (validateAndSave()) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return MeetingPage(meetingId: widget.meetingDetails!.id, name: userName, meetingDetail: widget.meetingDetails!);
                  }));
                }
              }),
            ],
          )
        ]),
      ),
    );
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
