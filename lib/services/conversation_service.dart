import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mds_flutter_application/model/personnage.dart';
import 'package:mds_flutter_application/model/univers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mds_flutter_application/model/conversation.dart';

class ConversationService {
  final String baseUrl = "https://mds.sprw.dev";

  Future<List<Conversation>> getConversations() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/conversations'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<Conversation> conversations = jsonResponse.map((conversation) => Conversation.fromJson(conversation)).toList();
      
      // Print the list of conversations
      conversations.forEach((conversation) {
        print(conversation.id);
        print(conversation.characterId);
      });

      return conversations;
    } else {
      throw Exception('Failed to load conversations');
    }
  }


  Future<void> createConversation(int characterId, int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/conversations'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'character_id': characterId,
        'user_id': userId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create conversation');
    }
  }

  Future<void> deleteConversation(int conversationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/conversations/$conversationId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      
      throw Exception('Failed to delete conversation');
      
    }
  }

  Future<List<String>> getMessages(int conversationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/conversations/$conversationId/messages'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return List<String>.from(jsonResponse.map((message) => message['content']));
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> sendMessage(int conversationId, String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/conversations/$conversationId/messages'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'content': message}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to send message');
    }
  }

  Future<void> regenerateMessage(int conversationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/conversations/$conversationId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to regenerate message');
    }
  }
  Future<Character> getCharacterById(int characterId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/characters/$characterId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Character.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load character');
    }
  }
  Future<List<Univers>> getUniverses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/universes'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<Univers> universes = jsonResponse.map((universe) => Univers.fromJson(universe)).toList();
      return universes;
    } else {
      throw Exception('Failed to load universes');
    }
  }
}
