
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';

import '../model/meeting_details.dart';
import '../widgets/controls_button.dart';
import '../widgets/remote_connection.dart';

class MeetingPage extends StatefulWidget {
  final String? meetingId;
  // final UserModel userModel;
  final String? name;
  final MeetingDetails meetingDetail;
  MeetingPage({required this.meetingDetail, this.meetingId, this.name});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final _localRender = RTCVideoRenderer();
  Map<String, dynamic> mediaConnection = {
    "audio": false,
    "video": true,
  };
  bool isConnectionEnable = false;
  WebRTCMeetingHelper? meetingHelper;

  void startMeeting() async {
    meetingHelper = WebRTCMeetingHelper(
      url: "http://192.168.1.24:8000",
      meetingId: widget.meetingId,
      userId: widget.meetingDetail.hostId,
      name: widget.name,
    );

    MediaStream _loadStream = await navigator.mediaDevices.getUserMedia(mediaConnection);
    _localRender.srcObject = _loadStream;
    meetingHelper!.stream = _loadStream;

    meetingHelper!.on("open", context, (ev, context) {
      setState(() {
        isConnectionEnable = false;
      });
    });

    meetingHelper!.on("connection", context, (ev, context) {
      setState(() {
        isConnectionEnable = false;
      });
    });

    meetingHelper!.on("user-left", context, (ev, context) {
      setState(() {
        isConnectionEnable = false;
      });
    });

    meetingHelper!.on("video-toggle", context, (ev, context) {
      setState(() {});
    });

    meetingHelper!.on("audio-toggle", context, (ev, context) {
      setState(() {});
    });

    meetingHelper!.on("meeting-ended", context, (ev, context) {
      setState(() {
        onMeeting();
      });
    });

    meetingHelper!.on("connection-setting-changed", context, (ev, context) {
      setState(() {
        isConnectionEnable = false;
      });
    });

    meetingHelper!.on("stream-changed", context, (ev, context) {
      setState(() {
        isConnectionEnable = false;
      });
    });

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRenderers();
    startMeeting();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    _localRender.dispose();
    if (meetingHelper != null) {
      meetingHelper!.destroy();
      meetingHelper = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildMeetingRoom(),
      bottomNavigationBar: CustomPanel(
        onAndioToggle: onAudioToggle,
        onVideoToggle: onVideoToggle,
        videoEnable: isVideoEnble(),
        audioEnable: isAudioEnble(),
        isConnectionFailed: isConnectionEnable,
        onReconnect: onReconnect,
        onMeetingEnd: onMeeting,
      ),
    );
  }

  initRenderers() async {
    await _localRender.initialize();
  }

  void onMeeting() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.endMeeting();
        meetingHelper = null;
        // gets.Get.back();
      });
    }
  }

  void onAudioToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleAudio();
      });
    }
  }

  _buildMeetingRoom() {
    return Stack(
      children: [
        meetingHelper != null && meetingHelper!.connections.isNotEmpty
            ? GridView.count(
                crossAxisCount: meetingHelper!.connections.length < 3 ? 1 : 2,
                children: List.generate(
                    meetingHelper!.connections.length,
                    (index) => Padding(
                          padding: EdgeInsets.all(1),
                          child: RemoteConnection(
                            rtcVideoRenderer: meetingHelper!.connections[index].renderer,
                            connection: meetingHelper!.connections[index],
                          ),
                        )))
            : const Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Calling......",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 24),
                  ),
                ),
              ),
        Positioned(
            bottom: 10,
            right: 0,
            child: SizedBox(
              width: 150,
              height: 200,
              child: RTCVideoView(_localRender),
            ))
      ],
    );
  }

  void onVideoToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleVideo();
      });
    }
  }

  bool isVideoEnble() {
    return meetingHelper != null ? meetingHelper!.videoEnabled! : false;
  }

  bool isAudioEnble() {
    // return meetingHelper != null ? meetingHelper!.audioEnabled! : false;
    return true;
  }

  void onReconnect() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.reconnect();
      });
    }
  }
}
