abstract class SerializableData {
  double version;
  Map<String, dynamic> toJson();
  SerializableData serilize(Map<String, dynamic> json);
}
