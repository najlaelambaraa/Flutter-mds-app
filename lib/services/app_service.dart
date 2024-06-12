import 'dart:convert';

import 'dart:io';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mds_flutter_application/model/user.dart';
import 'package:mds_flutter_application/view/homePage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class ApiService {
  final String baseUrl = "https://mds.sprw.dev";


   Future<void> createProfile(String pseudo, String password ,String email, String firstName, String lastName) async {
   dynamic responseJson;
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    try {
      final response = await http.post(Uri.parse('$baseUrl/users'), body: json.encode({
        "username": pseudo,
        "password": password,
        "email": email,
        "firstname": firstName,
        "lastname": lastName,
       
      
      }), headers: headers);
      responseJson = response;
      print(response.statusCode);
      print("success");
      
    }
    catch (e) {
      print(e);
      print('error');
    }
  }
 
  Future<void> login(BuildContext context, String pseudo, String password) async {
  dynamic responseJson;
  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
  final String baseUrl = 'https://mds.sprw.dev'; 
 
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/auth'),
      body: json.encode({
        "username": pseudo,
        "password": password,
      }),
      headers: headers,
    );

    if (response.statusCode == 201 || response.statusCode == 202) {
      var token = json.decode(response.body)['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token); 
      responseJson = response;
      print('statut: ${response.statusCode}');
      print(context.mounted);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      print('Erreur de connexion: ${response.statusCode}');
      print('Reponse: ${response.body}');
       SnackBar(content: Text('Échec de la connexion'));
    }
  } catch (e) {
    print('Exception: $e');
     SnackBar(content: Text('Échec de la connexion'));
  }
}
 
Future<List<User>> GetUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
}
 Future<void> updateUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/users/${user.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'username': user.username,
        'email': user.email,
        'firstname': user.firstname,
        'lastname': user.lastname,
        
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }


String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');
  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!');
  }
  return utf8.decode(base64Url.decode(output));
}

Map<String, dynamic> _parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }

  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }

  return payloadMap;
}

int getUserIdFromToken(String token) {
  final payload = _parseJwt(token);
  return payload['userId']; // Adjust the key based on your token structure
}

}