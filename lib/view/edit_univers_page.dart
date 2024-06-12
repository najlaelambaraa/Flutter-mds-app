import 'package:flutter/material.dart';
import 'package:mds_flutter_application/model/univers.dart';
import 'package:mds_flutter_application/services/univers_service.dart';
import 'package:mds_flutter_application/view/button.dart';
import 'package:mds_flutter_application/view/inputText.dart';
import 'package:mds_flutter_application/view/personnagePage.dart';

class EditUniversPage extends StatefulWidget {
  final Univers univers;

  EditUniversPage({required this.univers});

  @override
  _EditUniversPageState createState() => _EditUniversPageState();
}

class _EditUniversPageState extends State<EditUniversPage> {
  void _showEditDialog(BuildContext context, String field) {
    TextEditingController _controller = TextEditingController(text: widget.univers.name);
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
                Univers updatedUnivers = Univers(
                  id: widget.univers.id,
                  name: updatedName,
                  description: widget.univers.description,
                  imageUrl: widget.univers.imageUrl,
                );

                try {
                  await UniversService().updateUniverse(widget.univers.id, updatedUnivers);
                  setState(() {
                    widget.univers.name = updatedName;
                  });
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(updatedUnivers);
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Echec de la mise à jour universe')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToCharactersPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharactersPage(universeId: widget.univers.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier Univers'),
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
                    backgroundImage: NetworkImage('https://mds.sprw.dev/image_data/${widget.univers.imageUrl}' ?? 'Aucune image disponible.'),
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
                        Text(widget.univers.name),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showEditDialog(context, 'Nom'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: 'Voir les personnages',
                    onPressed: _navigateToCharactersPage,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.univers.description ?? 'Aucune description disponible.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
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
