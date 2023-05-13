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
  late Map<String, dynamic> levelData;
  late int attributeCount;
  late double _currentSliderValue;

  Future<void> _getData(String url) async {
    final response = await http.get(Uri.parse(url));
    final Map<String, dynamic> jsonData = json.decode(response.body);
    characterData = jsonData;
    levelData = characterData!['leveldata'];
    _currentSliderValue = levelData.length - 1.0;
    attributeCount = levelData.length;
    print(characterData);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> namedata = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

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
                              xs: 12,
                              md: 6,
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 110,
                                    ),
                                    Container(
                                      child: Text(
                                        characterData!['CNname'],
                                        style: const TextStyle(
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          height: 1.1,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Image.network(
                                                etoimage[characterData!['etype']!]!,
                                              ),
                                              Text(
                                                characterData!['etype'],
                                                style: const TextStyle(
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.1,
                                                ),
                                              ).tr(),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              Image.network(
                                                wtoimage[characterData!['wtype']!]!,
                                                height: 80,
                                              ),
                                              Text(
                                                characterData!['wtype'],
                                                style: const TextStyle(
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.1,
                                                ),
                                              ).tr(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "LV:${levelData.keys.elementAt(_currentSliderValue.toInt())}",
                                          style: const TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            height: 1.1,
                                          ),
                                        ),
                                        Slider(
                                          value: _currentSliderValue,
                                          min: 0,
                                          max: (attributeCount - 1).toDouble(),
                                          divisions: attributeCount - 1,
                                          onChanged: (double value) {
                                            setState(() {
                                              _currentSliderValue = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "HP:${levelData.values.elementAt(_currentSliderValue.toInt())['hp']}",
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "ATK:${levelData.values.elementAt(_currentSliderValue.toInt())['atk']}",
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "DEF:${levelData.values.elementAt(_currentSliderValue.toInt())['def']}",
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "Basic speed:${characterData!['dspeed']}",
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "Basic Taunt:${characterData!['dtaunt']}",
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
                                  ],
                                ),
                              ),
                            ),
                            ResponsiveGridCol(
                              xs: 6,
                              md: 3,
                              child: Container(
                                height: 200,
                                alignment: Alignment(0, 0),
                                color: Colors.green.withOpacity(0.5),
                                child: Text("xs : 6 \r\nmd : 3"),
                              ),
                            ),
                            ResponsiveGridCol(
                              xs: 6,
                              md: 3,
                              child: Container(
                                height: 100,
                                alignment: Alignment(0, 0),
                                color: Colors.orange.withOpacity(0.5),
                                child: Text("xs : 6 \r\nmd : 3"),
                              ),
                            ),
                            ResponsiveGridCol(
                              xs: 6,
                              md: 3,
                              child: Container(
                                height: 100,
                                alignment: Alignment(0, 0),
                                color: Colors.red.withOpacity(0.5),
                                child: Text("xs : 6 \r\nmd : 3"),
                              ),
                            ),
                            ResponsiveGridCol(
                              xs: 6,
                              md: 3,
                              child: Container(
                                height: 100,
                                alignment: Alignment(0, 0),
                                color: Colors.blue.withOpacity(0.5),
                                child: Text("xs : 6 \r\nmd : 3"),
                              ),
                            ),
                          ],
                        ),
                      ),
                Hero(
                  tag: namedata['imageUrl']!,
                  child: Container(
                    width: 320,
                    height: 100,
                    color: etocolor[namedata['etype']!]?.withOpacity(0.6),
                    child: Image.network(
                      namedata['imageUrl']!,
                      alignment: const Alignment(-1, -0.5),
                      fit: BoxFit.none,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
