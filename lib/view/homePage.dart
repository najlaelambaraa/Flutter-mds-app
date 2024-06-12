import 'package:flutter/material.dart';
import 'package:mds_flutter_application/view/conversationPage.dart';
import 'package:mds_flutter_application/view/iconButton.dart';
import 'package:mds_flutter_application/view/loginPage.dart';
import 'package:mds_flutter_application/view/universPage.dart';
import 'package:mds_flutter_application/view/userPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void _navigateToUser() {
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserPage()), 
    );
  }
void _navigateToUnivers() {
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UniversPage()), 
    );
  }

 void _navigateToConversation() {
  
   Navigator.push(
      context,
    MaterialPageRoute(builder: (context) => ConversationPage()), 
    );
 }
   @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _logout(context);
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomIconButton(
                icon: Icons.person,
                onPressed: () {
                  _navigateToUser();
                },
              ),
              SizedBox(height: 10), 
             CustomIconButton(
                icon: Icons.language,
                onPressed: () {
                  _navigateToUnivers();
                },
              ),
              SizedBox(height: 10), 
             CustomIconButton(
                
                icon: Icons.message,
                onPressed: () {
                  _navigateToConversation();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _logout(BuildContext context) async {
   
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}