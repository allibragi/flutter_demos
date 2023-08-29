import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryitems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();

    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'corso-flutter-46dbd-default-rtdb.europe-west1.firebasedatabase.app',
        'shopping-list.json');

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data.';
        });
        return;
      }

      // firebase returns the string null when there's no data
      if (response.body == "null") {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        final cat = categories.entries
            .firstWhere(
                (element) => element.value.title == item.value["category"])
            .value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value["name"],
            quantity: item.value["quantity"],
            category: cat,
          ),
        );

        setState(() {
          _groceryitems = loadedItems;
          _isLoading = false;
        });
      }
    } catch (err) {
      setState(() {
        _error = 'Something went wrong.';
      });
      return;
    }
  }

  void _addItem() async {
    final newGrocery = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newGrocery == null) {
      return;
    }
    setState(() {
      _groceryitems.add(newGrocery);
    });
  }

  void _removeItem(GroceryItem item) async {
    final delIndex = _groceryitems.indexOf(item);
    setState(() {
      _groceryitems.remove(item);
    });

    final url = Uri.https(
        'corso-flutter-46dbd-default-rtdb.europe-west1.firebasedatabase.app',
        'shopping-list/${item.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      // Optiona: show an error
      setState(() {
        _groceryitems.insert(delIndex, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget displayedBody = const Center(child: Text('No items yet!'));

    if (_isLoading) {
      displayedBody = const Center(child: CircularProgressIndicator());
    }

    if (_groceryitems.isNotEmpty) {
      displayedBody = ListView.builder(
        itemCount: _groceryitems.length,
        itemBuilder: (context, index) => Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            _removeItem(_groceryitems[index]);
          },
          child: ListTile(
            title: Text(_groceryitems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryitems[index].category.color,
            ),
            trailing: Text(_groceryitems[index].quantity.toString()),
          ),
        ),
      );
    }

    if (_error != null) {
      displayedBody = Center(child: Text(_error!));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
      body: displayedBody,
    );
  }
}
