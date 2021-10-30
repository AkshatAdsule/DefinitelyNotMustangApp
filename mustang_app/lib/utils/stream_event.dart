/// Represents a event that occurs during a message stream. This is used in [GetStatistics] to send loading indications
class StreamEvent {
  String message;
  MessageType type;

  StreamEvent({this.message, this.type});
}

enum MessageType { INFO, ERROR, WARNING }
