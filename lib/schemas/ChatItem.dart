import 'package:answer_me/schemas/ChatMessage.dart';

class ChatItem {
  String id;
  String name;
  String avatar;
  String subtitle;
  String system;
  List<String> plugins;
  double temperature;
  int dialogCount;
  List<ChatMessage> history;
  String lastMessage;
  String lastMessageTime;

  ChatItem({
    required this.id,
    required this.name,
    required this.avatar,
    this.subtitle = '',
    this.system = '',
    this.plugins = const [],
    this.dialogCount = 5,
    this.temperature = 0.9,
    this.history = const [],
    required this.lastMessage,
    required this.lastMessageTime,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar': avatar,
        'subtitle': subtitle,
        'system': system,
        'plugins': plugins,
        'temperature': temperature,
        'dialogCount': dialogCount,
        'history': history,
        'lastMessage': lastMessage,
        'lastMessageTime': lastMessageTime,
      };

  static ChatItem fromJson(Map<String, dynamic> json) {
    return ChatItem(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      subtitle: json['subtitle'],
      system: json['system'],
      plugins: List<String>.from(json['plugins']),
      temperature: json['temperature'],
      dialogCount: json['dialogCount'],
      history: List<ChatMessage>.from(
          json['history'].map((item) => ChatMessage.fromJson(item))),
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageItem'] ?? '',
    );
  }
}
