import 'package:flutter/material.dart';
import 'package:app_autentication_seetings/database.dart';
import 'package:app_autentication_seetings/register_screen.dart';
import 'package:app_autentication_seetings/user_settings_screen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoggedIn = false; // Estado para controlar se o usuário está logado
  String _loggedInUserName = ''; // Nome do usuário logado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isLoggedIn
            ? Text('Olá, $_loggedInUserName') // Altera o título da barra de aplicativos após o login bem-sucedido
            : const Text('Login'), // Título padrão antes do login
        actions: [
          if (_isLoggedIn) // Exibir o botão de configurações apenas se o usuário estiver logado
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserSettingsScreen()),
                );
              },
            ),
          if (_isLoggedIn) // Exibir o botão de sair apenas se o usuário estiver logado
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _logoutConfirmation(context);
              },
            ),
        ],
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
                _login();
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: const Text('Registrar-se'),
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      // Exibe um diálogo informando que os campos estão em branco
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro'),
          content: Text('Campos em branco'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return; // Retorna para evitar continuar com o processo de login
    }

    bool loginSuccess = await DatabaseHelper().login(username, password);
    if (loginSuccess) {
      setState(() {
        _isLoggedIn = true; // Atualiza o estado para indicar que o usuário está logado
        _loggedInUserName = username; // Atualiza o nome do usuário logado
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Successo'),
          content: Text('Login bem sucedido'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro'),
          content: Text('Usuário não encontrado'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _logoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmação'),
        content: Text('Você quer realmente sair?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o diálogo de confirmação
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _logout();
              Navigator.pop(context); // Fecha o diálogo de confirmação
            },
            child: Text('Sair'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    setState(() {
      _isLoggedIn = false; // Atualiza o estado para indicar que o usuário não está mais logado
      _loggedInUserName = ''; // Limpa o nome do usuário logado
    });
  }
}
