import 'package:flutter/material.dart';
import '../service/confeitaria_service.dart';

class PesquisarCliente extends StatefulWidget {
  const PesquisarCliente({super.key});

  @override
  State<PesquisarCliente> createState() => _PesquisarClienteState();
}

class _PesquisarClienteState extends State<PesquisarCliente> {
  final TextEditingController _idController = TextEditingController();
  Map<String, dynamic>? _cliente;
  String? _erro;

  void _pesquisarCliente() async {
    setState(() {
      _erro = null;
      _cliente = null;
    });

    try {
      final id = int.parse(_idController.text);
      final cliente = await ApiService.fetchClienteById(id);
      setState(() {
        _cliente = cliente;
      });
    } catch (e) {
      setState(() {
        _erro = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pesquisar Cliente"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: "Digite o ID do Cliente",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pesquisarCliente,
              child: Text("Pesquisar"),
            ),
            SizedBox(height: 16),
            if (_cliente != null)
              Card(
                child: ListTile(
                  title: Text("Nome: ${_cliente!['nome']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email: ${_cliente!['email']}"),
                      Text("Telefone: ${_cliente!['telefone']}"),
                    ],
                  ),
                ),
              ),
            if (_erro != null)
              Text(
                "Erro: $_erro",
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
