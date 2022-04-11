import 'dart:convert';
import 'package:foodify/models/recipe.dart';
import 'package:http/http.dart' as http;
import 'package:foodify/constants/key.dart';
import 'package:foodify/constants/parameters.dart';

class RecipeApi {
  static Future<List<Recipe>> getRecipe() async {
    var uri = Uri.https(BASE_URL, '/recipes/random', {
      "number": "10",
      // "tags": cuisine + "," + getVeg(),
      "apiKey": API_KEY,
    });

    final response = await http
        .get(uri, headers: {"x-api-key": API_KEY, "useQueryString": "true"});

    Map data = jsonDecode(response.body);
    if (data['code'] == 402) {
      changeAPiKey();
      return getRecipe();
    }
    List _temp = [];

    for (var i in data['recipes']) {
      _temp.add(i);
    }
    // print(_temp);
    return Recipe.recipesFromSnapshot(_temp);
  }

  static Future<List<Recipe>> getTrending() async {
    var uri = Uri.https(BASE_URL, '/recipes/random', {
      "number": "10",
      // "sort": "asc",
      // "tags": cuisine + "," + getVeg(),
      "apiKey": API_KEY,
    });

    final response = await http
        .get(uri, headers: {"x-api-key": API_KEY, "useQueryString": "true"});

    Map data = jsonDecode(response.body);
    if (data['code'] == 402) {
      changeAPiKey();
      return getRecipe();
    }
    List _temp = [];

    for (var i in data['recipes']) {
      _temp.add(i);
    }
    // print(_temp);
    return Recipe.recipesFromSnapshot(_temp);
  }
}
