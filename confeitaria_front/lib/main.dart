import 'package:confeitaria_front/view/lista_produtos.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'view/lista_cliente.dart';
import 'view/tela_inicial.dart'; 

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     //  title: 'ADMINISTRATIVO CONFEITARIA',
      initialRoute: 'tela_principal',
      routes: {
        'tela_principal': (context) => TelaInicial(),
        'clientes': (context) => ListaClientes(),
        'produtos': (context) => ListaProdutos(),
      },
    );
  }
}
