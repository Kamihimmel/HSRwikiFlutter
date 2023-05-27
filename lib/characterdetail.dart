import 'dart:convert';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'info.dart';

class ChracterDetailPage extends StatefulWidget {
  final String jsonUrl;
  const ChracterDetailPage({super.key, required this.jsonUrl});

  @override
  State<ChracterDetailPage> createState() => _ChracterDetailPageState();
}

class _ChracterDetailPageState extends State<ChracterDetailPage> {
  Map<String, dynamic>? characterData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _getData(widget.jsonUrl);
  }

  final ScrollController _scrollController = ScrollController();
  late List<dynamic> levelData;
  late List<dynamic> skillData;
  late List<dynamic> traceData;
  late List<dynamic> eidolonData;
  late int attributeCount;
  late double _currentSliderValue;
  late List<double> levelnumbers;
  late List<double> levelnumbers3;

  Future<void> _getData(String url) async {
    final response = await http.get(Uri.parse(url));
    final Map<String, dynamic> jsonData = json.decode(response.body);
    characterData = jsonData;
    levelData = characterData!['leveldata'];
    skillData = characterData!['skilldata'];
    traceData = characterData!['tracedata'];
    eidolonData = characterData!['eidolon'];
    _currentSliderValue = levelData.length - 1.0;
    levelnumbers = List.generate(skillData.length, (index) => 8);
    levelnumbers3 = List.generate(eidolonData.length, (index) => 8);
    attributeCount = levelData.length;
    print(characterData);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> namedata = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
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

    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      constraints: const BoxConstraints.expand(),
      decoration: isLoading
          ? null
          : BoxDecoration(
              color: const Color.fromRGBO(42, 41, 48, 1),
              image: DecorationImage(
                image: NetworkImage(characterData!['imagelargeurl']),
                fit: BoxFit.fitHeight,
              )),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.1),
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
                                lg: 3,
                                md: 6,
                                xs: 12,
                                sm: 12,
                                child: Container(
                                  height: screenWidth > 905 ? screenHeight - 100 : null,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 100,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                                              child: Container(
                                                clipBehavior: Clip.hardEdge,
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                ),
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                      border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                          colors: [etocolor[namedata['etype']!]?.withOpacity(0.35) as Color, etocolor[namedata['etype']!]?.withOpacity(0.5) as Color]),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Image.network(
                                                          etoimage[characterData!['etype']!]!,
                                                          height: 50,
                                                        ),
                                                        Text(
                                                          characterData!['etype'],
                                                          style: const TextStyle(
                                                            //fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 25,
                                                            fontWeight: FontWeight.bold,
                                                            height: 1,
                                                          ),
                                                        ).tr(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(5, 10, 10, 0),
                                              child: Container(
                                                clipBehavior: Clip.hardEdge,
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                ),
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                      border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                          colors: [etocolor[namedata['etype']!]?.withOpacity(0.35) as Color, etocolor[namedata['etype']!]?.withOpacity(0.5) as Color]),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Image.network(
                                                          wtoimage[characterData!['wtype']!]!,
                                                          height: 50,
                                                        ),
                                                        Text(
                                                          characterData!['wtype'],
                                                          style: const TextStyle(
                                                            //fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 25,
                                                            fontWeight: FontWeight.bold,
                                                            height: 1,
                                                          ),
                                                        ).tr(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                          ),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [etocolor[namedata['etype']!]?.withOpacity(0.35) as Color, etocolor[namedata['etype']!]?.withOpacity(0.5) as Color]),
                                              ),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          width: 100,
                                                          child: Text(
                                                            "LV:${levelData[_currentSliderValue.toInt()]['level']}",
                                                            style: const TextStyle(
                                                              //fontWeight: FontWeight.bold,
                                                              color: Colors.white,
                                                              fontSize: 30,
                                                              fontWeight: FontWeight.bold,
                                                              height: 1.1,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Slider(
                                                            value: _currentSliderValue,
                                                            min: 0,
                                                            max: (attributeCount - 1).toDouble(),
                                                            divisions: attributeCount - 1,
                                                            activeColor: etocolor[namedata['etype']!],
                                                            inactiveColor: etocolor[namedata['etype']!]?.withOpacity(0.5),
                                                            onChanged: (double value) {
                                                              setState(() {
                                                                _currentSliderValue = value;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            ImageIcon(stattoimage['hp']),
                                                            Text(
                                                              "HP".tr(),
                                                              style: const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                                fontSize: 30,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1.1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          levelData[_currentSliderValue.toInt()]['hp'].toString(),
                                                          style: const TextStyle(
                                                            //fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                            fontWeight: FontWeight.bold,
                                                            height: 1.1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            ImageIcon(stattoimage['atk']),
                                                            Text(
                                                              "ATK".tr(),
                                                              style: const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                                fontSize: 30,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1.1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          levelData[_currentSliderValue.toInt()]['atk'].toString(),
                                                          style: const TextStyle(
                                                            //fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                            fontWeight: FontWeight.bold,
                                                            height: 1.1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            ImageIcon(stattoimage['def']),
                                                            Text(
                                                              "DEF".tr(),
                                                              style: const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                                fontSize: 30,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1.1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          levelData[_currentSliderValue.toInt()]['def'].toString(),
                                                          style: const TextStyle(
                                                            //fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                            fontWeight: FontWeight.bold,
                                                            height: 1.1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            ImageIcon(stattoimage['speed']),
                                                            Text(
                                                              "${"Basic".tr()}${"Speed".tr()}",
                                                              style: const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                                fontSize: 30,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1.1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          characterData!['dspeed'].toString(),
                                                          style: const TextStyle(
                                                            //fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                            fontWeight: FontWeight.bold,
                                                            height: 1.1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            ImageIcon(
                                                              stattoimage['taunt'],
                                                              size: 25,
                                                            ),
                                                            Text(
                                                              "${"Basic".tr()}${"Taunt".tr()}",
                                                              style: const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                                fontSize: 30,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1.1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          characterData!['dtaunt'].toString(),
                                                          style: const TextStyle(
                                                            //fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                            fontWeight: FontWeight.bold,
                                                            height: 1.1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            ImageIcon(
                                                              stattoimage['energylimit'],
                                                              size: 25,
                                                            ),
                                                            Text(
                                                              "${"Basic".tr()}${"Energy Limit".tr()}",
                                                              style: const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                                fontSize: 30,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1.1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          characterData!['maxenergy'].toString(),
                                                          style: const TextStyle(
                                                            //fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                            fontWeight: FontWeight.bold,
                                                            height: 1.1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (screenWidth > 905)
                                        Expanded(
                                          child: Image.network(characterData!['imagelargeurl'], filterQuality: FilterQuality.medium),
                                        ),
                                      if (screenWidth < 905)
                                        Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(15)),
                                          ),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                            child: Container(
                                                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                  border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                  gradient:
                                                      LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.black.withOpacity(0.7), Colors.black.withOpacity(0.9)]),
                                                ),
                                                child: Image.network(characterData!['imagelargeurl'], filterQuality: FilterQuality.medium)),
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
                                        Text(
                                          "Skill".tr(),
                                          style: const TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            height: 1.1,
                                          ),
                                        ),
                                        Column(
                                          children: List.generate(skillData.length, (index) {
                                            final data = skillData[index];
                                            String fixedtext = "";

                                            String detailtext = ('lang'.tr() == 'en') ? data['DescriptionEN']! : (('lang'.tr() == 'cn') ? data['DescriptionCN']! : data['DescriptionJP']!);
                                            if (data['maxlevel'] > 0) {
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
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                                colors: [etocolor[namedata['etype']!]?.withOpacity(0.35) as Color, Colors.black.withOpacity(0.5) as Color]),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                child: Image.network(
                                                                  data['imageurl']!,
                                                                  width: 100,
                                                                ),
                                                              ),
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
                                                                      if (data['maxlevel']! > 0)
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
                                                                                  activeColor: etocolor[namedata['etype']!],
                                                                                  inactiveColor: etocolor[namedata['etype']!]?.withOpacity(0.5),
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
                                                          color: Colors.black.withOpacity(0.8),
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
                                                                            child: Text('${(data['effect'][index2]['addtarget'] as String).tr()}$levelmulti%',
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
                                                Positioned(
                                                  top: 10,
                                                  left: 10,
                                                  child: Container(
                                                    width: 110,
                                                    decoration: BoxDecoration(
                                                      color: etocolor[namedata['etype']!]?.withOpacity(0.3),
                                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: Text(data['stype']!,
                                                            style: const TextStyle(
                                                              //fontWeight: FontWeight.bold,
                                                              color: Colors.white,
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                              height: 1.1,
                                                            )).tr(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                if (data['energy'] != null)
                                                  Positioned(
                                                    top: 10,
                                                    right: 130,
                                                    child: Container(
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        color: etocolor[namedata['etype']!]?.withOpacity(0.3),
                                                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(2.0),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              ImageIcon(
                                                                stattoimage['energylimit'],
                                                                size: 15,
                                                              ),
                                                              Text('${data['energy']!}',
                                                                  style: const TextStyle(
                                                                    //fontWeight: FontWeight.bold,
                                                                    color: Colors.white,

                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.bold,
                                                                    height: 1.1,
                                                                  )).tr(),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                if (data['weaknessbreak'] != null && data['energyregen'] != null)
                                                  Positioned(
                                                    top: 10,
                                                    right: 10,
                                                    child: Container(
                                                      width: 110,
                                                      decoration: BoxDecoration(
                                                        color: etocolor[namedata['etype']!]?.withOpacity(0.3),
                                                        borderRadius: const BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(2.0),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              ImageIcon(
                                                                stattoimage['breakup'],
                                                                size: 15,
                                                              ),
                                                              Text('${data['weaknessbreak']!}',
                                                                  style: const TextStyle(
                                                                    //fontWeight: FontWeight.bold,
                                                                    color: Colors.white,

                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.bold,
                                                                    height: 1.1,
                                                                  )).tr(),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              ImageIcon(
                                                                stattoimage['energyrecovery'],
                                                                size: 15,
                                                              ),
                                                              Text('${data['energyregen']!}',
                                                                  style: const TextStyle(
                                                                    //fontWeight: FontWeight.bold,
                                                                    color: Colors.white,

                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.bold,
                                                                    height: 1.1,
                                                                  )).tr(),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
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
                              //ANCHOR - Tracedata
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
                                        Text(
                                          "Trace".tr(),
                                          style: const TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            height: 1.1,
                                          ),
                                        ),
                                        Column(
                                          children: List.generate(traceData.length, (index) {
                                            final data = traceData[index];
                                            String detailtext = ('lang'.tr() == 'en') ? data['DescriptionEN']! : (('lang'.tr() == 'cn') ? data['DescriptionCN']! : data['DescriptionJP']!);

                                            if (data['tiny'] == false) {
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
                                                                  begin: Alignment.topLeft,
                                                                  end: Alignment.bottomRight,
                                                                  colors: [etocolor[namedata['etype']!]?.withOpacity(0.35) as Color, Colors.black.withOpacity(0.5) as Color]),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                  child: Image.network(
                                                                    data['imageurl']!,
                                                                    width: 100,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
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
                                                                          detailtext,
                                                                          style: const TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: 15,
                                                                          ),
                                                                          maxLines: 10,
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
                                                          decoration: BoxDecoration(
                                                            color: Colors.black.withOpacity(0.8),
                                                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                          ),
                                                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: List.generate(data['effect'].length, (index2) {
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
                                                                        if (data['effect'][index2]['multipliertarget'] != null)
                                                                          Container(
                                                                              margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                              padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                              decoration: BoxDecoration(
                                                                                color: typetocolor[(data['effect'][index2]['type'])],
                                                                                borderRadius: BorderRadius.circular(5),
                                                                              ),
                                                                              child: Text('${(data['effect'][index2]['multipliertarget'] as String).tr()}${data['effect'][index2]['multiplier']}%',
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
                                                                                  '${(data['effect'][index2]['addtarget'] as String).tr()}${data['effect'][index2]['multiplier']}${((data['effect'][index2]['addtarget']) != 'energy') ? "%" : ""}',
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
                                                  Positioned(
                                                    top: 10,
                                                    left: 10,
                                                    child: Container(
                                                      width: 110,
                                                      decoration: BoxDecoration(
                                                        color: etocolor[namedata['etype']!]?.withOpacity(0.3),
                                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(2.0),
                                                          child: Text(data['stype']!,
                                                              style: const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1.1,
                                                              )).tr(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if (data['energy'] != null)
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: Container(
                                                        width: 110,
                                                        decoration: BoxDecoration(
                                                          color: etocolor[namedata['etype']!]?.withOpacity(1),
                                                          borderRadius: BorderRadius.circular(2),
                                                        ),
                                                        child: Center(
                                                          child: Text('EP${data['energy']!}',
                                                              style: const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors.white,

                                                                fontSize: 20,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1.1,
                                                              )).tr(),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              );
                                            } else {
                                              return Column(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black.withOpacity(0.8),
                                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: ImageIcon(
                                                            stattoimage[data['ttype']!],
                                                            size: 40,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
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
                                                                  detailtext,
                                                                  style: const TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 15,
                                                                  ),
                                                                  maxLines: 10,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (data['effect'] != null)
                                                    Container(
                                                      width: double.infinity,
                                                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black.withOpacity(0.8),
                                                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                      ),
                                                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: List.generate(data['effect'].length, (index2) {
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
                                                                    if (data['effect'][index2]['multipliertarget'] != null)
                                                                      Container(
                                                                          margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                          padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                          decoration: BoxDecoration(
                                                                            color: Colors.redAccent,
                                                                            borderRadius: BorderRadius.circular(5),
                                                                          ),
                                                                          child: Text('${(data['effect'][index2]['multipliertarget'] as String).tr()}${data['effect'][index2]['multiplier']}%',
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
                                                                          child: Text('${(data['effect'][index2]['addtarget'] as String).tr()}${data['effect'][index2]['multiplier']}%',
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
                                              );
                                            }
                                          }),
                                        )
                                      ]),
                                    ),
                                  ),
                                ),
                              ),
                              //ANCHOR - eidolondata
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
                                        Text(
                                          "Eidolon".tr(),
                                          style: const TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            height: 1.1,
                                          ),
                                        ),
                                        Column(
                                          children: List.generate(eidolonData.length, (index) {
                                            final data = eidolonData[index];
                                            String fixedtext = "";

                                            String detailtext = ('lang'.tr() == 'en') ? data['DescriptionEN']! : (('lang'.tr() == 'cn') ? data['DescriptionCN']! : data['DescriptionJP']!);
                                            if (data['maxlevel'] != null && data['maxlevel'] > 0) {
                                              List<dynamic> multiplierData = data['levelmultiplier']!;

                                              int multicount = multiplierData.length;

                                              for (var i = multicount; i >= 1; i--) {
                                                Map<String, dynamic> currentleveldata = multiplierData[i - 1];
                                                String levelnum = (levelnumbers3[index].toStringAsFixed(0));

                                                fixedtext = detailtext.replaceAll("[$i]", (currentleveldata[levelnum]).toString());
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
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                                colors: [etocolor[namedata['etype']!]?.withOpacity(0.35) as Color, Colors.black.withOpacity(0.5) as Color]),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                child: Image.network(
                                                                  data['imageurl']!,
                                                                  width: 100,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
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
                                                                                  "LV:${levelnumbers3[index].toInt()}",
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
                                                                                  value: levelnumbers3[index],
                                                                                  min: 1,
                                                                                  max: (data['maxlevel']).toDouble(),
                                                                                  divisions: data['maxlevel'] - 1,
                                                                                  activeColor: etocolor[namedata['etype']!],
                                                                                  inactiveColor: etocolor[namedata['etype']!]?.withOpacity(0.5),
                                                                                  onChanged: (double value) {
                                                                                    setState(() {
                                                                                      levelnumbers3[index] = value;
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
                                                        decoration: BoxDecoration(
                                                          color: Colors.black.withOpacity(0.8),
                                                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                        ),
                                                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: List.generate(data['effect'].length, (index2) {
                                                            String levelmulti = "";

                                                            if (data['effect'][index2]['multiplier'] != null) {
                                                              levelmulti = (data['effect'][index2]['multiplier']).toString();
                                                            }
                                                            if (data['maxlevel'] != null && data['maxlevel']! > 0) {
                                                              Map<String, dynamic> leveldata2 = (data['levelmultiplier']![(data['effect'][index2]['multiplier']) - 1]);
                                                              String levelnum2 = (levelnumbers3[index].toStringAsFixed(0));
                                                              levelmulti = leveldata2[levelnum2].toString();
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
                                                                      if (data['effect'][index2]['multipliertarget'] != null)
                                                                        Container(
                                                                            margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                            padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                            decoration: BoxDecoration(
                                                                              color: typetocolor[(data['effect'][index2]['type'])],
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child: Text(
                                                                                '${(data['effect'][index2]['multipliertarget'] as String).tr()}$levelmulti${((data['effect'][index2]['multipliertarget']) != '') && (data['effect'][index2]['multiplier'] != null) ? "%" : ""}',
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
                                                Positioned(
                                                  top: 10,
                                                  left: 10,
                                                  child: Container(
                                                    width: 110,
                                                    decoration: BoxDecoration(
                                                      color: etocolor[namedata['etype']!]?.withOpacity(0.3),
                                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: Text((data['stype']! as String).tr() + data['eidolonnum']!.toString(),
                                                            style: const TextStyle(
                                                              //fontWeight: FontWeight.bold,
                                                              color: Colors.white,
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                              height: 1.1,
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                if (data['energy'] != null)
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      width: 110,
                                                      decoration: BoxDecoration(
                                                        color: etocolor[namedata['etype']!]?.withOpacity(1),
                                                        borderRadius: BorderRadius.circular(2),
                                                      ),
                                                      child: Center(
                                                        child: Text('EP${data['energy']!}',
                                                            style: const TextStyle(
                                                              //fontWeight: FontWeight.bold,
                                                              color: Colors.white,

                                                              fontSize: 20,
                                                              fontWeight: FontWeight.bold,
                                                              height: 1.1,
                                                            )).tr(),
                                                      ),
                                                    ),
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
                          color: etocolor[namedata['etype']!]?.withOpacity(0.6),
                          child: Image.network(
                            namedata['imageUrl']!,
                            alignment: const Alignment(1, -0.5),
                            fit: BoxFit.none,
                          ),
                        ),
                      ),
                      Padding(
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
