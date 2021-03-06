import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodify/models/recipe_find.api.dart';
import 'package:foodify/models/recipe_find.dart';
import 'package:foodify/views/widgets/recipe_find_card.dart';
import 'package:get/get.dart';

import '../../loading/loader.dart';

class RecipeFindClass extends StatefulWidget {
  final String ingredients;
  final String ranking;
  final bool pantry;
  const RecipeFindClass(
      {Key? key,
      required this.ingredients,
      required this.ranking,
      required this.pantry})
      : super(key: key);

  @override
  State<RecipeFindClass> createState() => _RecipeFindClassState();
}

class _RecipeFindClassState extends State<RecipeFindClass> {
  @override
  void initState() {
    super.initState();
    widget.ingredients.split(',').forEach((element) {
      ingredients.add(element);
    });
    getRecipes();
  }

  late List<RecipeFind> _recipes;
  bool _isLoading = true;
  late List<String> ingredients = [];
  Future<void> getRecipes() async {
    _recipes = await RecipeFindApi.getRecipe(
        widget.ingredients, widget.ranking, widget.pantry);
    setState(() {
      _isLoading = false;
    });
  }

  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? const Center(child: Loader())
            : Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Row(children: [
                    IconButton(
                      icon: const Icon(CupertinoIcons.back),
                      iconSize: 40,
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    const Text(
                      "Recipes",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                  Expanded(
                    child: FadingEdgeScrollView.fromScrollView(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0.0),
                        controller: _controller,
                        itemCount: _recipes.length,
                        itemBuilder: (context, index) {
                          return RecipeFindCard(
                            id: _recipes[index].id,
                            title: _recipes[index].title,
                            image: _recipes[index].image,
                            likes: _recipes[index].usedIngredientCount,
                            missedIngredientCount:
                                _recipes[index].missedIngredientCount,
                            usedIngredientCount: ingredients.length,
                            missedIngredients:
                                _recipes[index].missedIngredients,
                            usedIngredients: ingredients,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ));
  }
}
