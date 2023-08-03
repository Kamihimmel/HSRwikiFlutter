import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

import 'characters/character_manager.dart';
import 'info.dart';
import 'relics/relic_manager.dart';
import 'showcasedetail.dart';
import 'utils/logging.dart';
import 'calculator/player_info.dart';

extension HexString on String {
  int getHexValue() => int.parse(replaceAll('#', '0xff'));
}

class Character {
  final String id;
  final String createdate;
  final Map<String, dynamic> info;

  Character(this.id, this.createdate, this.info);

  Character.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdate = json['createdate'],
        info = json['info'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdate': createdate,
        'info': info,
      };
}

class Uidimportpage extends StatefulWidget {
  const Uidimportpage({
    super.key,
    required this.screenWidth,
    required this.crossAxisCount3,
    required this.footer,
  });

  final double screenWidth;
  final int crossAxisCount3;
  final Padding footer;

  @override
  State<Uidimportpage> createState() => _UidimportpageState();
}

class _UidimportpageState extends State<Uidimportpage> {
  void initState() {
    super.initState();

    _getUid();
  }

  TextEditingController uidController = TextEditingController(text: '');

  String uid = "";
  String avatarimage = "";
  String nickname = "";
  String level = "";
  List<Character> characters = [];
  final ExpansionTileController expandcontroller = ExpansionTileController();

  void addOrUpdateCharacter(Character newCharacter) {
    setState(() {
      final existingIndex = characters.indexWhere((c) => c.id == newCharacter.id);
      if (existingIndex != -1) {
        characters[existingIndex] = newCharacter;
      } else {
        characters.add(newCharacter);
      }
    });
  }

  Future<void> _getUid() async {
    if (uid == '') {
      final prefs = await SharedPreferences.getInstance();

      uidController.text = prefs.getString('uid') ?? '';
      uid = prefs.getString('uid') ?? '';

      nickname = prefs.getString('nickname') ?? '';
      if (nickname == '') {
        expandcontroller.expand();
      }
      avatarimage = prefs.getString('avatarimage') ?? '';
      level = prefs.getString('level') ?? '';

      setState(() {});
    }

    if (characters.isEmpty) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final charactersJson = pref.getString('characters');
      if (charactersJson != null) {
        final charactersList = jsonDecode(charactersJson) as List;
        characters = charactersList.map((json) => Character.fromJson(json)).toList();
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // Column is also a layout widget. It takes a list of children and

      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: widget.screenWidth > 1300 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: SingleChildScrollView(
          child: Column(children: [
            ExpansionTile(
              expandedAlignment: Alignment.center,
              controller: expandcontroller,
              title: (nickname == "")
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("You have not imported any character.\nPlease import Using your in game UID.").tr(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (avatarimage != "")
                          Image.network(
                            avatarimage,
                            width: 80,
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            nickname,
                            style: const TextStyle(
                              //fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                        ),
                        if (level != "")
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "LV$level",
                              style: const TextStyle(
                                //fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                height: 1,
                              ),
                            ),
                          ),
                      ],
                    ),
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 1000),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: 'Your UID'.tr(),
                            border: OutlineInputBorder(),
                          ),
                          controller: uidController,
                          onChanged: (value) {
                            setState(() {
                              uid = value;
                            });
                          },
                          keyboardType: TextInputType.numberWithOptions(decimal: false),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: (uid.length == 9)
                              ? () async {
                                  if (uid != '') {
                                    final prefs = await SharedPreferences.getInstance();
                                    await prefs.setString('uid', uid);
                                  }
                                  String langcode = ('lang'.tr() == 'en') ? 'en' : (('lang'.tr() == 'cn') ? 'cn' : 'jp');
                                  String url = kIsWeb ? "https://mohomoapi.yunlu18.net/$uid?lang=$langcode" : "https://api.mihomo.me/sr_info_parsed/$uid?lang=$langcode";
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    duration: Duration(days: 1),
                                    content: Text("Loading.....").tr(),
                                    action: SnackBarAction(
                                      label: '×',
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        // Some code to undo the change.
                                      },
                                    ),
                                  ));
                                  http.Response resp = await http.get(
                                    Uri.parse(url),
                                  );
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                                  if (resp.statusCode != 200) {
                                    setState(() {
                                      int statusCode = resp.statusCode;

                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        duration: Duration(days: 1),
                                        backgroundColor: Colors.red,
                                        content: Text("Failed to get $statusCode").tr(),
                                        action: SnackBarAction(
                                          textColor: Colors.white,
                                          label: '×',
                                          onPressed: () {
                                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                            // Some code to undo the change.
                                          },
                                        ),
                                      ));
                                    });
                                    return;
                                  }
                                  Map<String, dynamic> returndata = jsonDecode(utf8.decode(resp.bodyBytes));
                                  if (RelicManager.getRelicIds().isEmpty) {
                                    await RelicManager.initAllRelics();
                                  }
                                  PlayerInfo playerInfo = PlayerInfo.fromImportJson(returndata);
                                  logger.d(playerInfo);
                                  logger.d(returndata['player']);
                                  nickname = returndata['player']['nickname'];

                                  level = returndata['player']['level'].toString();
                                  avatarimage = urlendpoint + "starrailres/" + returndata['player']['avatar']['icon'];
                                  if (nickname != '' && avatarimage != '' && level != '') {
                                    final prefs = await SharedPreferences.getInstance();
                                    await prefs.setString('nickname', nickname);
                                    await prefs.setString('avatarimage', avatarimage);
                                    await prefs.setString('level', level);
                                  }
                                  final List<Character> newCharacters = List<Character>.from(
                                      returndata['characters'].map((json) => Character(json['id'] as String, DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()), json as Map<String, dynamic>)));

                                  newCharacters.forEach((newCharacter) {
                                    addOrUpdateCharacter(newCharacter);
                                  });

                                  if (characters.isNotEmpty) {
                                    final prefs = await SharedPreferences.getInstance();

                                    String chracterinfo = jsonEncode(characters);
                                    await prefs.setString('characters', chracterinfo);
                                  }
                                  expandcontroller.collapse();

                                  setState(() {});
                                }
                              : null,
                          child: const Text('Import').tr(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 510,
              width: double.infinity,
              child: Center(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: characters.length,
                  itemBuilder: (context, index) {
                    final character = characters[index];
                    return InkWell(
                      onHover: (value) {
                        if (value) {
                          setState(() {});
                        }
                      },
                      onTap: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowcaseDetailPage(characterinfo: characters, initialcharacter: index),
                              settings: RouteSettings(),
                            ),
                          );
                        });
                      },
                      hoverColor: getcolor(character),
                      child: Container(
                        width: 374,
                        height: 508,
                        child: Stack(
                          children: [
                            Card(
                              color: Colors.grey.withOpacity(0.1),
                              child: Hero(
                                tag: character.id,
                                child: Image.network(
                                  urlendpoint + imagestring(character),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              bottom: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        if (character.info["light_cone"] != null)
                                          Stack(
                                            children: [
                                              Container(
                                                width: 180,
                                                height: 180,
                                                decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                    border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                      colors: [Colors.white.withOpacity(0.01), Colors.white.withOpacity(0.1)],
                                                    )),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: FadeInImage.memoryNetwork(
                                                    placeholder: kTransparentImage,
                                                    height: 160,
                                                    image: urlendpoint + "images/lightcones/" + character.info["light_cone"]['id'] + '.png',
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: 0,
                                                bottom: 0,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Text(
                                                        "R" + character.info["light_cone"]['rank'].toString(),
                                                        style: const TextStyle(
                                                          //fontWeight: FontWeight.bold,
                                                          color: Colors.white,
                                                          fontSize: 25,
                                                          fontWeight: FontWeight.bold,
                                                          height: 1,
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
                                        if (character.info["relic_sets"] != null && character.info["relic_sets"].length != 0)
                                          Container(
                                            width: 83,
                                            height: 83,
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [Colors.white.withOpacity(0.01), Colors.white.withOpacity(0.1)],
                                                )),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: FadeInImage.memoryNetwork(
                                                  placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + character.info["relic_sets"][0]['icon'], filterQuality: FilterQuality.medium),
                                            ),
                                          ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          children: [
                                            if (character.info["relic_sets"] != null && character.info["relic_sets"].length > 2)
                                              Container(
                                                width: 83,
                                                height: 83,
                                                decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                    border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                      colors: [Colors.white.withOpacity(0.01), Colors.white.withOpacity(0.1)],
                                                    )),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: FadeInImage.memoryNetwork(
                                                      placeholder: kTransparentImage,
                                                      image: urlendpoint + "starrailres/" + character.info["relic_sets"][2]['icon'],
                                                      filterQuality: FilterQuality.medium),
                                                ),
                                              ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            if (character.info["relic_sets"] != null && character.info["relic_sets"].length > 1)
                                              Container(
                                                width: 83,
                                                height: 83,
                                                decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                    border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                      colors: [Colors.white.withOpacity(0.01), Colors.white.withOpacity(0.1)],
                                                    )),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: FadeInImage.memoryNetwork(
                                                      placeholder: kTransparentImage,
                                                      image: urlendpoint + "starrailres/" + character.info["relic_sets"][1]['icon'],
                                                      filterQuality: FilterQuality.medium),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 374,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Text(
                                            "LV" + character.info['level'].toString() + " " + character.info['name'],
                                            style: const TextStyle(
                                              //fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              height: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Last Update At:".tr() + character.createdate,
                                      style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        color: Colors.grey.withOpacity(0.6),
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        setState(() {
                                          characters.removeAt(index);
                                          if (characters.isEmpty) {
                                            nickname = "";
                                            avatarimage = "";
                                            level = "";
                                            expandcontroller.expand();
                                          }
                                        });
                                        final prefs = await SharedPreferences.getInstance();
                                        await prefs.setString('nickname', nickname);
                                        await prefs.setString('avatarimage', avatarimage);
                                        await prefs.setString('level', level);
                                        String chracterinfo = jsonEncode(characters);
                                        await prefs.setString('characters', chracterinfo);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 5,
                              top: 0,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Hero(
                                      tag: character.info['rank'].toString() + index.toString(),
                                      child: DefaultTextStyle(
                                        style: Theme.of(context).textTheme.titleLarge!,
                                        child: Text(
                                          "E" + character.info['rank'].toString(),
                                          style: const TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 45,
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ]),
        )),
        widget.footer,
      ],
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
      return CharacterManager.getCharacter(character.id).entity.imageurl;
    }
  }
}
