
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../service/confeitaria_service.dart';
import 'adicionar_produto';

class ListaProdutos extends StatefulWidget {
  const ListaProdutos({super.key});

  @override
  State<ListaProdutos> createState() => _ListaProdutosState();
}

class _ListaProdutosState extends State<ListaProdutos> {
  late Future<List<dynamic>> _produtos;

  @override
  void initState() {
    super.initState();
    _produtos = ApiService.getProdutos(); 
  }

  //função para exckuir produto
  Future<void> Excluir(BuildContext context, int produtoId) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmação"),
          content: Text("Você tem certeza que deseja excluir este produto?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); 
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true); 
              },
              child: Text("Excluir"),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      try {
        await ApiService.deletarProduto(produtoId);
        setState(() {
          _produtos = ApiService.getProdutos(); 
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Produto excluído com sucesso!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao excluir produto: $e")),
        );
      }
    }
  }

  // funçãp para editar produto (alerta dialog)
  Future<void> EditarProduto(BuildContext context, Map<String, dynamic> produto) async {
    final nomeController = TextEditingController(text: produto['nome']);
    final descricaoController = TextEditingController(text: produto['descricao']);
    final precoController = TextEditingController(text: produto['preco'].toString());
    final categoriaController = TextEditingController(text: produto['categoria']);
    String disponibilidade = produto['disponibilidade'];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar Produto"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeController,
                  decoration: InputDecoration(labelText: "Nome"),
                ),
                TextField(
                  controller: descricaoController,
                  decoration: InputDecoration(labelText: "Descrição"),
                ),
                TextField(
                  controller: precoController,
                  decoration: InputDecoration(labelText: "Preço"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: categoriaController,
                  decoration: InputDecoration(labelText: "Categoria"),
                ),
                     SizedBox(height: 18),
                Row( //criar bot~es  (em linha) para selecionar se esta disponivel pou indiponivel o produto
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          disponibilidade = "Disponivel";
                        });
                      },

                      child: Text("Disponivel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          disponibilidade = "Indisponivel";
                        });
                      },
                      child: Text("Indisponivel"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ApiService.atualizarProduto(
                    produto['id'],
                    nomeController.text,
                    descricaoController.text,
                    double.parse(precoController.text),
                    categoriaController.text,
                    disponibilidade,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Produto atualizado com sucesso!")),
                  );
                  setState(() {
                    _produtos = ApiService.getProdutos(); 
                  });
                  Navigator.pop(context); 
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erro ao atualizar produto: $e")),
                  );
                }
              },
              child: Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Produtos"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _produtos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else {
            final produtos = snapshot.data!;
            return ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return ListTile(
                  title: Text(
                    produto['nome'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Descrição: ${produto['descricao']}", style: TextStyle(fontSize: 16)),
                      Text("Preço: R\$${produto['preco']}", style: TextStyle(fontSize: 16)),
                      Text("Categoria: ${produto['categoria']}", style: TextStyle(fontSize: 16)),
                      Text(
                        "Disponibilidade: ${produto['disponibilidade']}",
                        style: TextStyle(
                          fontSize: 16,
                          //se disponivel verde se indiponivel vermlho para ver melhor 
                          color: produto['disponibilidade'] == "Indisponivel" ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          EditarProduto(context, produto);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          Excluir(context, produto['id']);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdicionarProduto()),
          ).then((_) {
            setState(() {
              _produtos = ApiService.getProdutos();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
