import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';

const kDefaultFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetrian: false,
  Filter.vegan: false,
};

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favMeals = [];
  Map<Filter, bool> _selectedFilters = kDefaultFilters;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleMealFavStatus(Meal meal) {
    final isExisting = _favMeals.contains(meal);
    if (isExisting) {
      setState(() {
        _favMeals.remove(meal);
      });
      _showInfoMessage('Meal removed from favorite.');
    } else {
      setState(() {
        _favMeals.add(meal);
      });
      _showInfoMessage('Meal added to favorite.');
    }
  }

  void _setScreen(String id) async {
    // close the drawer, so it's ok even if we remain here
    Navigator.of(context).pop();
    if (id == 'filters') {
      // navigate away
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );

      //print(result);
      setState(() {
        _selectedFilters = result ?? kDefaultFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final avaiableMeals = dummyMeals.where((x) {
      if (_selectedFilters[Filter.glutenFree]! && !x.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !x.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetrian]! && !x.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !x.isVegan) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavStatus,
      availableMeals: avaiableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favMeals,
        onToggleFavorite: _toggleMealFavStatus,
      );
      activePageTitle = 'Your favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
