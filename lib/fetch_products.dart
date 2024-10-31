import 'dart:convert';
import 'package:http/http.dart' as http;
import 'item.dart';

Future<List<Item>> fetchProducts() async {
  final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

  if (response.statusCode == 200) {
    List<dynamic> productsJson = jsonDecode(response.body);
    return productsJson.map((json) => Item.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}