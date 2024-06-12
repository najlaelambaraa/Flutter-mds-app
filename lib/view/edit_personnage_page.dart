import 'package:flutter/material.dart';
import 'package:mds_flutter_application/model/personnage.dart';
import 'package:mds_flutter_application/services/univers_service.dart';
import 'package:mds_flutter_application/view/button.dart';
import 'package:mds_flutter_application/view/inputText.dart';

class EditCharacterPage extends StatefulWidget {
  final Character character;
  final int universeId;

  EditCharacterPage({required this.character, required this.universeId});

  @override
  _EditCharacterPageState createState() => _EditCharacterPageState();
}

class _EditCharacterPageState extends State<EditCharacterPage> {
  late String description;

  @override
  void initState() {
    super.initState();
    description = widget.character.description!;
  }

  void _showEditDialog(BuildContext context, String field) {
    TextEditingController _controller = TextEditingController(text: widget.character.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier $field'),
          content: CustomTextInput(
            controller: _controller,
            labelText: ' $field',
          ),
          actions: [
            CustomButton(
              text: 'Modifier',
              onPressed: () async {
                final updatedName = _controller.text;
                Character updatedCharacter = Character(
                  id: widget.character.id,
                  name: updatedName,
                  description: description,
                );

                try {
                  await UniversService().updateCharacter(widget.universeId, updatedCharacter);
                  setState(() {
                   widget.character.name = updatedName;
                  });
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(updatedCharacter);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('mise à jour du caractère'), backgroundColor: Theme.of(context).primaryColor,));
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Échec de la mise à jour du caractère'), backgroundColor: Colors.red,));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _regenerateDescription() async {
    try {
      await UniversService().regenerateCharacterDescription(widget.universeId, widget.character.id);
      Character updatedCharacter = await UniversService().getCharacter(widget.universeId, widget.character.id);
      setState(() {
        description = updatedCharacter.description!;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Description régénérée avec succès'),backgroundColor: Theme.of(context).primaryColor,));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Échec de la régénération de la description')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier Personnage'),
        backgroundColor: Color(0xFF4A919E),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Color(0xFF4A919E),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage('https://mds.sprw.dev/image_data/${widget.character.imageUrl}' ?? 'Aucune image disponible.'),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.character.name),
                        IconButton(
                          icon: Icon(Icons.person),
                          onPressed: () => (),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: 'Régénérer la description',
                    onPressed: _regenerateDescription,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
