import 'package:flutter/material.dart';
import 'package:app_autentication_seetings/database.dart';
import 'package:app_autentication_seetings/register_screen.dart';
import 'package:app_autentication_seetings/user_settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importe o pacote SharedPreferences

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoggedIn = false;
  String _loggedInUserName = '';

  @override
  void initState() {
    super.initState();
    _loadUsername(); // Carregar o nome de usuário ao inicializar a tela
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isLoggedIn
            ? Text('Olá, $_loggedInUserName')
            : const Text('Login'),
        actions: [
          if (_isLoggedIn)
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                await _navigateToUserSettings();
              },
            ),
          if (_isLoggedIn)
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

  Future<void> _navigateToUserSettings() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserSettingsScreen()),
    );

    if (result != null && result is UserSettings) {
      setState(() {
        _loggedInUserName = result.username;
        // Atualize aqui a cor de fundo da tela com result.selectedColor
      });
    }
  }

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
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
      return;
    }

    bool loginSuccess = await DatabaseHelper().login(username, password);
    if (loginSuccess) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username); // Salvar o nome de usuário utilizando SharedPreferences
      setState(() {
        _isLoggedIn = true;
        _loggedInUserName = username;
      });
      _usernameController.clear();
      _passwordController.clear();
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
              Navigator.pop(context);
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _logout();
              Navigator.pop(context);
            },
            child: Text('Sair'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username'); // Remover o nome de usuário ao fazer logout
    setState(() {
      _isLoggedIn = false;
      _loggedInUserName = '';
      _usernameController.clear();
      _passwordController.clear();
    });
  }

  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    if (username != null) {
      setState(() {
        _usernameController.text = username;
        _loggedInUserName = username;
      });
    }
  }
}