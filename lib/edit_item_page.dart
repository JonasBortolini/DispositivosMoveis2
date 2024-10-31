import 'package:flutter/material.dart';
import 'item.dart';

class EditItemPage extends StatefulWidget {
  final Item? item;

  const EditItemPage({super.key, this.item});

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _imageController;
  late TextEditingController _rateController;
  late TextEditingController _countController;
  bool _isSaveButtonEnabled = true;
  bool _isTitleValid = true;
  bool _isPriceValid = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item?.title ?? '');
    _priceController =
        TextEditingController(text: widget.item?.price.toString() ?? '');
    _descriptionController =
        TextEditingController(text: widget.item?.description ?? '');
    _categoryController =
        TextEditingController(text: widget.item?.category ?? '');
    _imageController = TextEditingController(text: widget.item?.image ?? '');
    _rateController =
        TextEditingController(text: widget.item?.rating.rate.toString() ?? '');
    _countController =
        TextEditingController(text: widget.item?.rating.count.toString() ?? '');

    _titleController.addListener(_validateFields);
    _priceController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _imageController.dispose();
    _rateController.dispose();
    _countController.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      _isTitleValid = _titleController.text.isNotEmpty;
      _isPriceValid = _priceController.text.isNotEmpty;
      _isSaveButtonEnabled = _isTitleValid && _isPriceValid;
    });
  }

  void _saveItem() {
    if (_isSaveButtonEnabled) {
      final newItem = Item(
        widget.item?.id ?? DateTime.now().millisecondsSinceEpoch,
        _titleController.text,
        double.tryParse(_priceController.text) ?? 0.0,
        _descriptionController.text,
        _categoryController.text,
        _imageController.text,
        Rating(
          double.tryParse(_rateController.text) ?? 0.0,
          int.tryParse(_countController.text) ?? 0,
        ),
      );
      Navigator.pop(context, newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Construindo EditItemPage');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_imageController.text.isNotEmpty)
                Image.network(_imageController.text),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  errorText: _isTitleValid ? null : 'Campo obrigatório',
                ),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Preço',
                  errorText: _isPriceValid ? null : 'Campo obrigatório',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                ),
              ),
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                ),
              ),
              TextField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'Imagem',
                ),
              ),
              TextField(
                controller: _rateController,
                decoration: const InputDecoration(
                  labelText: 'Avaliação',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _countController,
                decoration: const InputDecoration(
                  labelText: 'Contagem de Avaliações',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSaveButtonEnabled ? _saveItem : null,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}