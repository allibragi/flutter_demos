import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _seleceddCategory = categories[Categories.other]!;
  var _isPosting = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isPosting = true;
      });

      //Send to the remote DB
      final url = Uri.https(
          'corso-flutter-46dbd-default-rtdb.europe-west1.firebasedatabase.app',
          'shopping-list.json');

      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'name': _enteredName,
            'quantity': _enteredQuantity,
            'category': _seleceddCategory.title,
          }));

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pop(GroceryItem(
        id: responseData['name'],
        name: _enteredName,
        quantity: _enteredQuantity,
        category: _seleceddCategory,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Title in required. Must be between 2 and 50 characters.'; // validation fail
                  } else {
                    return null; // validation succeed
                  }
                },
                onSaved: (value) => _enteredName = value!,
              ), // instead of TextField()
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _enteredQuantity.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a positive number.'; // validation fail
                        } else {
                          return null; // validation succeed
                        }
                      },
                      onSaved: (value) => _enteredQuantity = int.parse(value!),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                        value: _seleceddCategory,
                        items: [
                          for (final c in categories.entries)
                            DropdownMenuItem(
                              value: c.value,
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    color: c.value.color,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(c.value.title),
                                ],
                              ),
                            )
                        ],
                        onChanged: (value) {
                          setState(() {
                            _seleceddCategory = value!;
                          });
                        }),
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isPosting
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                          },
                    child: const Text('Reset form'),
                  ),
                  ElevatedButton(
                    onPressed: _isPosting ? null : _saveItem,
                    child: _isPosting
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Add item'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
