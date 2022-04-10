import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodify/models/recipeDetails.api.dart';
import 'package:foodify/models/recipeDetails.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String? sourceUrl;
  Widget? web;

  bool isLoading = true;

  Future<void> getRecipeDetails(String id) async {
    details = await RecipeDetailsAPI.getRecipeDetails(id.toString());

    setState(() {
      isLoading = false;
    });
  }

  void launchURL() async {
    if (!await launch(sourceUrl!, forceWebView: true, enableJavaScript: true)) {
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

  textContainer(String text) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Colors.white,
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
          // image: DecorationImage(
          //   colorFilter: ColorFilter.mode(
          //     Colors.black.withOpacity(0.5),
          //     BlendMode.multiply,
          //   ),
          //   image: NetworkImage(thumbnailUrl),
          //   fit: BoxFit.cover,
          // ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getRecipeDetails(widget.id);
    stepsCard = [
      textContainer('Pg 1'),
      textContainer('Pg 2'),
      textContainer('Pg 3'),
    ];

    sourceUrl =
        'https://fullbellysisters.blogspot.com/2012/06/pasta-with-garlic-scallions-cauliflower.html';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: launchURL,
        child: const Text(
          'Get Procedure',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      body: Container(
        child: ListView(
          children: [
            Stack(
              fit: StackFit.passthrough,
              children: [
                !isLoading
                    ? CachedNetworkImage(
                        imageUrl: details!.image!,
                        height: 300,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 300.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) =>
                            ShimmerWidget.rectangular(
                                height: 300, br: BorderRadius.circular(0)),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : buildShimmer(
                        context, 300, MediaQuery.of(context).size.width, 0.0),
                Column(
                  children: [
                    const SizedBox(
                      height: 220,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Container(
                          height: 200,
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
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 1),
                                      alignment: Alignment.topCenter,
                                      child: Text(details!.title.toString(),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 27,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis)),
                                    ),
                                    const SizedBox(height: 15),
                                    Text(details!.extendedIngredients!.length
                                            .toString() +
                                        " Ingredients"),
                                    const SizedBox(height: 15),
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
                                                details!.readyInMinutes!
                                                            .toInt() <
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
                                                ((details!.healthScore!) / 20.0)
                                                        .toString() +
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
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            isLoading
                ? Container()
                : Wrap(
                    children: [
                      for (var i = 0;
                          i < details!.extendedIngredients!.length;
                          i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amberAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    details!.extendedIngredients![i].original!
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    details!.extendedIngredients![i].measures!
                                            .us!.amount
                                            .toString() +
                                        ' ' +
                                        details!.extendedIngredients![i]
                                            .measures!.us!.unitShort
                                            .toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
            isLoading
                ? Container()
                : Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            details!.veryHealthy ?? false
                                ? const Icon(
                                    CupertinoIcons.checkmark_alt_circle_fill,
                                    color: Colors.green,
                                    size: 15,
                                  )
                                : const Icon(
                                    CupertinoIcons.clear_thick_circled,
                                    color: Colors.red,
                                    size: 15,
                                  ),
                            const SizedBox(width: 10),
                            Text(
                              details!.veryHealthy ?? false
                                  ? ' Very Healthy'
                                  : 'Not Healthy',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(children: [
                          details!.cheap ?? false
                              ? const Icon(
                                  CupertinoIcons.checkmark_alt_circle_fill,
                                  color: Colors.green,
                                  size: 15,
                                )
                              : const Icon(
                                  CupertinoIcons.clear_thick_circled,
                                  color: Colors.red,
                                  size: 15,
                                ),
                          const SizedBox(width: 10),
                          Text(
                            details!.cheap ?? false
                                ? ' Ketogenic'
                                : 'Not Ketogenic',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                        Row(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3, vertical: 7),
                            child: details!.vegetarian ?? false
                                ? Image.asset(
                                    'assets/images/veg.png',
                                    height: 20,
                                    width: 20,
                                  )
                                : Image.asset(
                                    'assets/images/non-veg.png',
                                    height: 20,
                                    width: 20,
                                  ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            details!.vegetarian ?? false
                                ? ' Ketogenic'
                                : 'Not Ketogenic',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Cooking Instructions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 250,
              padding: const EdgeInsets.all(8.0),
              child: PageView(
                /// [PageView.scrollDirection] defaults to [Axis.horizontal].
                /// Use [Axis.vertical] to scroll vertically.
                controller: controller,
                children: stepsCard!,
              ),
            ),
          ],
        ),
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
}
