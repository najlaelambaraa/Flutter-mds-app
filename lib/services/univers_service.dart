import 'dart:convert';

import 'dart:io';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mds_flutter_application/model/personnage.dart';
import 'package:mds_flutter_application/model/univers.dart';
import 'package:mds_flutter_application/model/user.dart';
import 'package:mds_flutter_application/view/homePage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UniversService {
  final String baseUrl = "https://mds.sprw.dev";

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

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((universe) => Univers.fromJson(universe)).toList();
    } else {
      print('Failed to load universes API : ${response.statusCode}');
      throw Exception('Failed to load univers API : ${response.reasonPhrase}');
    }
  }

  Future<void> updateUniverse(int id, Univers univers) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/universes/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(univers.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update universe');
    }
  }

  Future<Univers> createUniverse(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/universes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 201) {
      return Univers.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create universe');
    }
  }

  Future<void> deleteUniverse(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/universes/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete univers');
    }
  }
  
   
 Future<List<Character>> getCharacters(int universeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/universes/$universeId/characters'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((character) => Character.fromJson(character)).toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }
  Future<void> deleteCharacter(int universeId, int characterId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/universes/$universeId/characters/$characterId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete character');
    }
  }
  Future<Character> createCharacter(int universeId, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/universes/$universeId/characters'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 201) {
      return Character.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create character');
    }
  }
Future<void> updateCharacter(int universeId, Character character) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/universes/$universeId/characters/${character.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(character.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update character');
    }
  }

  Future<void> regenerateCharacterDescription(int universeId, int characterId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/universes/$universeId/characters/$characterId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to regenerate character description');
    }
  }
  Future<Character> getCharacter(int universeId, int characterId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/universes/$universeId/characters/$characterId'),
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
  // Future<Character> getCharacterById(int universeId, int characterId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');

  //   if (token == null) {
  //     throw Exception('Token not found');
  //   }

  //   final response = await http.get(
  //     Uri.parse('$baseUrl/universes/$universeId/characters/$characterId'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     return Character.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load character');
  //   }
  // }
  
  }