import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hsrwikiproject/calculator/basic.dart';
import 'package:hsrwikiproject/relics/relic.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../characters/character.dart';
import '../characters/character_manager.dart';
import '../lightcones/lightcone.dart';
import '../lightcones/lightcone_entity.dart';
import '../lightcones/lightcone_manager.dart';
import '../platformad_stub.dart' if (dart.library.io) '../platformad_stub.dart' if (dart.library.html) '../platformad.dart';
import '../relics/relic_manager.dart';
import '../utils/helper.dart';
import '../utils/logging.dart';
import 'global_state.dart';

/// 光锥遗器选择
class LightconeRelicState extends State<LightconeRelic> {
  final GlobalState _gs = GlobalState();
  late List<Lightcone> lightconeList;
  late List<Relic> relicList;

  @override
  void initState() {
    super.initState();
  }

  Row _getSubAttrRow(FightProp prop, double value) {
    return Row(
      children: prop != FightProp.unknown ? [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: getImageComponent(prop.icon, placeholder: kTransparentImage, width: 28),
        ),
        Text(
          "${prop.getPropText(value)}",
          style: const TextStyle(
            //fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
            height: 1,
          ),
        ),
      ] : [],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final columnwidth = screenWidth > 1440
        ? screenWidth / 4
        : screenWidth > 905
            ? screenWidth / 2
            : screenWidth;
    return ChangeNotifierProvider.value(
        value: _gs,
        child: Consumer<GlobalState>(builder: (context, model, child) {
          final Character _cData = CharacterManager.getCharacter(_gs.stats.id);
          final Lightcone _lData = LightconeManager.getLightcone(_gs.stats.lightconeId);
          lightconeList = LightconeManager.getLightcones().values.where((lc) => _gs.spoilerMode || !lc.spoiler).where((lc) => lc.pathType == _cData.pathType).toList();
          lightconeList.sort((e1, e2) => e2.entity.rarity.compareTo(e1.entity.rarity));
          lightconeList.sort((e1, e2) => e1.spoiler == e2.spoiler ? 0 : (e1.spoiler ? -1 : 1));
          relicList = RelicManager.getRelics().values.where((r) => _gs.spoilerMode || !r.spoiler).toList();
          relicList.sort((e1, e2) => e1.spoiler == e2.spoiler ? 0 : (e1.spoiler ? -1 : 1));
          return Container(
            height: screenWidth > 905 ? screenHeight - 100 : null,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          for (var lc in lightconeList)
                                            ListTile(
                                              leading: getImageComponent(lc.entity.imageurl, imageWrap: true),
                                              title: Text(lc.getName(getLanguageCode(context))),
                                              // enabled: entry.value.loaded,
                                              onTap: () async {
                                                _gs.stats.lightconeId = lc.entity.id;
                                                await LightconeManager.loadFromRemoteById(lc.entity.id);
                                                _gs.changeStats();
                                                Navigator.pop(context);
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 10,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            border: Border.all(color: Colors.white.withOpacity(0.13)),
                            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                              Colors.black12.withOpacity(0.35),
                              Colors.black.withOpacity(0.35),
                            ]),
                          ),
                          child: getImageComponent(_lData.entity.imageurl, placeholder: kTransparentImage, fit: BoxFit.contain, width: 200),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            border: Border.all(color: Colors.white.withOpacity(0.13)),
                            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_cData.elementType.color.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
                          ),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            "LV:${_gs.stats.lightconeLevel}",
                                            style: const TextStyle(
                                              //fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              height: 1.1,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Slider(
                                            value: _lData.entity.leveldata.map((e) => e.level).toList().indexOf(_gs.stats.lightconeLevel).toDouble(),
                                            min: 0,
                                            max: _lData.entity.leveldata.length - 1,
                                            divisions: _lData.entity.leveldata.length,
                                            activeColor: _cData.elementType.color,
                                            inactiveColor: _cData.elementType.color.withOpacity(0.5),
                                            onChanged: (double value) {
                                              _gs.stats.lightconeLevel = _lData.entity.leveldata[value.toInt()].level;
                                              _gs.changeStats();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: List.generate(_lData.entity.skilldata.length, (index) {
                                  final LightconeSkilldata skill = _lData.entity.skilldata[index];

                                  return Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            clipBehavior: Clip.hardEdge,
                                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                  border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_cData.elementType.color.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 100,
                                                                    child: Text(
                                                                      "E${_gs.stats.lightconeRank}",
                                                                      style: const TextStyle(
                                                                        //fontWeight: FontWeight.bold,
                                                                        color: Colors.white,
                                                                        fontSize: 25,
                                                                        fontWeight: FontWeight.bold,
                                                                        height: 1.1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Slider(
                                                                      value: _gs.stats.lightconeRank.toDouble(),
                                                                      min: 1,
                                                                      max: skill.maxlevel.toDouble(),
                                                                      divisions: skill.maxlevel,
                                                                      activeColor: _cData.elementType.color,
                                                                      inactiveColor: _cData.elementType.color.withOpacity(0.5),
                                                                      onChanged: (double value) {
                                                                        _gs.stats.lightconeRank = value.toInt();
                                                                        _gs.changeStats();
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
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  //ANCHOR - relicselect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(3, (index) {
                      List<String> sets = _gs.stats.getRelicSets(withDefault: true);
                      List<String> defaultSets = CharacterManager.getDefaultRelicSets(_gs.stats.id);
                      String imageUrl;
                      if (sets.length > index && sets[index] != '') {
                        imageUrl = RelicManager.getRelic(sets[index]).entity.imageurl;
                      } else if (defaultSets[index] != '') {
                        imageUrl = RelicManager.getRelic(defaultSets[index]).entity.imageurl;
                      } else {
                        imageUrl = '';
                      }
                      return InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              List<Relic> relics = relicList.where((r) => index <= 1 && r.entity.xSet == '4' || index == 2 && r.entity.xSet == '2').toList();
                              return SizedBox(
                                child: Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              for (var r in relics)
                                                ListTile(
                                                  leading: getImageComponent(r.entity.imageurl, imageWrap: true),
                                                  title: Text(r.getName(getLanguageCode(context))),
                                                  onTap: () async {
                                                    if (index == 0) {
                                                      _gs.stats.relics[RelicPart.head]?.setId = r.entity.id;
                                                      _gs.stats.relics[RelicPart.hands]?.setId = r.entity.id;
                                                    } else if (index == 1) {
                                                      _gs.stats.relics[RelicPart.body]?.setId = r.entity.id;
                                                      _gs.stats.relics[RelicPart.feet]?.setId = r.entity.id;
                                                    } else if (index == 2) {
                                                      _gs.stats.relics[RelicPart.sphere]?.setId = r.entity.id;
                                                      _gs.stats.relics[RelicPart.rope]?.setId = r.entity.id;
                                                    }
                                                    await RelicManager.loadFromRemoteById(r.entity.id);
                                                    _gs.changeStats();
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Card(
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.transparent,
                          elevation: 10,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: Container(
                                width: 125,
                                height: 125,
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                  border: Border.all(color: Colors.white.withOpacity(0.13)),
                                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                                    Colors.black12.withOpacity(0.35),
                                    Colors.black.withOpacity(0.35),
                                  ]),
                                ),
                                child: getImageComponent(imageUrl, placeholder: kTransparentImage, fit: BoxFit.cover, width: 125)),
                          ),
                        ),
                      );
                    }),
                  ),
                  //ANCHOR - relics
                  Column(
                    children: RelicPart.values.where((rp) => rp != RelicPart.unknown).map((rp) {
                      RelicStats rs = _gs.stats.relics[rp]!;
                      List<Record<FightProp, double>> subAttrValues = rs.subAttrValues;
                      for (var i = 0; i < 4 - subAttrValues.length; i++) {
                        subAttrValues.add(Record.of(FightProp.unknown, 0));
                      }
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return ChangeNotifierProvider.value(
                                value: _gs,
                                child: Consumer<GlobalState>(builder: (context, model, child) {
                                  RelicStats rs = _gs.stats.relics[rp]!;
                                  List<Record<FightProp, double>> subAttrValues = rs.subAttrValues;
                                  return SizedBox(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          width: 100,
                                                          child: Text(
                                                            "Rarity:${rs.rarity}",
                                                            style: const TextStyle(
                                                              //fontWeight: FontWeight.bold,
                                                              color: Colors.white,
                                                              fontSize: 15,
                                                              height: 1.1,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Slider(
                                                            value: rs.rarity.toDouble(),
                                                            min: 3,
                                                            max: 5,
                                                            divisions: 3,
                                                            activeColor: _cData.elementType.color,
                                                            inactiveColor: _cData.elementType.color.withOpacity(0.5),
                                                            onChanged: (double value) {
                                                              rs.rarity = value.toInt();
                                                              int maxLevel = getRelicMaxLevel(rs.rarity);
                                                              if (rs.level > maxLevel) {
                                                                rs.level = maxLevel;
                                                              }
                                                              _gs.changeStats();
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
                                                        SizedBox(
                                                          width: 100,
                                                          child: Text(
                                                            "Level:${rs.level}",
                                                            style: const TextStyle(
                                                              //fontWeight: FontWeight.bold,
                                                              color: Colors.white,
                                                              fontSize: 15,
                                                              height: 1.1,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Slider(
                                                            value: rs.level.toDouble(),
                                                            min: 1,
                                                            max: getRelicMaxLevel(rs.rarity).toDouble(),
                                                            divisions: getRelicMaxLevel(rs.rarity),
                                                            activeColor: _cData.elementType.color,
                                                            inactiveColor: _cData.elementType.color.withOpacity(0.5),
                                                            onChanged: (double value) {
                                                              rs.level = value.toInt();
                                                              _gs.changeStats();
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
                                                        SizedBox(
                                                          width: 100,
                                                          child: Text(
                                                            "Main Stat:",
                                                            style: const TextStyle(
                                                              //fontWeight: FontWeight.bold,
                                                              color: Colors.white,
                                                              fontSize: 15,
                                                              height: 1.1,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child: DropdownButton(
                                                              items: rp.mainAttrs.map((attr) {
                                                                return DropdownMenuItem(
                                                                  value: attr.name,
                                                                  child: Text("${attr.desc.tr()}${attr.isPercent() ? ' %' : ''}"),
                                                                );
                                                              }).toList(),
                                                              value: rs.mainAttr.name,
                                                              onChanged: (value) {
                                                                rs.mainAttr = FightProp.fromName(value.toString());
                                                                for (var record in rs.subAttrValues) {
                                                                  if (record.key == rs.mainAttr) {
                                                                    record.key = FightProp.unknown;
                                                                  }
                                                                }
                                                                _gs.changeStats();
                                                              },
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  for (var index = 0; index < 4; index++)
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                width: 100,
                                                                child: Text(
                                                                  "Sub Stat${index + 1}:",
                                                                  style: const TextStyle(
                                                                    //fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                    fontSize: 15,
                                                                    height: 1.1,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  child: DropdownButton(
                                                                    items: relicSubAttrs.where((attr) => attr != rs.mainAttr).map((attr) {
                                                                      return  DropdownMenuItem(
                                                                        value: attr.name,
                                                                        child: Text("${attr.desc.tr()}${attr.isPercent() ? ' %' : ''}"),
                                                                      );
                                                                    }).toList(),
                                                                    value: subAttrValues[index].key.name,
                                                                    onChanged: (value) {
                                                                      FightProp prop = FightProp.fromName(value.toString());
                                                                      Record<FightProp, double> subAttr = subAttrValues[index];
                                                                      subAttrValues[index] = Record.of(prop, subAttr.value);
                                                                      _gs.changeStats();
                                                                    },
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                width: 100,
                                                                child: Text(
                                                                  "Value${index + 1}:",
                                                                  style: const TextStyle(
                                                                    //fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                    fontSize: 15,
                                                                    height: 1.1,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  child: TextFormField(
                                                                    initialValue: subAttrValues[index].key.getPropText(subAttrValues[index].value).replaceFirst('%', ''),
                                                                    keyboardType: TextInputType.numberWithOptions(
                                                                      decimal: true,
                                                                      signed: false,
                                                                    ),
                                                                    onChanged: (value) {
                                                                      Record<FightProp, double> subAttr = subAttrValues[index];
                                                                      double v = double.tryParse(value.toString()) ?? 0;
                                                                      if (subAttr.key.isPercent()) {
                                                                        v /= 100;
                                                                      }
                                                                      subAttrValues[index] = Record.of(subAttr.key, v);
                                                                      _gs.changeStats();
                                                                    },
                                                                    inputFormatters: [
                                                                      FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                                                                      TextInputFormatter.withFunction((oldValue, newValue) {
                                                                        final text = newValue.text;
                                                                        return text.isEmpty
                                                                            ? newValue
                                                                            : double.tryParse(text) == null
                                                                            ? oldValue
                                                                            : newValue;
                                                                      }),
                                                                    ],
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }));
                              },
                            );
                          },
                          child: Card(
                            clipBehavior: Clip.hardEdge,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: Colors.transparent,
                            elevation: 10,
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                  border: Border.all(color: Colors.white.withOpacity(0.13)),
                                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_cData.elementType.color.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2),
                                      child: Container(
                                        width: double.infinity,
                                        height: 70,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 45,
                                              height: 45,
                                              child: getImageComponent(rp.icon, imageWrap: true, placeholder: kTransparentImage, width: 45, remote: false, fit: BoxFit.contain),
                                            ),
                                            SizedBox(
                                              width: 80,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  getImageComponent(rs.mainAttr.icon, placeholder: kTransparentImage, width: 25),
                                                  Text(
                                                    "${rs.mainAttr.getPropText(getRelicMainAttrValue(rs.mainAttr, rs.rarity, rs.level))}",
                                                    style: const TextStyle(
                                                      //fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.bold,
                                                      height: 1,
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black.withOpacity(0.3),
                                                      borderRadius: const BorderRadius.all(Radius.circular(2)),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(1.0),
                                                      child: Text(
                                                        "+${rs.level}",
                                                        style: const TextStyle(
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
                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                              child: VerticalDivider(
                                                thickness: 1,
                                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                              ),
                                            ),
                                            if (rs.subAttrValues.length > 0)
                                              SizedBox(
                                                width: 90,
                                                height: 70,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: rs.subAttrValues.take(2).map((record) {
                                                    return _getSubAttrRow(record.key, record.value);
                                                  }).toList(),
                                                ),
                                              ),
                                            if (rs.subAttrValues.length > 2)
                                              SizedBox(
                                                width: 90,
                                                height: 70,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: rs.subAttrValues.skip(2).take(2).map((record) {
                                                    return _getSubAttrRow(record.key, record.value);
                                                  }).toList(),
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
                        ),
                      );
                    }).toList(),
                  ),
                  adsenseAdsView(columnwidth - 20),
                  if (widget.isBannerAdReady)
                    Container(
                      width: widget.bannerAd!.size.width.toDouble(),
                      height: widget.bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: widget.bannerAd!),
                    ),
                ],
              ),
            ),
          );
        }));
  }
}

class LightconeRelic extends StatefulWidget {
  final isBannerAdReady;
  final bannerAd;

  const LightconeRelic({
    Key? key,
    required this.isBannerAdReady,
    required this.bannerAd,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LightconeRelicState();
  }
}
