import 'package:flutter/material.dart';
import '../service/confeitaria_service.dart';
import 'adicionar_pedido.dart';

class ListaPedidos extends StatefulWidget {
  const ListaPedidos({super.key});

  @override
  State<ListaPedidos> createState() => _ListaPedidosState();
}

class _ListaPedidosState extends State<ListaPedidos> {
  late Future<List<dynamic>> _pedidos;

  @override
  void initState() {
    super.initState();
    _pedidos = ApiService.getPedidos(); // Busca todos os pedidos
  }

  // Função para abrir o modal de edição
  Future<void> _editarPedido(BuildContext context, Map<String, dynamic> pedido) async {
    final idClienteController = TextEditingController(text: pedido['id_cliente'].toString());
    final idProdutoController = TextEditingController(text: pedido['id_produto'].toString());
    final dataPedidoController = TextEditingController(text: pedido['data_pedido']);
    final statusController = TextEditingController(text: pedido['status']);
    final totalController = TextEditingController(text: pedido['total'].toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar Pedido nº ${pedido['id']}"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: idClienteController,
                  decoration: InputDecoration(labelText: "ID do Cliente"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: idProdutoController,
                  decoration: InputDecoration(labelText: "ID do Produto"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: dataPedidoController,
                  decoration: InputDecoration(labelText: "Data do Pedido (YYYY-MM-DD)"),
                ),
                TextField(
                  controller: statusController,
                  decoration: InputDecoration(labelText: "Status"),
                ),
                TextField(
                  controller: totalController,
                  decoration: InputDecoration(labelText: "Total"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: Text("Cancelar", style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ApiService.atualizarPedido(
                    pedido['id'],
                    int.parse(idClienteController.text),
                    int.parse(idProdutoController.text),
                    dataPedidoController.text,
                    statusController.text,
                    double.parse(totalController.text),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Pedido atualizado com sucesso!")),
                  );
                  setState(() {
                    _pedidos = ApiService.getPedidos(); 
                  });
                  Navigator.pop(context); 
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erro ao atualizar pedido: $e")),
                  );
                }
              },
              child: Text("Salvar", style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  // Função para confirmar exclusão
  Future<void> Exluir(BuildContext context, int pedidoId) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmação"),
          content: Text("Você tem certeza que deseja excluir este pedido?", style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); 
              },
              child: Text("Cancelar", style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true); 
              },
              child: Text("Excluir", style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      try {
        await ApiService.deletarPedido(pedidoId);
        setState(() {
          _pedidos = ApiService.getPedidos();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Pedido excluído com sucesso!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao excluir pedido: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Pedidos"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _pedidos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else {
            final pedidos = snapshot.data!;
            return ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final pedido = pedidos[index];
                return ListTile(
                  title: Text("Pedido ${pedido['id']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,) ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Cliente ID: ${pedido['id_cliente']}", style: TextStyle(fontSize: 16)),
                      Text("Produto ID: ${pedido['id_produto']}", style: TextStyle(fontSize: 16)),
                      Text("Data: ${pedido['data_pedido']}", style: TextStyle(fontSize: 16)),
                      Text("Status: ${pedido['status']}", style: TextStyle(fontSize: 16)),
                      Text("Total: R\$${pedido['total']}", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editarPedido(context, pedido);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          Exluir(context, pedido['id']);
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
            MaterialPageRoute(builder: (context) => AdicionarPedido()),
          ).then((_) {
            setState(() {
              _pedidos = ApiService.getPedidos();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
