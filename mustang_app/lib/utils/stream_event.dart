class StreamEvent {
  String message;
  MessageType type;

  StreamEvent({this.message, this.type});
}

enum MessageType { INFO, ERROR, WARNING }
