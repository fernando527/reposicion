import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reposicion Fernando Jose',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  String? imagen;
  String texto = '';

  Future<void> respuesta() async {
    final response = await http.get(Uri.parse('https://yesno.wtf/api'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        imagen = data['image'];
      });
    } else {
      throw Exception('La imagen no cargó');
    }
  }

  void validacion() {
    final text = _controller.text;
    if (text.isNotEmpty && text.endsWith('?')) {
      setState(() {
        texto = text;
      });
      respuesta();
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reposicion Fernando Jose',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (imagen != null)
              Image.network(imagen!)
            else
              const SizedBox(height: 20),
            const SizedBox(height: 20),
            Text(
              texto,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Haz una pregunta',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: validacion,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
