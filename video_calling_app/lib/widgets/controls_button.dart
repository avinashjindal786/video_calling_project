import 'package:flutter/material.dart';

class CustomPanel extends StatelessWidget {
  CustomPanel({this.videoEnable, this.audioEnable, this.isConnectionFailed, this.onAndioToggle, this.onMeetingEnd, this.onReconnect, this.onVideoToggle});

  final bool? videoEnable;
  final bool? audioEnable;
  final bool? isConnectionFailed;
  final VoidCallback? onVideoToggle;
  final VoidCallback? onAndioToggle;
  final VoidCallback? onReconnect;
  final VoidCallback? onMeetingEnd;

  @override
  Widget build(BuildContext context) {
    List<Widget> buildControls() {
      if (!isConnectionFailed!) {
        return <Widget>[
          IconButton(
            onPressed: onVideoToggle,
            icon: Icon(videoEnable! ? Icons.videocam : Icons.videocam_off),
            color: Colors.white,
            iconSize: 32,
          ),
          IconButton(
            onPressed: onAndioToggle,
            icon: Icon(audioEnable! ? Icons.mic : Icons.mic_off),
            color: Colors.white,
            iconSize: 32,
          ),
          const SizedBox(
            width: 25,
          ),
          Container(
            width: 70,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red),
            child: IconButton(
              onPressed: onMeetingEnd!,
              icon: const Icon(Icons.call_end),
              color: Colors.white,
              iconSize: 32,
            ),
          )
        ];
      } else {
        return [const SizedBox()];
      }
    }

    return Container(
      color: Colors.blueGrey[900],
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buildControls(),
      ),
    );
  }
}
