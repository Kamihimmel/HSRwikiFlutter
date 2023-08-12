import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

import 'calculator/player_info.dart';
import 'characters/character_manager.dart';
import 'characters/character_stats.dart';
import 'lightcones/lightcone_manager.dart';
import 'relics/relic_manager.dart';
import 'showcasedetail.dart';
import 'utils/helper.dart';
import 'utils/logging.dart';

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
    required this.footer,
  });

  final Padding footer;

  @override
  State<Uidimportpage> createState() => _UidimportpageState();
}

class _UidimportpageState extends State<Uidimportpage> {
  bool _loading = true;

  void initState() {
    super.initState();
    _getPlayerInfo();
  }

  final TextEditingController uidController = TextEditingController(text: '');
  final ExpansionTileController expandController = ExpansionTileController();

  List<Character> characters = [];
  PlayerInfo _playerInfo = PlayerInfo();

  void addOrUpdateCharacter(Character newCharacter) {
    final existingIndex = characters.indexWhere((c) => c.id == newCharacter.id);
    if (existingIndex != -1) {
      characters[existingIndex] = newCharacter;
    } else {
      characters.add(newCharacter);
    }
  }

  Future<void> _getPlayerInfo() async {
    if (LightconeManager.getLightconeIds().isEmpty) {
      await LightconeManager.initAllLightcones();
    }
    if (RelicManager.getRelicIds().isEmpty) {
      await RelicManager.initAllRelics();
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final playerInfoJson = await prefs.getString('playerinfo');
    if (playerInfoJson != null) {
      _playerInfo = PlayerInfo.fromJson(jsonDecode(playerInfoJson));
    } else {
      _playerInfo.uid = await prefs.getString('uid') ?? '';
      _playerInfo.nickname = await prefs.getString('nickname') ?? '';
      String avatarimage = await prefs.getString('avatarimage') ?? '';
      if (avatarimage != '') {
        _playerInfo.avatar = avatarimage.substring(avatarimage.indexOf('starrailres/'));
      }
      _playerInfo.level = num.tryParse(await prefs.getString('level') ?? '')?.toInt() ?? 0;
      await prefs.setString('playerinfo', _playerInfo.toJson());
    }
    if (characters.isEmpty) {
      // TODO 移除characters依赖
      final charactersJson = await prefs.getString('characters');
      if (charactersJson != null) {
        final charactersList = jsonDecode(charactersJson) as List;
        characters = charactersList.map((json) => Character.fromJson(json)).toList();
        _playerInfo.characters = charactersList.map((json) {
          Map<String, dynamic> info = json['info'];
          return CharacterStats.fromImportJson(info, updateTime: json['createdate']);
        }).toList();
      }
    }
    uidController.text = _playerInfo.uid;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return _loading ? Center(
      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
    ) : Column(
      // Column is also a layout widget. It takes a list of children and

      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: screenWidth > 1300 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: SingleChildScrollView(
          child: Column(children: [
            ExpansionTile(
              expandedAlignment: Alignment.center,
              controller: expandController,
              initiallyExpanded: _playerInfo.nickname == "",
              title: (_playerInfo.nickname == "")
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("You have not imported any character.\nPlease import Using your in game UID.").tr(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_playerInfo.avatar != "") getImageComponent(_playerInfo.avatar, imageWrap: true, width: 80),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _playerInfo.nickname,
                            style: const TextStyle(
                              //fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                        ),
                        if (_playerInfo.level > 0)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "LV${_playerInfo.level}",
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
                              _playerInfo.uid = value;
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
                          onPressed: (_playerInfo.uid.length == 9)
                              ? () async {
                                  if (_playerInfo.uid != '') {
                                    final prefs = await SharedPreferences.getInstance();
                                    await prefs.setString('uid', _playerInfo.uid);
                                  }
                                  String langcode =
                                      ('lang'.tr() == 'en') ? 'en' : (('lang'.tr() == 'cn') ? 'cn' : 'jp');
                                  String url = kIsWeb
                                      ? "https://mohomoapi.yunlu18.net/${_playerInfo.uid}?lang=$langcode"
                                      : "https://api.mihomo.me/sr_info_parsed/${_playerInfo.uid}?lang=$langcode";
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
                                  final prefs = await SharedPreferences.getInstance();
                                  PlayerInfo playerInfo = PlayerInfo.fromImportJson(returndata);
                                  logger.d(playerInfo);
                                  final List<Character> newCharacters = List<Character>.from(returndata['characters']
                                      .map((json) => Character(
                                          json['id'] as String,
                                          DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
                                          json as Map<String, dynamic>)));
                                  if (_playerInfo.uid == playerInfo.uid) {
                                    if (_playerInfo.characters.isNotEmpty) {
                                      for (var cs in _playerInfo.characters) {
                                        if (!playerInfo.characters.any((c) => c.id == cs.id)) {
                                          playerInfo.characters.add(cs);
                                        }
                                      }
                                    }
                                    newCharacters.forEach((newCharacter) {
                                      addOrUpdateCharacter(newCharacter);
                                    });
                                  }
                                  _playerInfo = playerInfo;
                                  await prefs.setString('playerinfo', _playerInfo.toJson());
                                  await prefs.setString('characters', jsonEncode(characters));
                                  expandController.collapse();
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
                  itemCount: _playerInfo.characters.length,
                  itemBuilder: (context, index) {
                    final CharacterStats characterStats = _playerInfo.characters[index];
                    final List<int> eidolons = characterStats.eidolons.entries
                        .where((e) => e.value > 0)
                        .map((e) => num.parse(e.key).toInt())
                        .toList();
                    eidolons.sort();
                    final int rank = eidolons.isEmpty ? 0 : eidolons[eidolons.length - 1];
                    List<String> relicSets = characterStats.getRelicSets(withDefault: false);
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
                              builder: (context) => ShowcaseDetailPage(
                                  characterinfo: characters, initialcharacter: index, characterStats: characterStats),
                              settings: RouteSettings(),
                            ),
                          );
                        });
                      },
                      hoverColor: CharacterManager.getCharacter(characterStats.id).elementType.color,
                      child: Container(
                        width: 374,
                        height: 508,
                        child: Stack(
                          children: [
                            Card(
                              color: Colors.grey.withOpacity(0.1),
                              child: Hero(
                                tag: characterStats.id,
                                child: getImageComponent(imagestring(characterStats.id), imageWrap: true),
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
                                        if (characterStats.lightconeId != '')
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
                                                      colors: [
                                                        Colors.white.withOpacity(0.01),
                                                        Colors.white.withOpacity(0.1)
                                                      ],
                                                    )),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: getImageComponent(
                                                    LightconeManager.getLightcone(characterStats.lightconeId)
                                                        .entity
                                                        .imageurl,
                                                    placeholder: kTransparentImage,
                                                    height: 160,
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
                                                        "R${characterStats.lightconeRank}",
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
                                        if (relicSets[0] != '')
                                          Container(
                                            width: 83,
                                            height: 83,
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Colors.white.withOpacity(0.01),
                                                    Colors.white.withOpacity(0.1)
                                                  ],
                                                )),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: getImageComponent(
                                                  RelicManager.getRelic(relicSets[0]).entity.imageurl,
                                                  placeholder: kTransparentImage),
                                            ),
                                          ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          children: [
                                            if (relicSets[2] != '')
                                              Container(
                                                width: 83,
                                                height: 83,
                                                decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                    border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                      colors: [
                                                        Colors.white.withOpacity(0.01),
                                                        Colors.white.withOpacity(0.1)
                                                      ],
                                                    )),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: getImageComponent(
                                                      RelicManager.getRelic(relicSets[2]).entity.imageurl,
                                                      placeholder: kTransparentImage),
                                                ),
                                              ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            if (relicSets[1] != '')
                                              Container(
                                                width: 83,
                                                height: 83,
                                                decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                    border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                      colors: [
                                                        Colors.white.withOpacity(0.01),
                                                        Colors.white.withOpacity(0.1)
                                                      ],
                                                    )),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: getImageComponent(
                                                      RelicManager.getRelic(relicSets[1]).entity.imageurl,
                                                      placeholder: kTransparentImage),
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
                                            "LV${characterStats.level} ${CharacterManager.getCharacter(characterStats.id).getName(getLanguageCode(context))}",
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
                                      "Last Update At:".tr() + " " + characterStats.updateTime,
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
                                          _playerInfo.characters.removeAt(index);
                                          if (characters.isEmpty) {
                                            _playerInfo.nickname = "";
                                            _playerInfo.avatar = "";
                                            _playerInfo.level = 0;
                                            expandController.expand();
                                          }
                                        });
                                        final prefs = await SharedPreferences.getInstance();
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
                                      tag: "$rank$index",
                                      child: DefaultTextStyle(
                                        style: Theme.of(context).textTheme.titleLarge!,
                                        child: Text(
                                          "E$rank",
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
}
