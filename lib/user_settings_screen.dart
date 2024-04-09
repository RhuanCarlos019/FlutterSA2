import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importe o pacote SharedPreferences

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({Key? key}) : super(key: key);

  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  TextEditingController _usernameController = TextEditingController();
  Color selectedColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Carregar as configurações do usuário ao inicializar a tela
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações do Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nome de Usuário'),
            ),
            const SizedBox(height: 20),
            DropdownButton<Color>(
              value: selectedColor,
              onChanged: (Color? color) {
                if (color != null) {
                  setState(() {
                    selectedColor = color;
                  });
                }
              },
              items: <Color>[
                Colors.blue,
                Colors.green,
                Colors.red,
                Colors.purple,
                Colors.orange,
              ].map<DropdownMenuItem<Color>>((Color color) {
                return DropdownMenuItem<Color>(
                  value: color,
                  child: Container(
                    width: 100,
                    height: 20,
                    color: color,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveSettings();
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveSettings() async {
    String username = _usernameController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username); // Salvar o nome de usuário utilizando SharedPreferences
    Navigator.pop(context, UserSettings(username: username, selectedColor: selectedColor));
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    if (username != null) {
      setState(() {
        _usernameController.text = username;
      });
    }
  }
}

class UserSettings {
  final String username;
  final Color selectedColor;

  UserSettings({required this.username, required this.selectedColor});
}
