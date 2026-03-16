// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'lista_cliente.dart';
import 'lista_pedido.dart';
import 'lista_produtos.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ADMINISTRATIVO CONFEITARIA"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, //vaicentralizar os botoes 
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.people),
              label: Text("Clientes", style: TextStyle(fontSize: 24),),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaClientes()),
                );
              },
            ),
            SizedBox(height: 24),
  

            ElevatedButton.icon(
              icon: Icon(Icons.shopping_cart),
              label: Text("Produtos", style: TextStyle(fontSize: 24),),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaProdutos()),
                );
              },
            ),

            SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(Icons.receipt),
              label: Text("Pedidos", style: TextStyle(fontSize: 24),),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaPedidos()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
