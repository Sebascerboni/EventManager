import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:universal_io/io.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String _name = '';

  Future<void> _fetchRandomUser() async {
    final response = await http.get(Uri.parse('https://randomuser.me/api/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final user = data['results'][0];
      final name = '${user['name']['first']} ${user['name']['last']}';
      setState(() {
        _name = name;
      });
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> _printTicket() async {
    final file = File('ticket.txt');
    await file.writeAsString('El nombre obtenido al cosumir la API es:$_name');

    // Usar PowerShell para enviar el archivo a la impresora predeterminada
    await Process.run('powershell', ['-Command', 'Start-Process notepad.exe -ArgumentList \'/p "ticket.txt"\' -NoNewWindow']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random User Printer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_name.isNotEmpty) Text('Name: $_name'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchRandomUser,
              child: const Text('Fetch Random User'),
            ),
            const SizedBox(height: 20),
            if (_name.isNotEmpty)
              ElevatedButton(
                onPressed: _printTicket,
                child: const Text('Print Ticket'),
              ),
          ],
        ),
      ),
    );
  }
}
