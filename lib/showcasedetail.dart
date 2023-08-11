import 'dart:io';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hsrwikiproject/uidimportPage.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'info.dart';

class ShowcaseDetailPage extends StatefulWidget {
  final List<Character> characterinfo;
  final int initialcharacter;
  const ShowcaseDetailPage(
      {super.key, required this.characterinfo, required this.initialcharacter});

  @override
  State<ShowcaseDetailPage> createState() => _ShowcaseDetailPageState();
}

class _ShowcaseDetailPageState extends State<ShowcaseDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  List<dynamic> attributesfinal = [];
  List<dynamic> additionfinal = [];
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final columnwidth = screenWidth > 1440
        ? screenWidth / 4
        : screenWidth > 905
            ? screenWidth / 2
            : screenWidth;

    ResponsiveGridBreakpoints.value = ResponsiveGridBreakpoints(
      xs: 600,
      sm: 905,
      md: 1440,
      lg: 1440,
    );

    final List<dynamic> attributes =
        widget.characterinfo[widget.initialcharacter].info['attributes'];
    final List<dynamic> additions =
        widget.characterinfo[widget.initialcharacter].info['additions'];

    attributesfinal = [];
    additionfinal = [];

    attributes.forEach((attr) {
      Map<String, dynamic> newAttr = Map.from(attr);
      bool isadded = false;
      additions.forEach((addition) {
        if (attr['field'] == 'hp' && addition['field'] == 'hp') {
          newAttr['value'] = attr['value'] + addition['value'];

          isadded = true;
        }
        if (attr['field'] == 'atk' && addition['field'] == 'atk') {
          newAttr['value'] = attr['value'] + addition['value'];
          isadded = true;
        }
        if (attr['field'] == 'def' && addition['field'] == 'def') {
          newAttr['value'] = attr['value'] + addition['value'];
          isadded = true;
        }
        if (attr['field'] == 'spd' && addition['field'] == 'spd') {
          newAttr['value'] = attr['value'] + addition['value'];
          isadded = true;
        }
        if (attr['field'] == 'crit_rate' && addition['field'] == 'crit_rate') {
          newAttr['value'] = attr['value'] + addition['value'];
          isadded = true;
        }
        if (attr['field'] == 'crit_dmg' && addition['field'] == 'crit_dmg') {
          newAttr['value'] = attr['value'] + addition['value'];
          isadded = true;
        }
      });

      if (isadded) {
        attributesfinal.add(newAttr);
      }
    });

    additions.forEach((addition) {
      Map<String, dynamic> newAttr = Map.from(addition);
      if (addition['field'] != 'hp' &&
          addition['field'] != 'atk' &&
          addition['field'] != 'def' &&
          addition['field'] != 'spd' &&
          addition['field'] != 'crit_rate' &&
          addition['field'] != 'crit_dmg') {
        additionfinal.add(newAttr);
      }
    });

    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(42, 41, 48, 1),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              // decoration: BoxDecoration(
              //   gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.blue.withOpacity(0.3), Colors.black.withOpacity(0.8)]),
              // ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: SingleChildScrollView(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: Screenshot(
                                        controller: screenshotController,
                                        child: Container(
                                          width: 700,
                                          height: 720,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                          ),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 50,
                                                child: Hero(
                                                  tag: widget
                                                      .characterinfo[widget
                                                          .initialcharacter]
                                                      .id,
                                                  child: Image.network(
                                                    urlendpoint +
                                                        imagestring(widget
                                                                .characterinfo[
                                                            widget
                                                                .initialcharacter]),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              //ANCHOR - Characterlightcones and relic sets
                                              Positioned(
                                                left: 0,
                                                bottom: 20,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          if (widget
                                                                  .characterinfo[
                                                                      widget
                                                                          .initialcharacter]
                                                                  .info["light_cone"] !=
                                                              null)
                                                            Stack(
                                                              children: [
                                                                Container(
                                                                  width: 180,
                                                                  height: 180,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          borderRadius: const BorderRadius.all(Radius.circular(
                                                                              10)),
                                                                          border:
                                                                              Border.all(color: Colors.white.withOpacity(0.13)),
                                                                          gradient: LinearGradient(
                                                                            begin:
                                                                                Alignment.topLeft,
                                                                            end:
                                                                                Alignment.bottomRight,
                                                                            colors: [
                                                                              Colors.white.withOpacity(0.01),
                                                                              Colors.white.withOpacity(0.1)
                                                                            ],
                                                                          )),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: FadeInImage
                                                                        .memoryNetwork(
                                                                      placeholder:
                                                                          kTransparentImage,
                                                                      height:
                                                                          160,
                                                                      image: urlendpoint +
                                                                          "images/lightcones/" +
                                                                          widget
                                                                              .characterinfo[widget.initialcharacter]
                                                                              .info["light_cone"]['id'] +
                                                                          '.png',
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  right: 0,
                                                                  bottom: 0,
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(10.0),
                                                                        child:
                                                                            Text(
                                                                          "S" +
                                                                              widget.characterinfo[widget.initialcharacter].info["light_cone"]['rank'].toString(),
                                                                          style:
                                                                              const TextStyle(
                                                                            //fontWeight: FontWeight.bold,
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                25,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            height:
                                                                                1,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  left: 0,
                                                                  top: 0,
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(10.0),
                                                                        child:
                                                                            Text(
                                                                          "LV" +
                                                                              widget.characterinfo[widget.initialcharacter].info["light_cone"]['level'].toString(),
                                                                          style:
                                                                              const TextStyle(
                                                                            //fontWeight: FontWeight.bold,
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            height:
                                                                                1,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          if (widget
                                                                          .characterinfo[widget
                                                                              .initialcharacter]
                                                                          .info[
                                                                      "relic_sets"] !=
                                                                  null &&
                                                              widget
                                                                      .characterinfo[
                                                                          widget
                                                                              .initialcharacter]
                                                                      .info[
                                                                          "relic_sets"]
                                                                      .length !=
                                                                  0)
                                                            Container(
                                                              width: 83,
                                                              height: 83,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius: const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              10)),
                                                                      border: Border.all(
                                                                          color: Colors.white.withOpacity(
                                                                              0.13)),
                                                                      gradient:
                                                                          LinearGradient(
                                                                        begin: Alignment
                                                                            .topLeft,
                                                                        end: Alignment
                                                                            .bottomRight,
                                                                        colors: [
                                                                          Colors
                                                                              .white
                                                                              .withOpacity(0.01),
                                                                          Colors
                                                                              .white
                                                                              .withOpacity(0.1)
                                                                        ],
                                                                      )),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: FadeInImage.memoryNetwork(
                                                                    placeholder:
                                                                        kTransparentImage,
                                                                    image: urlendpoint +
                                                                        "starrailres/" +
                                                                        widget.characterinfo[widget.initialcharacter].info["relic_sets"][0]
                                                                            [
                                                                            'icon'],
                                                                    filterQuality:
                                                                        FilterQuality
                                                                            .medium),
                                                              ),
                                                            ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Column(
                                                            children: [
                                                              if (widget.characterinfo[widget.initialcharacter].info[
                                                                          "relic_sets"] !=
                                                                      null &&
                                                                  widget
                                                                          .characterinfo[widget
                                                                              .initialcharacter]
                                                                          .info[
                                                                              "relic_sets"]
                                                                          .length >
                                                                      2)
                                                                Container(
                                                                  width: 83,
                                                                  height: 83,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          borderRadius: const BorderRadius.all(Radius.circular(
                                                                              10)),
                                                                          border:
                                                                              Border.all(color: Colors.white.withOpacity(0.13)),
                                                                          gradient: LinearGradient(
                                                                            begin:
                                                                                Alignment.topLeft,
                                                                            end:
                                                                                Alignment.bottomRight,
                                                                            colors: [
                                                                              Colors.white.withOpacity(0.01),
                                                                              Colors.white.withOpacity(0.1)
                                                                            ],
                                                                          )),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: FadeInImage.memoryNetwork(
                                                                        placeholder:
                                                                            kTransparentImage,
                                                                        image: urlendpoint +
                                                                            "starrailres/" +
                                                                            widget.characterinfo[widget.initialcharacter].info["relic_sets"][2][
                                                                                'icon'],
                                                                        filterQuality:
                                                                            FilterQuality.medium),
                                                                  ),
                                                                ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              if (widget.characterinfo[widget.initialcharacter].info[
                                                                          "relic_sets"] !=
                                                                      null &&
                                                                  widget
                                                                          .characterinfo[widget
                                                                              .initialcharacter]
                                                                          .info[
                                                                              "relic_sets"]
                                                                          .length >
                                                                      1)
                                                                Container(
                                                                  width: 83,
                                                                  height: 83,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          borderRadius: const BorderRadius.all(Radius.circular(
                                                                              10)),
                                                                          border:
                                                                              Border.all(color: Colors.white.withOpacity(0.13)),
                                                                          gradient: LinearGradient(
                                                                            begin:
                                                                                Alignment.topLeft,
                                                                            end:
                                                                                Alignment.bottomRight,
                                                                            colors: [
                                                                              Colors.white.withOpacity(0.01),
                                                                              Colors.white.withOpacity(0.1)
                                                                            ],
                                                                          )),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: FadeInImage.memoryNetwork(
                                                                        placeholder:
                                                                            kTransparentImage,
                                                                        image: urlendpoint +
                                                                            "starrailres/" +
                                                                            widget.characterinfo[widget.initialcharacter].info["relic_sets"][1][
                                                                                'icon'],
                                                                        filterQuality:
                                                                            FilterQuality.medium),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //ANCHOR - Charactereidolons
                                              Positioned(
                                                left: 5,
                                                top: 0,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Hero(
                                                        tag: widget
                                                                .characterinfo[
                                                                    widget
                                                                        .initialcharacter]
                                                                .info['rank']
                                                                .toString() +
                                                            widget
                                                                .initialcharacter
                                                                .toString(),
                                                        child: DefaultTextStyle(
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleLarge!,
                                                          child: Text(
                                                            "E" +
                                                                widget
                                                                    .characterinfo[
                                                                        widget
                                                                            .initialcharacter]
                                                                    .info[
                                                                        'rank']
                                                                    .toString(),
                                                            style:
                                                                const TextStyle(
                                                              //fontWeight: FontWeight.bold,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 45,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    for (int x = 0;
                                                        x <= 5;
                                                        x++) ...[
                                                      Opacity(
                                                        opacity: widget
                                                                    .characterinfo[
                                                                        widget
                                                                            .initialcharacter]
                                                                    .info['rank'] >
                                                                x
                                                            ? 1
                                                            : 0.5,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          16)),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          1)),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(1.0),
                                                              child: FadeInImage.memoryNetwork(
                                                                  placeholder:
                                                                      kTransparentImage,
                                                                  width: 30,
                                                                  image: urlendpoint +
                                                                      "starrailres/" +
                                                                      widget.characterinfo[widget.initialcharacter].info[
                                                                              "rank_icons"]
                                                                          [x],
                                                                  filterQuality:
                                                                      FilterQuality
                                                                          .medium),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                              //ANCHOR - Characterskills
                                              Positioned(
                                                left: 5,
                                                top: 425,
                                                width: 374,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    for (int x = 0;
                                                        x <= 3;
                                                        x++) ...[
                                                      Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            21)),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            1)),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        1.0),
                                                                child: FadeInImage.memoryNetwork(
                                                                    placeholder:
                                                                        kTransparentImage,
                                                                    width: 40,
                                                                    image: urlendpoint +
                                                                        "starrailres/" +
                                                                        widget.characterinfo[widget.initialcharacter].info["skills"][x]
                                                                            [
                                                                            'icon'],
                                                                    filterQuality:
                                                                        FilterQuality
                                                                            .medium),
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            "LV" +
                                                                widget
                                                                    .characterinfo[
                                                                        widget
                                                                            .initialcharacter]
                                                                    .info[
                                                                        "skills"]
                                                                        [x][
                                                                        'level']
                                                                    .toString(),
                                                            style:
                                                                const TextStyle(
                                                              //fontWeight: FontWeight.bold,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                              //ANCHOR - Characterelements
                                              Positioned(
                                                left: 310,
                                                top: 10,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Container(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(1.0),
                                                              child: FadeInImage.memoryNetwork(
                                                                  width: 50,
                                                                  placeholder:
                                                                      kTransparentImage,
                                                                  image: urlendpoint +
                                                                      "starrailres/" +
                                                                      widget.characterinfo[widget.initialcharacter].info[
                                                                              "element"]
                                                                          [
                                                                          'icon'],
                                                                  filterQuality:
                                                                      FilterQuality
                                                                          .medium),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Container(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(1.0),
                                                              child: FadeInImage.memoryNetwork(
                                                                  width: 50,
                                                                  placeholder:
                                                                      kTransparentImage,
                                                                  image: urlendpoint +
                                                                      "starrailres/" +
                                                                      widget.characterinfo[widget.initialcharacter].info[
                                                                              "path"]
                                                                          [
                                                                          'icon'],
                                                                  filterQuality:
                                                                      FilterQuality
                                                                          .medium),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //ANCHOR - CharacterLV
                                              Positioned(
                                                left: 390,
                                                top: 10,
                                                width: 300,
                                                height: 50,
                                                child: FittedBox(
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "LV" +
                                                                    widget
                                                                        .characterinfo[widget
                                                                            .initialcharacter]
                                                                        .info[
                                                                            'level']
                                                                        .toString() +
                                                                    " " +
                                                                    widget
                                                                        .characterinfo[
                                                                            widget.initialcharacter]
                                                                        .info['name'],
                                                                style:
                                                                    const TextStyle(
                                                                  //fontWeight: FontWeight.bold,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 40,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  height: 1,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              //ANCHOR - credit
                                              Positioned(
                                                left: 0,
                                                bottom: 5,
                                                width: 700,
                                                height: 20,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 670,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.search,
                                                                  size: 15,
                                                                  color: Colors
                                                                      .white70,
                                                                ),
                                                                Text(
                                                                  !kIsWeb &&
                                                                          Platform
                                                                              .isWindows
                                                                      ? "title_windows"
                                                                          .tr()
                                                                      : "title"
                                                                          .tr(),
                                                                  style:
                                                                      const TextStyle(
                                                                    //fontWeight: FontWeight.bold,
                                                                    color: Colors
                                                                        .white70,
                                                                    fontSize:
                                                                        12,
                                                                    height: 1,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  "${"url".tr()}",
                                                                  style:
                                                                      const TextStyle(
                                                                    //fontWeight: FontWeight.bold,
                                                                    color: Colors
                                                                        .white70,
                                                                    fontSize:
                                                                        12,
                                                                    height: 1,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              "${"API Support".tr()}: api.mohomo.me",
                                                              style:
                                                                  const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors
                                                                    .white70,
                                                                fontSize: 12,
                                                                height: 1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              //ANCHOR - Characterdata
                                              Positioned(
                                                left: 380,
                                                top: 60,
                                                width: 310,
                                                child: Column(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        Divider(
                                                          thickness: 1,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .primary
                                                              .withOpacity(0.3),
                                                        ),
                                                        Container(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: Text(
                                                              "Main Stats".tr(),
                                                              style:
                                                                  const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                height: 1,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: Container(
                                                        width: 310,
                                                        child: Wrap(
                                                          alignment:
                                                              WrapAlignment
                                                                  .start,
                                                          direction:
                                                              Axis.horizontal,
                                                          children: [
                                                            for (int x = 0;
                                                                x <
                                                                    attributesfinal
                                                                        .length;
                                                                x++) ...[
                                                              SizedBox(
                                                                width: 100,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              1.0),
                                                                      child: FadeInImage.memoryNetwork(
                                                                          width:
                                                                              35,
                                                                          placeholder:
                                                                              kTransparentImage,
                                                                          image: urlendpoint +
                                                                              "starrailres/" +
                                                                              attributesfinal[x][
                                                                                  'icon'],
                                                                          filterQuality:
                                                                              FilterQuality.medium),
                                                                    ),
                                                                    Text(
                                                                      (attributesfinal[x]
                                                                              [
                                                                              'percent'])
                                                                          ? (attributesfinal[x]['value'] * 100).toStringAsFixed(1) +
                                                                              "%"
                                                                          : attributesfinal[x]['value']
                                                                              .toStringAsFixed(0),
                                                                      style:
                                                                          const TextStyle(
                                                                        //fontWeight: FontWeight.bold,
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        height:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ]
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Stack(
                                                      children: [
                                                        Divider(
                                                          thickness: 1,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .primary
                                                              .withOpacity(0.3),
                                                        ),
                                                        Container(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: Text(
                                                              "Additional Stats"
                                                                  .tr(),
                                                              style:
                                                                  const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                height: 1,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: Container(
                                                        child: Wrap(
                                                          alignment:
                                                              WrapAlignment
                                                                  .start,
                                                          direction:
                                                              Axis.horizontal,
                                                          children: [
                                                            for (int x = 0;
                                                                x <
                                                                    additionfinal
                                                                        .length;
                                                                x++) ...[
                                                              SizedBox(
                                                                width: 100,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              1.0),
                                                                      child: FadeInImage.memoryNetwork(
                                                                          width:
                                                                              35,
                                                                          placeholder:
                                                                              kTransparentImage,
                                                                          image: urlendpoint +
                                                                              "starrailres/" +
                                                                              additionfinal[x][
                                                                                  'icon'],
                                                                          filterQuality:
                                                                              FilterQuality.medium),
                                                                    ),
                                                                    Text(
                                                                      (additionfinal[x]
                                                                              [
                                                                              'percent'])
                                                                          ? (additionfinal[x]['value'] * 100).toStringAsFixed(1) +
                                                                              "%"
                                                                          : additionfinal[x]['value']
                                                                              .toStringAsFixed(0),
                                                                      style:
                                                                          const TextStyle(
                                                                        //fontWeight: FontWeight.bold,
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        height:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ]
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //ANCHOR - relics
                                              Positioned(
                                                left: 370,
                                                bottom: 20,
                                                width: 330,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      for (int x = 0;
                                                          x <
                                                              widget
                                                                  .characterinfo[
                                                                      widget
                                                                          .initialcharacter]
                                                                  .info[
                                                                      'relics']
                                                                  .length;
                                                          x++) ...[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 2),
                                                          child: Container(
                                                            width: 350,
                                                            height: 70,
                                                            decoration:
                                                                BoxDecoration(
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            10)),
                                                                    //border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                                    gradient:
                                                                        LinearGradient(
                                                                      begin: Alignment
                                                                          .topLeft,
                                                                      end: Alignment
                                                                          .bottomRight,
                                                                      colors: (widget.characterinfo[widget.initialcharacter].info['relics'][x]['rarity'] ==
                                                                              5)
                                                                          ? [
                                                                              Colors.yellow.withOpacity(0.01),
                                                                              Colors.yellow.withOpacity(0.1)
                                                                            ]
                                                                          : (widget.characterinfo[widget.initialcharacter].info['relics'][x]['rarity'] ==
                                                                                  4)
                                                                              ? [
                                                                                  Colors.purple.withOpacity(0.01),
                                                                                  Colors.purple.withOpacity(0.1)
                                                                                ]
                                                                              : [
                                                                                  Colors.blue.withOpacity(0.01),
                                                                                  Colors.blue.withOpacity(0.1)
                                                                                ],
                                                                    )),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: 30,
                                                                  child:
                                                                      OverflowBox(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    maxWidth:
                                                                        60,
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.fromLTRB(
                                                                              5,
                                                                              5,
                                                                              0,
                                                                              5),
                                                                      child: FadeInImage.memoryNetwork(
                                                                          placeholder:
                                                                              kTransparentImage,
                                                                          image: urlendpoint +
                                                                              "starrailres/" +
                                                                              widget.characterinfo[widget.initialcharacter].info["relics"][x][
                                                                                  'icon'],
                                                                          filterQuality:
                                                                              FilterQuality.medium),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 80,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      FadeInImage.memoryNetwork(
                                                                          width:
                                                                              25,
                                                                          placeholder:
                                                                              kTransparentImage,
                                                                          image: urlendpoint +
                                                                              "starrailres/" +
                                                                              widget.characterinfo[widget.initialcharacter].info['relics'][x]['main_affix'][
                                                                                  'icon'],
                                                                          filterQuality:
                                                                              FilterQuality.medium),
                                                                      Text(
                                                                        (widget.characterinfo[widget.initialcharacter].info['relics'][x]['main_affix']['percent'])
                                                                            ? (widget.characterinfo[widget.initialcharacter].info['relics'][x]['main_affix']['value'] * 100).toStringAsFixed(1) +
                                                                                "%"
                                                                            : widget.characterinfo[widget.initialcharacter].info['relics'][x]['main_affix']['value'].toStringAsFixed(0),
                                                                        style:
                                                                            const TextStyle(
                                                                          //fontWeight: FontWeight.bold,
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              22,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          height:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.3),
                                                                          borderRadius:
                                                                              const BorderRadius.all(Radius.circular(2)),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(1.0),
                                                                          child:
                                                                              Text(
                                                                            "+" +
                                                                                (widget.characterinfo[widget.initialcharacter].info['relics'][x]['level']).toString(),
                                                                            style:
                                                                                const TextStyle(
                                                                              //fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.bold,

                                                                              height: 1,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          5),
                                                                  child:
                                                                      VerticalDivider(
                                                                    thickness:
                                                                        1,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary
                                                                        .withOpacity(
                                                                            0.3),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 90,
                                                                  height: 70,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(1.0),
                                                                            child: FadeInImage.memoryNetwork(
                                                                                width: 28,
                                                                                placeholder: kTransparentImage,
                                                                                image: urlendpoint + "starrailres/" + widget.characterinfo[widget.initialcharacter].info['relics'][x]['sub_affix'][0]['icon'],
                                                                                filterQuality: FilterQuality.medium),
                                                                          ),
                                                                          Text(
                                                                            (widget.characterinfo[widget.initialcharacter].info['relics'][x]['sub_affix'][0]['percent'])
                                                                                ? (widget.characterinfo[widget.initialcharacter].info['relics'][x]['sub_affix'][0]['value'] * 100).toStringAsFixed(1) + "%"
                                                                                : widget.characterinfo[widget.initialcharacter].info['relics'][x]['sub_affix'][0]['value'].toStringAsFixed(0),
                                                                            style:
                                                                                const TextStyle(
                                                                              //fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                              fontSize: 20,
                                                                              height: 1,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(1.0),
                                                                            child: FadeInImage.memoryNetwork(
                                                                                width: 28,
                                                                                placeholder: kTransparentImage,
                                                                                image: urlendpoint + "starrailres/" + widget.characterinfo[widget.initialcharacter].info['relics'][x]['sub_affix'][1]['icon'],
                                                                                filterQuality: FilterQuality.medium),
                                                                          ),
                                                                          Text(
                                                                            (widget.characterinfo[widget.initialcharacter].info['relics'][x]['sub_affix'][1]['percent'])
                                                                                ? (widget.characterinfo[widget.initialcharacter].info['relics'][x]['sub_affix'][1]['value'] * 100).toStringAsFixed(1) + "%"
                                                                                : widget.characterinfo[widget.initialcharacter].info['relics'][x]['sub_affix'][1]['value'].toStringAsFixed(0),
                                                                            style:
                                                                                const TextStyle(
                                                                              //fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                              fontSize: 20,
                                                                              height: 1,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 90,
                                                                  height: 70,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      if (widget
                                                                              .characterinfo[widget.initialcharacter]
                                                                              .info['relics'][x]['sub_affix']
                                                                              .length >
                                                                          2)
                                                                        Row(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(1.0),
                                                                              child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + widget.characterinfo[widget.initialcharacter].info['relics'][x]['sub_affix'][2]['icon'], filterQuality: FilterQuality.medium),
                                                                            ),
                                                                            Text(
                                                                              (widget.characterinfo[widget.initialcharacter].info['relics'][x]['sub_affix'][2]['percent']) ? (widget.characterinfo[widget.initialcharacter].info['relics'][x]['sub_affix'][2]['value'] * 100).toStringAsFixed(1) + "%" : widget.characterinfo[widget.initialcharacter].info['relics'][x]['sub_affix'][2]['value'].toStringAsFixed(0),
                                                                              style: const TextStyle(
                                                                                //fontWeight: FontWeight.bold,
                                                                                color: Colors.white,
                                                                                fontSize: 20,
                                                                                height: 1,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      if (widget
                                                                              .characterinfo[widget.initialcharacter]
                                                                              .info['relics'][x]['sub_affix']
                                                                              .length >
                                                                          3)
                                                                        Row(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(1.0),
                                                                              child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + widget.characterinfo[widget.initialcharacter].info['relics'][x]['sub_affix'][3]['icon'], filterQuality: FilterQuality.medium),
                                                                            ),
                                                                            Text(
                                                                              (widget.characterinfo[widget.initialcharacter].info['relics'][x]['sub_affix'][3]['percent']) ? (widget.characterinfo[widget.initialcharacter].info['relics'][x]['sub_affix'][3]['value'] * 100).toStringAsFixed(1) + "%" : widget.characterinfo[widget.initialcharacter].info['relics'][x]['sub_affix'][3]['value'].toStringAsFixed(0),
                                                                              style: const TextStyle(
                                                                                //fontWeight: FontWeight.bold,
                                                                                color: Colors.white,
                                                                                fontSize: 20,
                                                                                height: 1,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ]
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await screenshotController
                                              .capture(
                                                  delay: const Duration(
                                                      milliseconds: 10))
                                              .then((Uint8List? image) async {
                                            var now = DateTime.now();
                                            var dateFormat =
                                                DateFormat('yyyyMMddHHmmss');
                                            String timeNow =
                                                dateFormat.format(now);
                                            String fileName = widget
                                                    .characterinfo[
                                                        widget.initialcharacter]
                                                    .info['name'] +
                                                timeNow;
                                            if (kIsWeb || Platform.isWindows) {
                                              await FileSaver.instance.saveFile(
                                                  name: fileName,
                                                  bytes: image!,
                                                  ext: 'png',
                                                  mimeType: MimeType.png);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                duration: Duration(seconds: 3),
                                                content: Text("Saved".tr() +
                                                    ((!kIsWeb &&
                                                            Platform.isWindows)
                                                        ? " to Donwnload folder"
                                                        : "")),
                                                action: SnackBarAction(
                                                  label: '×',
                                                  onPressed: () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();
                                                    // Some code to undo the change.
                                                  },
                                                ),
                                              ));
                                            } else if (Platform.isAndroid ||
                                                Platform.isIOS) {
                                              XFile shareFile = XFile.fromData(
                                                  image!,
                                                  mimeType: MimeType.png.name,
                                                  name: fileName,
                                                  length: image.lengthInBytes);
                                              ShareResult shareResult =
                                                  await Share.shareXFiles(
                                                      [shareFile],
                                                      subject: fileName,
                                                      text: 'Share Text'.tr());
                                              print(
                                                  "shareStatus: ${shareResult.status.name}, raw: ${shareResult.raw}");
                                              if (shareResult.status ==
                                                  ShareResultStatus.success) {
                                                String toastText = "";
                                                if (shareResult.raw.contains(
                                                    'com.apple.UIKit.activity.SaveToCameraRoll')) {
                                                  toastText = 'Saved'.tr();
                                                } else if (shareResult.raw.contains(
                                                    "com.apple.UIKit.activity.CopyToPasteboard")) {
                                                  toastText = 'Copied'.tr();
                                                }
                                                if (toastText.isNotEmpty) {
                                                  Fluttertoast.showToast(
                                                      msg: toastText.tr(),
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.grey,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                }
                                              }
                                            }
                                          });
                                          setState(() {});
                                        },
                                        child:
                                            const Text('Save and Share').tr(),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  MaterialColor getcolor(Character character) {
    String element = character.info['element']['id'].toLowerCase();

    return etocolor[element]!;
  }

  String imagestring(Character character) {
    if (character.id == '8001' || character.id == '8002') {
      if (gender) {
        return "images/characters/mc.webp";
      } else {
        return "images/characters/mcm.webp";
      }
    } else if (character.id == '8003' || character.id == '8004') {
      if (gender) {
        return "images/characters/mcf.webp";
      } else {
        return "images/characters/mcmf.webp";
      }
    } else {
      return idtoimage[character.id]!;
    }
  }
}
