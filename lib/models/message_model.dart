// Model sederhana untuk keperluan chat UI saja
class MessageModel {
  final String message;
  final String time;
  final bool isFromMe;
  final bool isProductQuestion;
  final Map<String, dynamic>? productData;

  MessageModel({
    required this.message,
    required this.time,
    required this.isFromMe,
    required this.isProductQuestion,
    this.productData,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['message'] ?? '',
      time: json['time'] ?? '',
      isFromMe: json['isFromUser'] ?? false,
      isProductQuestion: json['isProductQuestion'] ?? false,
      productData: json['product'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'time': time,
      'isFromUser': isFromMe,
      'isProductQuestion': isProductQuestion,
      'product': productData,
    };
  }

  // Konversi dari Map untuk chat bubble
  factory MessageModel.fromChatMap(Map<String, dynamic> map) {
    return MessageModel(
      message: map['text'] ?? '',
      time: map['time'] ?? '',
      isFromMe: map['fromMe'] ?? false,
      isProductQuestion: map['isProductQuestion'] ?? false,
      productData: map['product'],
    );
  }

  // Konversi ke Map untuk chat bubble
  Map<String, dynamic> toChatMap() {
    return {
      'text': message,
      'time': time,
      'fromMe': isFromMe,
      'isProductQuestion': isProductQuestion,
      'product': productData,
    };
  }
}
