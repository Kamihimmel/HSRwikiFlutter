import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'info.dart';

class ChracterDetailPage extends StatefulWidget {
  final String jsonUrl;
  ChracterDetailPage({required this.jsonUrl});

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
  late int attributeCount;
  late double _currentSliderValue;
  late List<double> levelnumbers;

  Future<void> _getData(String url) async {
    final response = await http.get(Uri.parse(url));
    final Map<String, dynamic> jsonData = json.decode(response.body);
    characterData = jsonData;
    levelData = characterData!['leveldata'];
    skillData = characterData!['skilldata'];
    _currentSliderValue = levelData.length - 1.0;
    levelnumbers = List.generate(skillData.length, (index) => 8);
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

    return Scaffold(
      appBar: AppBar(
        title: Text(('lang'.tr() == 'en') ? namedata['enname']! : (('lang'.tr() == 'cn') ? namedata['cnname']! : namedata['janame']!)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                isLoading
                    ? CircularProgressIndicator()
                    : Container(
                        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(characterData!['imagelargeurl']), fit: BoxFit.fitHeight)),
                        child: ResponsiveGridRow(
                          children: [
                            ResponsiveGridCol(
                              lg: 3,
                              md: 6,
                              xs: 12,
                              sm: 12,
                              child: Container(
                                height: screenWidth > 905 ? screenHeight - 100 : null,
                                color: Colors.black.withOpacity(0.1),
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
                                              color: etocolor[namedata['etype']!]?.withOpacity(0.6),
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
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(5, 10, 10, 0),
                                            child: Container(
                                              color: etocolor[namedata['etype']!]?.withOpacity(0.6),
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
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        color: etocolor[namedata['etype']!]?.withOpacity(0.6),
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
                                  ],
                                ),
                              ),
                            ),
                            ResponsiveGridCol(
                              lg: 3,
                              md: 6,
                              xs: 12,
                              sm: 12,
                              child: Container(
                                height: screenWidth > 905 ? screenHeight - 100 : null,
                                color: Colors.green.withOpacity(0.1),
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

                                        String detailtext = ('lang'.tr() == 'en') ? data['DescriptionEN']! : (('lang'.tr() == 'cn') ? data['DescriptionCN']! : data['DescriptionJA']!);
                                        if (data['maxlevel'] > 0) {
                                          List<dynamic> multiplierData = data['levelmultiplier']!;

                                          int multicount = multiplierData.length;

                                          for (var i = multicount; i >= 1; i--) {
                                            Map<String, dynamic> currentleveldata = multiplierData[i - 1];
                                            String levelnum = (levelnumbers[index].toStringAsFixed(0));

                                            fixedtext = detailtext.replaceAll("[$i]", (currentleveldata[levelnum]).toString());
                                          }
                                        } else {
                                          fixedtext = detailtext;
                                        }

                                        return Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.all(10),
                                          color: etocolor[namedata['etype']!]?.withOpacity(0.6),
                                          child: Row(
                                            children: [
                                              Image.network(
                                                data['imageurl']!,
                                                width: 100,
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
                                                      if (data['maxlevel']! > 0)
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                width: 100,
                                                                child: Text(
                                                                  "LV:${levelnumbers[index].toInt()}",
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
                                        );
                                      }),
                                    )
                                  ]),
                                ),
                              ),
                            ),
                            ResponsiveGridCol(
                              lg: 3,
                              md: 6,
                              xs: 12,
                              sm: 12,
                              child: Container(
                                height: 100,
                                alignment: Alignment(0, 0),
                                color: Colors.orange.withOpacity(0.5),
                                child: Text("xs : 6 \r\nmd : 3"),
                              ),
                            ),
                            ResponsiveGridCol(
                              lg: 3,
                              md: 6,
                              xs: 12,
                              sm: 12,
                              child: Container(
                                height: 100,
                                alignment: Alignment(0, 0),
                                color: Colors.red.withOpacity(0.5),
                                child: Text("xs : 6 \r\nmd : 3"),
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
    );
  }
}
