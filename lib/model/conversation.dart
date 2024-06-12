class Conversation {
  final int id;
  final int characterId;
  final List<String> messages;

  Conversation({required this.id, required this.messages,required this.characterId});

 factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] ?? '',
      characterId: json['character_id'] ?? '',
      messages: List<String>.from(json['messages'] ?? []),
    );
  }
}


  

