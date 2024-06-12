import 'package:flutter/material.dart';
import 'package:mds_flutter_application/view/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mds_flutter_application/services/app_service.dart';
import 'package:mds_flutter_application/view/button.dart';
import 'package:mds_flutter_application/view/inputText.dart';
import 'package:mds_flutter_application/view/signUpPage.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _checkForToken();
  }

  void _checkForToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text('Connexion'),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomTextInput(
              controller: _emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            CustomTextInput(
              controller: _passwordController,
              labelText: 'Password',
              obscureText: !_isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            SizedBox(height: 16.0),
            CustomButton(
      
              text: 'Se connecter',
              onPressed: () async {
                print('Login button pressed'); 
                await ApiService().login(context, _emailController.text, _passwordController.text);
              },
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: _navigateToSignUp,
              child: Text(
                "S'inscrire ?",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).secondaryHeaderColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
