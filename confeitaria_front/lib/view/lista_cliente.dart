// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../service/confeitaria_service.dart';
import 'adicionar_cliente.dart';
import 'editar_cliente.dart';
import 'pesquisar_cliente.dart';

class ListaClientes extends StatefulWidget {
  const ListaClientes({super.key});

  @override
  State<ListaClientes> createState() => _ListaClientesState();
}

class _ListaClientesState extends State<ListaClientes> {
  late Future<List<dynamic>> _clientes;

  @override
  void initState() {
    super.initState();
    _clientes = ApiService.getClientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Clientes"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PesquisarCliente()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _clientes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else {
            final clientes = snapshot.data!;
            return ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                final cliente = clientes[index];
                return ListTile(
                  title: Text(cliente['nome'], style: TextStyle(fontWeight: FontWeight.bold) ),
                  subtitle: Text(cliente['email']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final resultado = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditarCliente(
                                id: cliente['id'],
                                nome: cliente['nome'],
                                telefone: cliente['telefone'],
                                email: cliente['email'],
                              ),
                            ),
                          );
                          if (resultado == true) {
                            setState(() {
                              _clientes = ApiService.getClientes();
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          try {
                            await ApiService.deletarCliente(cliente['id']);
                            setState(() {
                              _clientes = ApiService
                                  .getClientes(); // Atualiza a lista
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text("Cliente excluído com sucesso!")),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Erro ao excluir cliente: $e")),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      //BOTÃO DE ADICIONAR - VAI ABRIR PARA OUTRA TELA
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdicionarCliente()),
          ).then((_) {
            setState(() {
              _clientes = ApiService.getClientes();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
