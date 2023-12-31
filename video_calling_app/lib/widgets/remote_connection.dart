import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';

class RemoteConnection extends StatefulWidget {
  final RTCVideoRenderer rtcVideoRenderer;
  final Connection connection;

  const RemoteConnection({required this.connection, required this.rtcVideoRenderer});

  @override
  State<RemoteConnection> createState() => _RemoteConnectionState();
}

class _RemoteConnectionState extends State<RemoteConnection> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          child: RTCVideoView(
            widget.rtcVideoRenderer,
            mirror: false,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
        ),
        Container(
          color: widget.connection.videoEnabled! ? Colors.transparent : Colors.blueGrey[900],
          child: Center(
              child: Text(
            widget.connection.videoEnabled! ? "" : widget.connection.name!,
            style: const TextStyle(color: Colors.white, fontSize: 30),
          )),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.all(5),
            color: Colors.black,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(
                widget.connection.name!,
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              Icon(Icons.mic, color: Colors.white, size: 15),
            ]),
          ),
        )
      ],
    );
  }
}
