import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCakeScreen extends StatefulWidget {
  const AddCakeScreen({super.key});

  @override
  State<AddCakeScreen> createState() => _AddCakeScreenState();
}

class _AddCakeScreenState extends State<AddCakeScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();

  Future<void> addCake() async {
    final url = Uri.parse('http://172.20.10.2:5000/api/cakes');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': _nameController.text,
        'description': _descController.text,
        'price': int.parse(_priceController.text),
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Торт қосылды ✅')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Қате: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Жаңа торт қосу')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Атауы')),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Сипаттамасы')),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Бағасы'), keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: addCake, child: const Text('Қосу')),
          ],
        ),
      ),
    );
  }
}
