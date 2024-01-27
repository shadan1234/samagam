class Message {
  final String? userId;
  final String? text;
  final String? imageUrl;
  final DateTime? timestamp;
  final String? category;
  final bool completed;

  Message({this.userId, this.text, this.imageUrl, this.timestamp, this.category, this.completed = false});
}
