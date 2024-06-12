import 'package:flutter/material.dart';
import 'package:mds_flutter_application/model/conversation.dart';
import 'package:mds_flutter_application/model/personnage.dart';
import 'package:mds_flutter_application/model/univers.dart';
import 'package:mds_flutter_application/services/conversation_service.dart';
import 'package:mds_flutter_application/services/univers_service.dart';
import 'package:mds_flutter_application/view/button.dart';
import 'package:mds_flutter_application/view/conversation_detail_page.dart';
import 'package:mds_flutter_application/view/customList.dart';
import 'package:mds_flutter_application/view/inputText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  late Future<List<Conversation>> futureConversations;
  List<Conversation> conversations = [];
  List<Conversation> filteredConversations = [];
  Map<int, String> characterNames = {};
  int? userId; 
  bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    _initializeUserIdAndFetchConversations();
  }

  Future<void> _initializeUserIdAndFetchConversations() async {
    await _initializeUserId();
    _fetchConversations();
  }
  String decodeBase64(String str) {
  String normalizedSource = base64Url.normalize(str);
  return utf8.decode(base64Url.decode(normalizedSource));
}

  Future<void> _initializeUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    

    final parts = token!.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);

    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }
    final userData = json.decode(payloadMap['data']);
      print('User ID: ${userData['id']}');  
      if(userData != null){
          setState(() {
            userId = userData['id']; 
         
            isLoading = false; 
          });
      }
       
  }

  void _fetchConversations() {
    futureConversations = ConversationService().getConversations();
    futureConversations.then((conversationList) {
      setState(() {
        conversations = conversationList;
        filteredConversations = conversations;
      });
    }).catchError((error) {
      print('Error loading conversations: $error');
      setState(() {
        conversations = [];
        filteredConversations = conversations;
      });
    });
  }

  void _navigateToConversationDetail(String id) {
     print(id);
    final selectedConversation = conversations.firstWhere((conversation) => conversation.id.toString() == id);
   
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationDetailPage(
          conversationTitle: selectedConversation.id.toString(),
          conversationId: selectedConversation.id,
        ),
      ),
    );
  }

  Future<void> _deleteConversation(int index) async {
    try {
      await ConversationService().deleteConversation(conversations[index].id);
      setState(() {
        conversations.removeAt(index);
        filteredConversations = conversations;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Conversation supprimée avec succès'), backgroundColor: Theme.of(context).primaryColor));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Échec de la suppression de la conversation')));
    }
  }

  Future<void> _createConversation(int characterId) async {
    if (userId == null) return; 
    try {
      await ConversationService().createConversation(characterId, userId!);
      _fetchConversations();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Conversation créée avec succès'), backgroundColor: Theme.of(context).primaryColor));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Échec de la création de la conversation')));
    }
  }

  void _showAddDialog(BuildContext context) async {
  List<Univers> universes = await ConversationService().getUniverses();
  TextEditingController _searchController = TextEditingController();
  List<Univers> filteredUniverses = universes;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Selectioner un Univers'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Univers...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredUniverses = universes
                              .where((universe) => universe.name.toLowerCase().contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ...filteredUniverses.map((universe) {
                    return ListTile(
                      title: Text(universe.name),
                      onTap: () async {
                        List<Character> characters = await UniversService().getCharacters(universe.id);
                        Navigator.of(context).pop();
                        _showCharacterSelectionDialog(context, characters);
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
            actions: [
              CustomButton(
                text: 'Annuler',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    },
  );
}

  void _showCharacterSelectionDialog(BuildContext context, List<Character> characters) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select a Character'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: characters.map((character) {
                return ListTile(
                  title: Text(character.name),
                  onTap: () {
                    _createConversation(character.id);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            CustomButton(
              text: 'Cancel',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text('Conversations'),
          ),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text('Conversations'),
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).secondaryHeaderColor,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Conversation>>(
          future: futureConversations,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Failed to get conversations: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Vous n\'avez pas de conversation'));
            } else {
              return CustomList(
                items: snapshot.data!.map((conversation) => {
                   
                  'title': conversation.id.toString(),
                  'id ': conversation.id.toString(),
                }).toList(),
                onTap: (id) {
                  _navigateToConversationDetail(id);
                },
                titleKey: 'title',
                showImage: false,
                onDelete: (index) {
                  _deleteConversation(index);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
