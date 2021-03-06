import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodify/constants/key.dart';
import 'package:foodify/models/recipe_details.api.dart';
import 'package:foodify/models/recipe_details.dart';
import 'package:foodify/pages/Favourites/favourites.dart';
import 'package:foodify/views/widgets/instructions.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../views/widgets/shimmer_widget.dart';

class ProcedurePage extends StatefulWidget {
  final String id;
  const ProcedurePage({Key? key, required this.id}) : super(key: key);

  @override
  _ProcedurePageState createState() => _ProcedurePageState();
}

class _ProcedurePageState extends State<ProcedurePage> {
  RecipeDetails? details;
  PageController controller = PageController();
  List<Widget>? stepsCard;
  String sourceUrl = "https://spoonacular.com/recipes";
  bool isLiked = false;
  bool isLoading = true;
  late String url = details?.image ??
      'https://bitsofco.de/content/images/2018/12/broken-1.png';
  Future<void> getRecipeDetails(String id) async {
    details = await RecipeDetailsAPI.getRecipeDetails(id.toString());
    if (details?.spoonacularSourceUrl != null) {
      sourceUrl = details!.spoonacularSourceUrl!;
    } else if (details?.sourceUrl != null) {
      sourceUrl = details!.sourceUrl!;
    }
    checkIfLiked();
    setState(() {
      isLoading = false;
    });
  }

  void launchURL() async {
    if (!await launch(sourceUrl, forceWebView: true, enableJavaScript: true)) {
      Get.snackbar(
        "Couldn't launch URL",
        "Please check your Internet connection",
        duration: const Duration(seconds: 2),
        icon: const Icon(FontAwesomeIcons.triangleExclamation,
            color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void urlLaucher(String url) async {
    if (!await launch(url, forceWebView: true, enableJavaScript: true)) {
      Get.snackbar(
        "Couldn't launch URL",
        "Please check your Internet connection",
        duration: const Duration(seconds: 3),
        icon: const Icon(FontAwesomeIcons.triangleExclamation,
            color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getRecipeDetails(widget.id);
  }

  Widget cuisines(BuildContext context) {
    return details?.cuisines != null
        ? Row(
            children: <Widget>[
              for (int i = 0; i < details!.cuisines!.length; i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: Colors.amberAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          offset: const Offset(
                            0.0,
                            10.0,
                          ),
                          blurRadius: 10.0,
                          spreadRadius: -6.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        details?.cuisines![i],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 70),
        padding: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 10.0,
              spreadRadius: -20.0,
            ),
          ],
        ),
        child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(4),
              padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.amber)))),
          onPressed: () {
            if (details?.analyzedInstructions != null &&
                details?.analyzedInstructions![0]?.steps != null) {
              Get.to(
                () {
                  return Instructions(
                      instructions: details!.analyzedInstructions!,
                      title: details!.title!,
                      url: details?.image ??
                          'https://bitsofco.de/content/images/2018/12/broken-1.png');
                },
                transition: Transition.native,
              );
            } else {
              launchURL();
            }
          },
          child: const Text(
            'Get Procedure',
            style: TextStyle(
              fontSize: 25,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      body: ListView(
        // physics: const BouncingScrollPhysics(parent: BouncingScrollPhysics()),
        children: [
          Stack(
            fit: StackFit.passthrough,
            children: [
              !isLoading
                  ? Hero(
                      tag: 'location-img-${details?.id}',
                      child: CachedNetworkImage(
                        imageUrl: details?.image ??
                            'https://bitsofco.de/content/images/2018/12/broken-1.png',
                        height: 300,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 300.0,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.6),
                                blurRadius: 30.0,
                                spreadRadius: -5.0,
                                offset: const Offset(0.0, 40.0),
                              ),
                            ],
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) =>
                            ShimmerWidget.rectangular(
                                height: 300, br: BorderRadius.circular(0)),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    )
                  : buildShimmer(
                      context, 300, MediaQuery.of(context).size.width, 0.0),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          spreadRadius: 2,
                          blurRadius: 5)
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      return Get.back();
                    },
                    icon: const Icon(
                      FontAwesomeIcons.arrowLeft,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.6),
                            spreadRadius: 2,
                            blurRadius: 5)
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        Share.share('See what Recipe I made!\n\n$sourceUrl',
                            subject: 'Check out this Recipe from Foodify');
                      },
                      icon: const Icon(
                        FontAwesomeIcons.shareNodes,
                        color: Colors.black54,
                        size: 30,
                      ),
                    )),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 220,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: isLoading
                            ? ShimmerWidget.rectangular(
                                height: 200, br: BorderRadius.circular(20))
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                                details!.title.toString(),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 27,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    details!.extendedIngredients!.length
                                            .toString() +
                                        " Ingredients",
                                    style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  InkWell(
                                      onTap: () {
                                        if (!isLiked) {
                                          Favourites.addFavourites(
                                            details!.title!,
                                            details!.id.toString(),
                                            details?.image ??
                                                'https://bitsofco.de/content/images/2018/12/broken-1.png',
                                            ((details!.spoonacularScore ??
                                                        0.0) /
                                                    20.0)
                                                .toString(),
                                            details!.readyInMinutes.toString() +
                                                " mins",
                                          );
                                          Favourites.updateFavourites(
                                            details!.title!,
                                            details!.id.toString(),
                                            details?.image ??
                                                'https://bitsofco.de/content/images/2018/12/broken-1.png',
                                            ((details!.spoonacularScore ??
                                                        0.0) /
                                                    20.0)
                                                .toString(),
                                            details!.readyInMinutes.toString() +
                                                " mins",
                                          );
                                        } else {
                                          Favourites.removeFavourites(
                                              details!.id.toString());
                                        }

                                        setState(() {
                                          isLiked = !isLiked;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              !isLiked
                                                  ? const Icon(
                                                      CupertinoIcons.heart,
                                                      color: Colors.redAccent,
                                                      size: 25,
                                                    )
                                                  : const Icon(
                                                      CupertinoIcons
                                                          .heart_solid,
                                                      color: Colors.red,
                                                      size: 25,
                                                    ),
                                              const SizedBox(width: 6),
                                              Text(
                                                isLiked
                                                    ? "Favourited!"
                                                    : "Like This ?",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Colors.black54),
                                              ),
                                            ]),
                                      )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(FontAwesomeIcons.clock,
                                              size: 25,
                                              color: HexColor("#b88c09")),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              details!.readyInMinutes!.toInt() <
                                                      60
                                                  ? details!.readyInMinutes
                                                          .toString() +
                                                      " mins"
                                                  : (details!.readyInMinutes!
                                                                  .toDouble() /
                                                              60.0)
                                                          .toPrecision(1)
                                                          .toString() +
                                                      " Hrs",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(FontAwesomeIcons.star,
                                              size: 25,
                                              color: HexColor("#b88c09")),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              details!.spoonacularScore != null
                                                  ? (details!.spoonacularScore! /
                                                          5.0)
                                                      .toString()
                                                  : (Random().nextDouble() * 5)
                                                          .toStringAsPrecision(
                                                              2) +
                                                      ' Stars',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(FontAwesomeIcons.bowlFood,
                                              size: 25,
                                              color: HexColor("#b88c09")),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text('${details!.servings} serves',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                  ),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          isLoading
              ? Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10.0),
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ShimmerWidget.rectangular(
                      height: MediaQuery.of(context).size.height * 0.4,
                      br: BorderRadius.circular(20)),
                )
              : Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 17.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0;
                          i < details!.extendedIngredients!.length;
                          i++)
                        Column(
                          children: [
                            const SizedBox(
                              height: 2,
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.white,
                                  child: CachedNetworkImage(
                                    imageUrl: Image_URL +
                                        details!.extendedIngredients![i].image
                                            .toString(),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.contain),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        ShimmerWidget.rectangular(
                                            height: 180,
                                            br: BorderRadius.circular(35)),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Text(
                                    details!.extendedIngredients![i].original
                                        .toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                    ],
                  ),
                ),
          isLoading
              ? Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10.0),
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ShimmerWidget.rectangular(
                      height: 200, br: BorderRadius.circular(20)),
                )
              : Container(
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            details!.vegetarian ?? false
                                ? Image.asset(
                                    'assets/images/veg.png',
                                    height: 30,
                                    width: 30,
                                  )
                                : Image.asset(
                                    'assets/images/non-veg.png',
                                    height: 30,
                                    width: 30,
                                  ),
                            const SizedBox(width: 4),
                            Text(
                              details!.vegetarian ?? false
                                  ? ' Vegetarian'
                                  : 'Non Vegetarian',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ]),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              details!.veryHealthy ?? false
                                  ? const Icon(
                                      CupertinoIcons.checkmark_alt_circle_fill,
                                      color: Colors.green,
                                      size: 30,
                                    )
                                  : const Icon(
                                      CupertinoIcons.clear_thick_circled,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                              const SizedBox(width: 10),
                              Text(
                                details!.veryHealthy ?? false
                                    ? ' Very Healthy'
                                    : 'Not Healthy',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Row(children: [
                            details!.cheap ?? false
                                ? const Icon(
                                    CupertinoIcons.checkmark_alt_circle_fill,
                                    color: Colors.green,
                                    size: 30,
                                  )
                                : const Icon(
                                    CupertinoIcons.clear_thick_circled,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                            const SizedBox(width: 10),
                            Text(
                              details!.cheap ?? false
                                  ? ' Ketogenic'
                                  : 'Not Ketogenic',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ]),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children: [
                              details!.dairyFree ?? false
                                  ? const Icon(
                                      CupertinoIcons.checkmark_alt_circle_fill,
                                      color: Colors.green,
                                      size: 30,
                                    )
                                  : const Icon(
                                      CupertinoIcons.clear_thick_circled,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                              const SizedBox(width: 10),
                              Text(
                                details!.dairyFree ?? false
                                    ? ' Dairy Free'
                                    : 'Not Dairy Free',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              details!.glutenFree ?? false
                                  ? const Icon(
                                      CupertinoIcons.checkmark_alt_circle_fill,
                                      color: Colors.green,
                                      size: 30,
                                    )
                                  : const Icon(
                                      CupertinoIcons.clear_thick_circled,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                              const SizedBox(width: 10),
                              Text(
                                details!.glutenFree ?? false
                                    ? ' Gluten Free'
                                    : 'Not Gluten Free',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              details!.vegan ?? false
                                  ? const Icon(
                                      CupertinoIcons.checkmark_alt_circle_fill,
                                      color: Colors.green,
                                      size: 30,
                                    )
                                  : const Icon(
                                      CupertinoIcons.clear_thick_circled,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                              const SizedBox(width: 10),
                              Text(
                                details!.vegan ?? false
                                    ? ' Vegan'
                                    : 'Non Vegan',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
          if (details != null)
            if (details!.dishTypes!.isNotEmpty && details!.diets!.isNotEmpty)
              Container(
                margin: const EdgeInsets.all(20.0),
                child: const Divider(
                  thickness: 2,
                  color: Colors.black54,
                ),
              ),
          // instructions(context),
          if (details?.dishTypes != null)
            if (details!.dishTypes!.isNotEmpty)
              (Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: (Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            FontAwesomeIcons.utensils,
                            color: Colors.black54,
                            size: 30,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Dish Types',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        children: details!.dishTypes!.map((dishType) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.amberAccent,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7, // changes position of shadow
                                ),
                              ],
                            ),
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Center(
                                child: Text(
                                  dishType,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ])),
              )),
          if (details?.cuisines != null)
            if (details!.cuisines!.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: (Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (details!.cuisines!.isNotEmpty)
                        Row(
                          children: const [
                            Icon(
                              FontAwesomeIcons.bowlFood,
                              color: Colors.black54,
                              size: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Cusines',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 10),
                      cuisines(context)
                    ])),
              ),
          if (details?.diets != null)
            if (details!.diets!.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: (Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (details!.diets!.isNotEmpty)
                        Row(
                          children: const [
                            Icon(
                              FontAwesomeIcons.dumbbell,
                              color: Colors.black54,
                              size: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Diets',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 10),
                      diets(context)
                    ])),
              ),
          Container(
            margin: const EdgeInsets.all(20.0),
            child: const Divider(
              thickness: 2,
              color: Colors.black54,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SingleChildScrollView(
                  child: Html(
                    onLinkTap: (url, context, attributes, element) =>
                        urlLaucher(url!),
                    data: details?.summary ??
                        '<p style="text-align:center">Unfortunately Summary is not available</p>',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 55)
        ],
      ),
    );
  }

  Widget buildShimmer(
      BuildContext context, double height, double width, double radius) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: const Offset(
              0.0,
              10.0,
            ),
            blurRadius: 10.0,
            spreadRadius: -6.0,
          ),
        ],
      ),
      child: ShimmerWidget.rectangular(
        height: height,
        width: width,
        br: BorderRadius.circular(radius),
      ),
    );
  }

  diets(BuildContext context) {
    return Wrap(
      children: details!.diets!.map((diet) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.amberAccent,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7, // changes position of shadow
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.cover,
            child: Center(
              child: Text(
                diet,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void checkIfLiked() {
    setState(() {
      isLiked = Favourites.checkIfLiked(details!.id!.toString());
    });
  }

  double roundOffToXDecimal(double number, {int numberOfDecimal = 2}) {
    // To prevent number that ends with 5 not round up correctly in Dart (eg: 2.275 round off to 2.27 instead of 2.28)
    String numbersAfterDecimal = number.toString().split('.')[1];
    if (numbersAfterDecimal != '0') {
      int existingNumberOfDecimal = numbersAfterDecimal.length;
      number += 1 / (10 * pow(10, existingNumberOfDecimal));
    }

    return double.parse(number.toStringAsFixed(numberOfDecimal));
  }
}
