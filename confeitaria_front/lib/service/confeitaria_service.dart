import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiService {
  static const String url =
      "http://127.0.0.1:8000"; //faz assim ai chama 'url' da api para montar o link

//imprimi os clinetes
  static Future<List<dynamic>> getClientes() async {
    final response = await http.get(Uri.parse('$url/api/clientes2_get/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao buscar clientes");
    }
  }

//ADICIONAR CLIENTE (POST)
  static Future<void> adicionarCliente(
      String nome, String telefone, String email) async {
    final response = await http.post(
      Uri.parse('$url/api/cliente1/post'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nome": nome,
        "telefone": telefone,
        "email": email,
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Erro ao adicionar cliente: ${response.body}");
    }
  }

  // buscar cliente por id (GET_BY_ID)
  static Future<Map<String, dynamic>> fetchClienteById(int id) async {
    final response =
        await http.get(Uri.parse('$url/api/cliente1/get_by_id$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar cliente com ID $id.');
    }
  }

//ATULAIZAR CLIENTE (PUT)
  static Future<void> atualizarCliente(
      int id, String nome, String telefone, String email) async {
    final response = await http.put(
      Uri.parse('$url/api/cliente3/Put/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nome": nome,
        "telefone": telefone,
        "email": email,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception("Erro ao atualizar cliente: ${response.body}");
    }
  }

  //  deletar um cliente (DELETE)
  static Future<void> deletarCliente(int id) async {
    final response =
        await http.delete(Uri.parse('$url/api/cliente3/Delete/$id'));
    if (response.statusCode != 204) {
      throw Exception("Erro ao deletar cliente");
    }
  }

/*------------------- PRODUTO ------------------------------*/

  // Adicionar produto POST
  static Future<void> adicionarProduto(String nome, String descricao,
      double preco, String categoria, String disponibilidade) async {
    final response = await http.post(
      Uri.parse('$url/api/produtos/post'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nome": nome,
        "descricao": descricao,
        "preco": preco,
        "categoria": categoria,
        "disponibilidade": disponibilidade,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception("Erro ao adicionar produto: ${response.body}");
    }
  }

  // Buscar lista de produtos GET
  static Future<List<dynamic>> getProdutos() async {
    final response = await http.get(Uri.parse('$url/api/produtos/get_all'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao buscar produtos");
    }
  }

  // Atualizar produto PUT
  static Future<void> atualizarProduto(int id, String nome, String descricao,
      double preco, String categoria, String disponibilidade) async {
    final response = await http.put(
      Uri.parse('$url/api/produtos/put/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nome": nome,
        "descricao": descricao,
        "preco": preco,
        "categoria": categoria,
        "disponibilidade": disponibilidade,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception("Erro ao atualizar produto: ${response.body}");
    }
  }

// Deletar produto
  static Future<void> deletarProduto(int id) async {
    final response =
        await http.delete(Uri.parse('$url/api/produtos/delete/$id'));
    if (response.statusCode != 204) {
      throw Exception("Erro ao deletarprodutoa");
    }
  }



//---------------------PEDIDOS------------------

//imprimi todo os pedidos (é o geta ll)
  static Future<List<dynamic>> getPedidos() async {
    final response = await http.get(Uri.parse('$url/api/pedidos/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao buscar pedidos");
    }
  }

//deletar
  static Future<void> deletarPedido(int id) async {
    final response = await http.delete(Uri.parse('$url/api/pedidos/$id'));
    if (response.statusCode != 204) {
      throw Exception("Erro ao deletar pedido");
    }
  }

//Adicionar pedidos POST
  static Future<void> adicionarPedido(int idCliente, int idProduto,
      String dataPedido, String status, double total) async {
    final response = await http.post(
      Uri.parse('$url/api/pedido/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id_cliente": idCliente,
        "id_produto": idProduto,
        "data_pedido": dataPedido,
        "status": status,
        "total": total,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception("Erro ao adicionar pedido: ${response.body}");
    }
  }

//buscar produto por id (para colocar o preço do produto no pedido automaticamnete)
  static Future<Map<String, dynamic>> getProdutoById(int id) async {
    final response =
        await http.get(Uri.parse('$url/api/produtos/get_by_id$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao buscar produto com ID $id");
    }
  }

//aAtualizar pedidso (PUT)
  static Future<void> atualizarPedido(int id, int idCliente, int idProduto,
      String dataPedido, String status, double total) async {
    final response = await http.put(
      Uri.parse('$url/api/pedidos/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id_cliente": idCliente,
        "id_produto": idProduto,
        "data_pedido": dataPedido,
        "status": status,
        "total": total,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception("Erro ao atualizar pedido: ${response.body}");
    }
  }
}
