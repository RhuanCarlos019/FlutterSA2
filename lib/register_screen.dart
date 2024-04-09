import 'package:flutter/material.dart';
import 'package:app_autentication_seetings/database.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _register(context);
              },
              child: const Text('Registrar-se'),
            ),
          ],
        ),
      ),
    );
  }

  void _register(BuildContext context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      // Exibe um snackbar informando que os campos estão em branco
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Campos em branco'),
          duration: Duration(seconds: 2),
        ),
      );
      return; // Retorna para evitar continuar com o processo de registro
    }

    await DatabaseHelper().register(username, password);

    // Exibe um snackbar para informar que o registro foi realizado com sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registro realizado'),
        duration: Duration(seconds: 2), // Define a duração do snackbar
      ),
    );

    // Fecha a tela de registro após o registro ter sido realizado com sucesso
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }
}
