import 'package:flutter/material.dart';
import 'package:mds_flutter_application/model/user.dart';
import 'package:mds_flutter_application/services/app_service.dart';
import 'package:mds_flutter_application/view/button.dart';
import 'package:mds_flutter_application/view/inputText.dart';

class EditUserPage extends StatefulWidget {
  final User user;

  EditUserPage({required this.user});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  TextEditingController _pseudoController = TextEditingController();
  TextEditingController _nomController = TextEditingController();
  TextEditingController _prenomController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
   
    _pseudoController.text = widget.user.username;
    _nomController.text = "${widget.user.firstname}";
    _prenomController.text = "${widget.user.lastname}";
    _emailController.text = "${widget.user.email}";
 
  }
  

  @override
  void dispose() {
    _pseudoController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier les informations'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextInput(
                  controller: _pseudoController,
                  labelText: 'Pseudo',
                ),
                SizedBox(height: 15),
                CustomTextInput(
                  controller: _nomController,
                  labelText: 'Nom',
                ),
                SizedBox(height: 15),
                CustomTextInput(
                  controller: _prenomController,
                  labelText: 'Prénom',
                ),
                SizedBox(height: 15),
                CustomTextInput(
                  controller: _emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10),
       
              ],
            ),
          ),
          actions: [
            CustomButton(
              text: 'Modifier',
              onPressed: () {
                updateUser();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier Utilisateur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.person, size: 100),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'A propos de ${widget.user.firstname}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: _showEditDialog,
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 240, 240, 240),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text('Pseudo'),
                    subtitle: Text(_pseudoController.text),
                  ),
                  Divider(color: Color.fromARGB(255, 222, 221, 221)),
                  ListTile(
                    title: Text('Nom'),
                    subtitle: Text(_nomController.text),
                  ),
                  Divider(color: Color.fromARGB(255, 222, 221, 221)),
                  ListTile(
                    title: Text('Prénom'),
                    subtitle: Text(_prenomController.text),
                  ),
                  Divider(color: Color.fromARGB(255, 222, 221, 221)),
                  ListTile(
                    title: Text('Email'),
                    subtitle: Text(_emailController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void updateUser() async{
    print(_pseudoController.text);
    widget.user.username = _pseudoController.text;
     widget.user.firstname = _nomController.text;
      widget.user.lastname = _prenomController.text;
       widget.user.email = _emailController.text;
      await ApiService().updateUser(widget.user);
       setState(() {
      true;
    });

  }

}
