import 'package:flutter/material.dart';
import 'package:mds_flutter_application/model/univers.dart';
import 'package:mds_flutter_application/services/univers_service.dart';
import 'package:mds_flutter_application/view/button.dart';
import 'package:mds_flutter_application/view/customList.dart';
import 'package:mds_flutter_application/view/inputText.dart';
import 'package:mds_flutter_application/view/edit_univers_page.dart';

class UniversPage extends StatefulWidget {
  const UniversPage({super.key});

  @override
  _UniversPageState createState() => _UniversPageState();
}

class _UniversPageState extends State<UniversPage> {
  late Future<List<Univers>> futureUniverses;
  List<Univers> universes = [];
  List<Univers> filteredUniverses = [];
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _loadUniverses();
  }

  void _loadUniverses() {
    futureUniverses = UniversService().getUniverses();
    futureUniverses.then((universeList) {
      if (mounted) {
        setState(() {
          universes = universeList;
          filteredUniverses = universes;
        });
      }
    }).catchError((error) {
      print('Erreur lors du chargement des univers: $error');
    });
  }

  void _showAddDialog(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter un univers'),
          content: CustomTextInput(
            controller: _controller,
            labelText: 'Nom',
          ),
          actions: [
            CustomButton(
              text: 'Ajouter',
              onPressed: () async {
                final name = _controller.text;
                if (name.isNotEmpty) {
                  Navigator.of(context).pop(); 
                  try {
                    Univers newUnivers = await UniversService().createUniverse(name);
                    if (mounted) {
                      setState(() {
                        universes.add(newUnivers);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Univers créé avec succès'), backgroundColor: Theme.of(context).primaryColor,));
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Échec de la création de l\'univers'), backgroundColor: Colors.red,));
                    }
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToEditUniversPage(Univers univers) async {
    final updatedUnivers = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditUniversPage(univers: univers)),
    );

    if (updatedUnivers != null && mounted) {
      setState(() {
        final index = universes.indexWhere((u) => u.id == updatedUnivers.id);
        if (index != -1) {
          universes[index] = updatedUnivers;
        }
      });
    }
  }

  void _deleteUnivers(int index) async {
    final id = universes[index].id;
    try {
      await UniversService().deleteUniverse(id);
      setState(() {
        universes.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Univers supprimé'), backgroundColor: Theme.of(context).primaryColor));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Échec de la suppression de l\'univers'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text('Univers'),
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).secondaryHeaderColor,
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddDialog(context),
            icon: Icon(Icons.add, size: 30.0, color: Theme.of(context).secondaryHeaderColor),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Univers>>(
                future: futureUniverses,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Échec du chargement des univers'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucun univers trouvé'));
                  } else {
                    universes = snapshot.data!;
                    filteredUniverses = universes;
                    return CustomList(
                      items: filteredUniverses.map((u) => {
                        'id': u.id.toString(),
                        'name': u.name,
                        'imageUrl':'https://mds.sprw.dev/image_data/${u.imageUrl}' ?? '', 
                      }).toList(),
                      onTap: (name) {
                        final selectedUnivers = universes.firstWhere((univers) => univers.name == name);
                        _navigateToEditUniversPage(selectedUnivers);
                      },
                      imageUrlKey: 'imageUrl',
                      titleKey: 'name',
                      onDelete: _deleteUnivers,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
