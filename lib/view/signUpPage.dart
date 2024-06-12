import 'package:flutter/material.dart';
import 'package:mds_flutter_application/services/app_service.dart';
import 'package:mds_flutter_application/view/button.dart';
import 'package:mds_flutter_application/view/inputText.dart';
import 'package:mds_flutter_application/view/loginPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _pseudoController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();
  bool _isPasswordVisible = false;

  void _navigateToLogin() {
    // Navigate to login page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Replace LoginPage() with your login page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(18.0), // Padding around the title
          child: Text('Inscription'),
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).secondaryHeaderColor,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: _navigateToLogin,
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomTextInput(
                controller: _pseudoController,
                labelText: 'Pseudo',
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 16.0),
              CustomTextInput(
                controller: _firstNameController,
                labelText: 'Nom',
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 16.0),
              CustomTextInput(
                controller: _lastNameController,
                labelText: 'Prenom',
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 16.0),
              CustomTextInput(
                controller: _emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.0),
              CustomTextInput(
                controller: _passwordController,
                labelText: 'mot de passe',
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
              CustomTextInput(
                controller: _passwordConfirmationController,
                labelText: 'Confirmation mot de passe',
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
                text: 'S\'inscrire',
                onPressed: () async {
                  await ApiService().createProfile(
                    _pseudoController.text,
                    _passwordController.text,
                    _emailController.text,
                    _firstNameController.text,
                    _lastNameController.text,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
