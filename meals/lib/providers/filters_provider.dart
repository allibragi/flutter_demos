import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetrian,
  vegan,
}

// const kDefaultFilters = {
//   Filter.glutenFree: false,
//   Filter.lactoseFree: false,
//   Filter.vegetrian: false,
//   Filter.vegan: false,
// };

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetrian: false,
          Filter.vegan: false,
        });

  void setFilters(Map<Filter, bool> chosenFIlters) {
    state = chosenFIlters;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive, //this override the value in ...state
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) => FiltersNotifier(),
);

final filteredMealsProvider = Provider((ref) {
  final melas = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  return melas.where((x) {
    if (activeFilters[Filter.glutenFree]! && !x.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !x.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetrian]! && !x.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !x.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
