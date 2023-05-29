import 'dart:convert';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'info.dart';

class RelicDetailPage extends StatefulWidget {
  final String jsonUrl;
  const RelicDetailPage({super.key, required this.jsonUrl});

  @override
  State<RelicDetailPage> createState() => _RelicDetailPageState();
}

class _RelicDetailPageState extends State<RelicDetailPage> {
  Map<String, dynamic>? relicData;
  bool isLoading = true;

  Color darkcolor = Colors.black;
  Color lightcolor = Colors.black;

  @override
  void initState() {
    super.initState();

    _getData(widget.jsonUrl);
  }

  late PaletteGenerator _palette;
  bool _isLoading = true;
  bool _hasError = false;

  Future<void> _loadPalette(String url) async {
    try {
      final imageProvider = NetworkImage(url);
      _palette = await PaletteGenerator.fromImageProvider(imageProvider);
      setState(() {
        _isLoading = false;
        darkcolor = _palette.darkMutedColor?.color ?? Colors.black;
        lightcolor = _palette.lightVibrantColor?.color ?? Colors.black;

        final hexCode = darkcolor.value.toRadixString(16).padLeft(8, '0');
        final directColor = '#${hexCode.substring(2)}';

        print('Dark Color: $directColor');

        final hexCode2 = lightcolor.value.toRadixString(16).padLeft(8, '0');
        final directColor2 = '#${hexCode.substring(2)}';
        print('Light Color: $directColor2');

        final hexCode3 = (Colors.black).value.toRadixString(16).padLeft(8, '0');
        final directColor3 = '#${hexCode.substring(2)}';
        print('Black Color: $directColor3');
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  final ScrollController _scrollController = ScrollController();

  late List<dynamic> skillData;
  late int attributeCount;
  late double _currentSliderValue;
  late List<double> levelnumbers;

  Future<void> _getData(String url) async {
    final response = await http.get(Uri.parse(url));
    final Map<String, dynamic> jsonData = json.decode(response.body);
    relicData = jsonData;
    skillData = relicData!['skilldata'];

    levelnumbers = List.generate(skillData.length, (index) => 5);

    print(relicData);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> namedata = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    if (darkcolor == Colors.black && lightcolor == Colors.black) {
      _loadPalette(namedata['imageUrl']!);
    }
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

    const raritytocolor = {
      '5': Colors.amber,
      '4': Colors.deepPurpleAccent,
      '3': Colors.blueAccent,
    };

    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [lightcolor.withOpacity(1), darkcolor.withOpacity(1)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(('lang'.tr() == 'en') ? namedata['enname']! : (('lang'.tr() == 'cn') ? namedata['cnname']! : namedata['janame']!)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  isLoading
                      ? const CircularProgressIndicator()
                      : Container(
                          child: ResponsiveGridRow(
                            children: [
                              ResponsiveGridCol(
                                lg: 9,
                                md: 6,
                                xs: 12,
                                sm: 12,
                                child: Container(
                                  height: screenWidth > 905 ? screenHeight - 100 : null,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 110,
                                      ),
                                      if (screenWidth > 905)
                                        if (relicData!['set'] == "4")
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.network(relicData!['head'], filterQuality: FilterQuality.medium),
                                                    Image.network(relicData!['hands'], filterQuality: FilterQuality.medium),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.network(relicData!['body'], filterQuality: FilterQuality.medium),
                                                    Image.network(relicData!['feet'], filterQuality: FilterQuality.medium),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                      if (screenWidth > 905)
                                        if (relicData!['set'] == "2")
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.network(relicData!['sphere'], filterQuality: FilterQuality.medium),
                                                    Image.network(relicData!['rope'], filterQuality: FilterQuality.medium),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                      if (screenWidth < 905)
                                        if (relicData!['set'] == "4")
                                          FittedBox(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.network(relicData!['head'], filterQuality: FilterQuality.medium),
                                                    Image.network(relicData!['hands'], filterQuality: FilterQuality.medium),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.network(relicData!['body'], filterQuality: FilterQuality.medium),
                                                    Image.network(relicData!['feet'], filterQuality: FilterQuality.medium),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                      if (screenWidth < 905)
                                        if (relicData!['set'] == "2")
                                          FittedBox(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.network(relicData!['sphere'], filterQuality: FilterQuality.medium),
                                                    Image.network(relicData!['rope'], filterQuality: FilterQuality.medium),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                    ],
                                  ),
                                ),
                              ),
                              //ANCHOR - Skilldata
                              ResponsiveGridCol(
                                lg: 3,
                                md: 6,
                                xs: 12,
                                sm: 12,
                                child: Container(
                                  height: screenWidth > 905 ? screenHeight - 100 : null,
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(children: [
                                        const SizedBox(
                                          height: 100,
                                        ),
                                        FittedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.all(25.0),
                                            child: Text(
                                              ('lang'.tr() == 'en') ? namedata['enname']! : (('lang'.tr() == 'cn') ? namedata['cnname']! : namedata['janame']!),
                                              style: const TextStyle(
                                                //fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 50,
                                                fontWeight: FontWeight.bold,
                                                height: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: List.generate(skillData.length, (index) {
                                            final data = skillData[index];
                                            String fixedtext = "";

                                            String detailtext = ('lang'.tr() == 'en') ? data['DescriptionEN']! : (('lang'.tr() == 'cn') ? data['DescriptionCN']! : data['DescriptionJP']!);
                                            if (data['maxlevel'] != null && data['maxlevel'] > 0) {
                                              List<dynamic> multiplierData = data['levelmultiplier']!;

                                              int multicount = multiplierData.length;
                                              fixedtext = detailtext;

                                              for (var i = multicount; i >= 1; i--) {
                                                Map<String, dynamic> currentleveldata = multiplierData[i - 1];
                                                String levelnum = (levelnumbers[index].toStringAsFixed(0));

                                                if (currentleveldata['default'] == null) {
                                                  fixedtext = fixedtext.replaceAll("[$i]", (currentleveldata[levelnum]).toString());
                                                } else {
                                                  fixedtext = fixedtext.replaceAll("[$i]", (currentleveldata['default']).toString());
                                                }
                                              }
                                            } else {
                                              fixedtext = detailtext;
                                            }

                                            return Stack(
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                      clipBehavior: Clip.hardEdge,
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                      ),
                                                      child: BackdropFilter(
                                                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: (data['effect'] != null)
                                                                ? const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                                                                : const BorderRadius.all(Radius.circular(15)),
                                                            border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                            gradient: LinearGradient(
                                                                begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [lightcolor.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        ('lang'.tr() == 'en') ? data['ENname']! : (('lang'.tr() == 'cn') ? data['CNname']! : data['JAname']!),
                                                                        style: const TextStyle(
                                                                          color: Colors.white,
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 20,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        fixedtext,
                                                                        style: const TextStyle(
                                                                          color: Colors.white,
                                                                          fontSize: 15,
                                                                        ),
                                                                        maxLines: 10,
                                                                      ),
                                                                      if (data['maxlevel'] != null && data['maxlevel']! > 0)
                                                                        Padding(
                                                                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                child: Text(
                                                                                  "LV:${levelnumbers[index].toInt()}",
                                                                                  style: const TextStyle(
                                                                                    //fontWeight: FontWeight.bold,
                                                                                    color: Colors.white,
                                                                                    fontSize: 20,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    height: 1.1,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Slider(
                                                                                  value: levelnumbers[index],
                                                                                  min: 1,
                                                                                  max: (data['maxlevel']).toDouble(),
                                                                                  divisions: data['maxlevel'] - 1,
                                                                                  activeColor: raritytocolor[relicData?['rarity']],
                                                                                  inactiveColor: raritytocolor[relicData?['rarity']]?.withOpacity(0.5),
                                                                                  onChanged: (double value) {
                                                                                    setState(() {
                                                                                      levelnumbers[index] = value;
                                                                                    });
                                                                                  },
                                                                                ),
                                                                              ),
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
                                                      ),
                                                    ),
                                                    if (data['effect'] != null)
                                                      Container(
                                                        width: double.infinity,
                                                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                        decoration: BoxDecoration(
                                                          color: Colors.black.withOpacity(0.5),
                                                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: List.generate(data['effect'].length, (index2) {
                                                            String levelmulti = "";

                                                            if (data['levelmultiplier'] != null) {
                                                              Map<String, dynamic> leveldata2 = (data['levelmultiplier']![(data['effect'][index2]['multiplier']) - 1]);
                                                              String levelnum2 = (levelnumbers[index].toStringAsFixed(0));

                                                              if (leveldata2['default'] == null) {
                                                                levelmulti = leveldata2[levelnum2].toString();
                                                              } else {
                                                                levelmulti = leveldata2['default'].toString();
                                                              }
                                                            } else {
                                                              levelmulti = data['effect'][index2]['multiplier'].toString();
                                                            }

                                                            return SingleChildScrollView(
                                                              scrollDirection: Axis.horizontal,
                                                              child: Scrollbar(
                                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                          margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                          padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                          decoration: BoxDecoration(
                                                                            color: Colors.amber,
                                                                            borderRadius: BorderRadius.circular(5),
                                                                          ),
                                                                          child: Text(data['effect'][index2]['type'],
                                                                              style: const TextStyle(
                                                                                //fontWeight: FontWeight.bold,
                                                                                color: Colors.black,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                height: 1.1,
                                                                              )).tr()),
                                                                      if (data['effect'][index2]['referencetarget'] != null)
                                                                        Container(
                                                                            margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                            padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.amber,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child: Text(
                                                                                ('lang'.tr() == 'en')
                                                                                    ? data['effect'][index2]['referencetargetEN']!
                                                                                    : (('lang'.tr() == 'cn')
                                                                                        ? data['effect'][index2]['referencetargetCN']!
                                                                                        : data['effect'][index2]['referencetargetJP']!),
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.black,
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  height: 1.1,
                                                                                ))),
                                                                      if (data['effect'][index2]['multipliertarget'] != null)
                                                                        Container(
                                                                            margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                            padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                            decoration: BoxDecoration(
                                                                              color: typetocolor[(data['effect'][index2]['type'])],
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child: Text(
                                                                                '${(data['effect'][index2]['multipliertarget'] as String).tr()}$levelmulti${((data['effect'][index2]['multipliertarget']) != '') ? "%" : ""}',
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.black,
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  height: 1.1,
                                                                                ))),
                                                                      if (data['effect'][index2]['addtarget'] != null)
                                                                        Container(
                                                                            margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                            padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.greenAccent,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child: Text(
                                                                                '${(data['effect'][index2]['addtarget'] as String).tr()}$levelmulti${((data['effect'][index2]['addtarget']) != 'energy') ? "%" : ""}',
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.black,
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  height: 1.1,
                                                                                ))),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                      children: List.generate(data['effect'][index2]['tag'].length, (index3) {
                                                                    List<dynamic> taglist = data['effect'][index2]['tag'];

                                                                    return Container(
                                                                        margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                        padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.white,
                                                                          borderRadius: BorderRadius.circular(5),
                                                                        ),
                                                                        child: Text(taglist[index3],
                                                                            style: const TextStyle(
                                                                              //fontWeight: FontWeight.bold,
                                                                              color: Colors.black,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              height: 1.1,
                                                                            )).tr());
                                                                  })),
                                                                ]),
                                                              ),
                                                            );
                                                          }),
                                                        ),
                                                      ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          }),
                                        )
                                      ]),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  Stack(
                    children: [
                      Hero(
                        tag: namedata['imageUrl']!,
                        child: Container(
                          width: columnwidth,
                          height: 100,
                          color: Colors.grey.withOpacity(0.6),
                          child: Image.network(
                            namedata['imageUrl']!,
                            alignment: const Alignment(1, -0.5),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                      FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Text(
                            ('lang'.tr() == 'en') ? namedata['enname']! : (('lang'.tr() == 'cn') ? namedata['cnname']! : namedata['janame']!),
                            style: const TextStyle(
                              //fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
