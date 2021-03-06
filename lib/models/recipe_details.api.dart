import 'dart:convert';
import 'package:foodify/models/recipe_details.dart';
import 'package:http/http.dart' as http;
import 'package:foodify/constants/key.dart';

class RecipeDetailsAPI {
  static Future<RecipeDetails> getRecipeDetails(String id) async {
    var uri = Uri.https(BASE_URL, '/recipes/' + id + '/information', {
      "apiKey": apiKey.first,
    });

    final response = await http.get(uri,
        headers: {"x-api-key": apiKey.first, "useQueryString": "true"});

    if (response.statusCode != 200) {
      changeAPiKey();
      return getRecipeDetails(id);
    }
    Map data = jsonDecode(response.body);
    // print(data);
    // log("THis is the APi" + data.toString());

    return RecipeDetails.recipesFromSnapshotDetails(data);
  }
}
