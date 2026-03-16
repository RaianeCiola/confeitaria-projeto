// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart'; 
import '../service/confeitaria_service.dart';

class AdicionarCliente extends StatefulWidget {
  @override
  _AdicionarClienteState createState() => _AdicionarClienteState();
}

class _AdicionarClienteState extends State<AdicionarCliente> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();

  void _adicionarCliente() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ApiService.adicionarCliente(
          _nomeController.text,
          _telefoneController.text,
          _emailController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cliente adicionado com sucesso!")),
        );
        Navigator.pop(context); // Volta para a tela anterior
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Cliente"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: "Nome"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o nome.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: "Telefone"),
                keyboardType: TextInputType.phone, // Define o tipo de teclado como telefone
                inputFormatters: [
                  MaskedInputFormatter('(##)#####-####') // Máscara para telefone
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o telefone.";
                  }
                  if (!RegExp(r'^\(\d{2}\)\d{5}-\d{4}$').hasMatch(value)) {
                    return "Insira o telefone no formato (XX)XXXXX-XXXX.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o email.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _adicionarCliente,
                child: Text("Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
