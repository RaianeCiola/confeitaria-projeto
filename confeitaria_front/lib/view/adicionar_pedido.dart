// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart'; 
import '../service/confeitaria_service.dart';

class AdicionarPedido extends StatefulWidget {
  @override
  _AdicionarPedidoState createState() => _AdicionarPedidoState();
}

class _AdicionarPedidoState extends State<AdicionarPedido> {
  final _formKey = GlobalKey<FormState>();

  final _idClienteController = TextEditingController();
  final _idProdutoController = TextEditingController();
  final _dataPedidoController = TextEditingController();
  final _statusController = TextEditingController();
  final _totalController = TextEditingController();

  // Função para buscar o preço do produto pelo ID
  Future<void> _buscarPrecoProduto() async {
    final idProduto = int.tryParse(_idProdutoController.text);
    if (idProduto != null) {
      try {
        final produto = await ApiService.getProdutoById(idProduto);
        setState(() {
          _totalController.text = produto['preco'].toString();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao buscar preço do produto: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Insira um ID de produto válido")),
      );
    }
  }

  void _adicionarPedido() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ApiService.adicionarPedido(
          int.parse(_idClienteController.text),
          int.parse(_idProdutoController.text),
          _dataPedidoController.text,
          _statusController.text,
          double.parse(_totalController.text),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Pedido adicionado com sucesso!")),
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
        title: Text("Adicionar Pedido"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _idClienteController,
                decoration: InputDecoration(labelText: "ID do Cliente"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o ID do cliente.";
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _idProdutoController,
                      decoration: InputDecoration(labelText: "ID do Produto"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor, insira o ID do produto.";
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _buscarPrecoProduto,
                  ),
                ],
              ),
              TextFormField(
                controller: _dataPedidoController,
                decoration: InputDecoration(labelText: "Data do Pedido (dd/MM/yyyy)"),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MaskedInputFormatter('##/##/####'),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira a data do pedido.";
                  }
                  if (!RegExp(r"^\d{2}/\d{2}/\d{4}$").hasMatch(value)) {
                    return "Insira a data no formato dd/MM/yyyy.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(labelText: "Status"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o status do pedido.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _totalController,
                decoration: InputDecoration(labelText: "Total"),
                keyboardType: TextInputType.number,
                readOnly: true, //  campo somente leitura
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _adicionarPedido,
                child: Text("Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
