import 'package:flutter/material.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({Key? key}) : super(key: key);

  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  String selectedUsername = ''; // Variável para armazenar o nome de usuário selecionado
  Color selectedColor = Colors.blue; // Variável para armazenar a cor selecionada

  TextEditingController _usernameController = TextEditingController();

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
            // Campo de texto para o usuário escolher seu nome de usuário
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nome de Usuário'),
            ),
            const SizedBox(height: 20),
            // Dropdown para o usuário escolher a cor do tema
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
            // Botão de salvar
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

  void _saveSettings() {
    String username = _usernameController.text;
    // Aqui você pode salvar as configurações do usuário (como nome de usuário e cor do tema) como preferir
    // Por exemplo, você pode usar algum serviço de gerenciamento de estado, banco de dados, etc.
    // Após salvar, você pode exibir uma mensagem confirmando que as configurações foram salvas
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configurações Salvas'),
        content: Text('Nome de Usuário: $username\nCor do Tema: ${selectedColor.toString()}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
