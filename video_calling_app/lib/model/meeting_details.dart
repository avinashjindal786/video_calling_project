class MeetingDetails {
  String? id;
  String? hostId;
  String? hostName;

  MeetingDetails({this.hostId, this.hostName, this.id});

  factory MeetingDetails.fromJson(dynamic json) {
    return MeetingDetails(
      id: json["id"],
      hostId: json["hostId"],
      hostName: json["hostName"],
    );
  }
}
