import 'package:flutter/material.dart';
import 'package:mds_flutter_application/model/user.dart';
import 'package:mds_flutter_application/services/app_service.dart';
import 'package:mds_flutter_application/view/edit_user_page.dart';
import 'package:mds_flutter_application/view/listUsers.dart';


class UserPage extends StatefulWidget {
  const UserPage({super.key});
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String _searchText = '';
  late Future<List<User>> futureUsers;
  List<User> users = [];
  List<User> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    futureUsers = ApiService().GetUsers();
    futureUsers.then((userList) {
      setState(() {
        users = userList;
        filteredUsers = users;
      });
    });
  }

  void _onSearchChanged(String text) {
    setState(() {
      _searchText = text;
      filteredUsers = users
          .where((user) =>
              user.username.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    });
  }

  void _navigateToEditUser(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditUserPage(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text('Utilisateur'),
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).secondaryHeaderColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SearchBar(
              onChanged: _onSearchChanged, 
              hintText: 'Recherche...', 
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<User>>(
                future: futureUsers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Échec du chargement des utilisateurs'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucun utilisateur trouvé'));
                  } else {
                    
                    users = snapshot.data!;
                    filteredUsers = users.where((user) =>
                      user.username.toLowerCase().contains(_searchText.toLowerCase())).toList();
                    return ListeUser(
                      users: filteredUsers,
                      onTap: _navigateToEditUser,
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
