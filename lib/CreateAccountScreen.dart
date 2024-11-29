import 'package:flutter/material.dart';
import 'dart:convert';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _createAccount() async {
    // Simula um atraso como se estivesse chamando uma API
    await Future.delayed(Duration(seconds: 2));

    // Aqui você pode validar os dados ou fazer o que precisar
    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      // Simulação de sucesso
      Navigator.pop(context);
    } else {
      // Lidar com erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
            'Failed to create account. Please fill in all fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.teal.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Criar Conta',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Preencha todos os campos para criar sua conta!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  SizedBox(height: 32.0),
                  _buildTextField(_nameController, 'Nome Completo', Icons.person),
                  SizedBox(height: 16.0),
                  _buildTextField(_emailController, 'Email', Icons.email),
                  SizedBox(height: 16.0),
                  _buildTextField(_passwordController, 'Senha', Icons.lock,
                      obscureText: true),
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: _createAccount,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                    ),
                    child: Text('Criar Conta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.0), // Margem lateral
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black), // Linha normal preta
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black), // Linha focada preta
          ),
          prefixIcon: Icon(icon, color: Colors.white),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

}
