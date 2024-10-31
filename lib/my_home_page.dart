import 'package:flutter/material.dart';
import 'item.dart';
import 'fetch_products.dart';
import 'database_helper.dart';
import 'edit_item_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  List<Item> _items = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print('MyHomePage initState');
    _loadProducts();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadProducts() async {
    try {
      List<Item> itemsFromDb = await _databaseHelper.getItems();
      if (itemsFromDb.isNotEmpty) {
        setState(() {
          _items = itemsFromDb;
        });
        print('Produtos carregados do banco de dados: $_items');
      } else {
        List<Item> products = await fetchProducts();
        for (var product in products) {
          await _databaseHelper.insertItem(product);
        }
        itemsFromDb = await _databaseHelper.getItems();
        setState(() {
          _items = itemsFromDb;
        });
        print('Produtos carregados da API e salvos no banco de dados: $_items');
      }
    } catch (e) {
      print('Erro ao carregar produtos: $e');
    }
  }

  Future<void> _resetDatabase() async {
    await _databaseHelper.deleteAllItems();
    await _loadProducts();
  }

  void _deleteItem(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Deleção'),
          content: const Text('Você tem certeza que deseja deletar este item?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Deletar'),
              onPressed: () async {
                await _databaseHelper.deleteItem(id);
                setState(() {
                  _items.removeWhere((item) => item.id == id);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editItem(Item item) async {
    final updatedItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditItemPage(item: item),
      ),
    );

    if (updatedItem != null) {
      await _databaseHelper.insertItem(updatedItem);
      setState(() {
        final index = _items.indexWhere((i) => i.id == updatedItem.id);
        if (index != -1) {
          _items[index] = updatedItem;
        }
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditItemPage(item: null),
      ),
    );

    if (newItem != null) {
      await _databaseHelper.insertItem(newItem);
      setState(() {
        _items.add(newItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Construindo MyHomePage');
    print('Itens atuais: $_items');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${_items[index].title}'),
                subtitle:
                    Text('Preço: R\$${_items[index].price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteItem(_items[index].id),
                ),
                onTap: () => _editItem(_items[index]),
              );
            },
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _resetDatabase,
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _addItem,
            child: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}