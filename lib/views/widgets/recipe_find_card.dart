import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:foodify/pages/Procedure/procedure.dart';
import 'package:foodify/views/widgets/shimmer_widget.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class RecipeFindCard extends StatelessWidget {
  final int id;
  final String title;
  final String image;
  final int missedIngredientCount;
  final int usedIngredientCount;
  final List<dynamic> missedIngredients;
  final List<dynamic> usedIngredients;
  final int likes;

  const RecipeFindCard({
    required this.id,
    required this.title,
    required this.image,
    required this.missedIngredientCount,
    required this.usedIngredientCount,
    required this.missedIngredients,
    required this.usedIngredients,
    required this.likes,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < missedIngredients.length; i++) {
      if (missedIngredients[i]['name'].length > 17) {
        missedIngredients[i]['name'] =
            missedIngredients[i]['name'].substring(0, 16);
      }
    }
    return InkWell(
        onTap: () async {
          Get.to(
            () {
              return ProcedurePage(
                id: id.toString(),
              );
            },
            transition: Transition.cupertino,
          );

          // getRecipeDetails(id.toString());
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          width: MediaQuery.of(context).size.width,
          height: 180,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: image,
                imageBuilder: (context, imageProvider) => Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5),
                          BlendMode.multiply,
                        ),
                        image: imageProvider,
                        fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => ShimmerWidget.rectangular(
                    height: 180, br: BorderRadius.circular(15)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: missedIngredients.length > 2 ? 70 : 50,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (missedIngredients.isNotEmpty)
                                Flexible(
                                  child: (Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        CupertinoIcons.clear_circled_solid,
                                        color: Colors.red,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 9),
                                      Text(
                                        StringUtils.capitalize(
                                            missedIngredients[0]['name']
                                                .toString()),
                                        overflow: TextOverflow
                                            .ellipsis, // I used ellipsis, but it works with others (fade, clip, etc.)
                                        maxLines: 1,
                                        softWrap: true,
                                        style: TextStyle(
                                            overflow: TextOverflow.fade,
                                            fontSize: 12,
                                            color: HexColor("#ffffff")),
                                      ),
                                    ],
                                  )),
                                ),
                              if (missedIngredients.length > 1)
                                Flexible(
                                  child: (Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        CupertinoIcons.clear_circled_solid,
                                        color: Colors.red,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 9),
                                      Text(
                                        StringUtils.capitalize(
                                            missedIngredients[1]['name']),
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        softWrap: true,
                                        style: TextStyle(
                                            overflow: TextOverflow.fade,
                                            fontSize: 12,
                                            color: HexColor("#ffffff")),
                                      ),
                                    ],
                                  )),
                                ),
                              if (missedIngredients.length > 2)
                                (Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      CupertinoIcons.clear_circled_solid,
                                      color: Colors.red,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 9),
                                    Text(
                                      missedIngredients.length <= 2
                                          ? StringUtils.capitalize(
                                              missedIngredients[2]['name'])
                                          : StringUtils.capitalize(
                                                  missedIngredients[2]
                                                      ['name']) +
                                              ".." +
                                              (missedIngredientCount - 2)
                                                  .toString() +
                                              " more",
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      softWrap: true,
                                      style: TextStyle(
                                          overflow: TextOverflow.fade,
                                          fontSize: 12,
                                          color: HexColor("#ffffff")),
                                    ),
                                  ],
                                )),
                            ],
                          ),
                        )),
                    SizedBox(
                      child: Container(
                          height: getDim(usedIngredientCount),
                          // width: MediaQuery.of(context).size.width * 0.4,
                          padding: const EdgeInsets.all(2),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              for (int i = 0; i < usedIngredientCount; i++)
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: (Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        CupertinoIcons.check_mark_circled_solid,
                                        color: Colors.green,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 9),
                                      Text(
                                        usedIngredients[i],
                                        softWrap: true,
                                        style: TextStyle(
                                            overflow: TextOverflow.fade,
                                            fontSize: 12,
                                            color: HexColor("#ffffff")),
                                      ),
                                    ],
                                  )),
                                ),
                            ],
                          )),
                    ),
                  ],
                ),
                alignment: Alignment.topLeft,
              ),
              Align(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  CupertinoIcons.heart_solid,
                                  color: Colors.pinkAccent,
                                  size: 15,
                                ),
                                const SizedBox(width: 9),
                                Text(
                                  "Likes: $likes",
                                  style: TextStyle(
                                      overflow: TextOverflow.fade,
                                      fontSize: 12,
                                      color: HexColor("#ffffff")),
                                ),
                              ])),
                    ]),
                alignment: Alignment.bottomCenter,
              ),
              Align(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5),
                      child: Text(
                        title,
                        style:
                            TextStyle(fontSize: 19, color: HexColor("#ffffff")),
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                alignment: Alignment.center,
              ),
            ],
          ),
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
        ));
  }

  double getDim(int count) {
    switch (count) {
      case 1:
        return 31.0;
      case 2:
        return 52.0;
      case 3:
        return 73.0;
      case 4:
        return 85.0;
      case 5:
        return 105.0;
      case 6:
        return 125.0;
      case 7:
        return 145.0;
    }
    return 0.0;
  }

  Widget buildShimmer(BuildContext context) => Container(
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
          height: 180,
          br: BorderRadius.circular(15),
        ),
      );
}
