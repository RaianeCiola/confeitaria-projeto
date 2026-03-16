// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../service/confeitaria_service.dart';

class EditarCliente extends StatefulWidget {
  final int id;
  final String nome;
  final String telefone;
  final String email;

  EditarCliente({required this.id, required this.nome, required this.telefone, required this.email});

  @override
  _EditarClienteState createState() => _EditarClienteState();
}

class _EditarClienteState extends State<EditarCliente> {
  late TextEditingController _nomeController;
  late TextEditingController _telefoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.nome);
    _telefoneController = TextEditingController(text: widget.telefone);
    _emailController = TextEditingController(text: widget.email);
  }

void _atualizarCliente() async {
  try {
    await ApiService.atualizarCliente(
      widget.id,
      _nomeController.text,
      _telefoneController.text,
      _emailController.text,
    );
    Navigator.pop(context, true); 
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erro ao atualizar cliente: $e")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Editar Cliente")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: _telefoneController,
              decoration: InputDecoration(labelText: "Telefone"),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _atualizarCliente,
              child: Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
