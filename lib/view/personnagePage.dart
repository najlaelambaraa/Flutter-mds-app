import 'package:flutter/material.dart';
import 'package:mds_flutter_application/model/personnage.dart';
import 'package:mds_flutter_application/services/univers_service.dart';
import 'package:mds_flutter_application/view/button.dart';
import 'package:mds_flutter_application/view/customList.dart';
import 'package:mds_flutter_application/view/edit_personnage_page.dart';
import 'package:mds_flutter_application/view/inputText.dart';

class CharactersPage extends StatefulWidget {
  final int universeId;

  CharactersPage({required this.universeId});

  @override
  _CharactersPageState createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  late Future<List<Character>> futureCharacters;
  List<Character> characters = [];

  @override
  void initState() {
    super.initState();
    futureCharacters = UniversService().getCharacters(widget.universeId);
    futureCharacters.then((characterList) {
      setState(() {
        characters = characterList;
      });
    });
  }

  void _addCharacter(String name) async {
    try {
      Character newCharacter = await UniversService().createCharacter(widget.universeId, name);
      setState(() {
        characters.add(newCharacter);
      });
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Personnage ajouté avec succès'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de l\'ajout du personnage'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteCharacter(int index) async {
    try {
      await UniversService().deleteCharacter(widget.universeId, characters[index].id);
      setState(() {
        characters.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Personnage supprimé avec succès'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de la suppression du personnage'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showAddDialog(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter un personnage'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextInput(
                controller: _nameController,
                labelText: 'Nom',
              ),
            ],
          ),
          actions: [
            CustomButton(
              text: 'Ajouter',
              onPressed: () {
                _addCharacter(_nameController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToEditCharacterPage(Character character) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCharacterPage(character: character, universeId: widget.universeId),
      ),
    ).then((updatedCharacter) {
      if (updatedCharacter != null) {
        setState(() {
          int index = characters.indexWhere((c) => c.id == updatedCharacter.id);
          if (index != -1) {
            characters[index] = updatedCharacter;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personnages'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Character>>(
        future: futureCharacters,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Échec du chargement des personnages'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun personnage trouvé'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomList(
                items: characters.map((character) => {
                  'name': character.name,
                  'imageUrl': 'https://mds.sprw.dev/image_data/${character.imageUrl}' ?? '',
                }).toList(),
                onTap: (name) {
                  final selectedCharacter = characters.firstWhere((character) => character.name == name);
                  _navigateToEditCharacterPage(selectedCharacter);
                },
                titleKey: 'name',
                imageUrlKey: 'imageUrl',
                onDelete: (index) {
                  _deleteCharacter(index);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
