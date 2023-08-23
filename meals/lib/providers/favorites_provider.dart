import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealsNotifier() : super([]);

  bool toggleMealFavoriteStatus(Meal m) {
    final isExisting = state.contains(m);

    // in riverpot we can not modify the value of the existing state
    // (ex: add a item to the list)
    // but only replace it (ex: state = variable)
    if (isExisting) {
      state = state.where((x) => x.id != m.id).toList();
      return false;
    } else {
      state = [...state, m]; //all the elemnt of the state + the nes
      return true;
    }
  }
}

final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>(
  (ref) => FavoriteMealsNotifier(),
);
