import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';

import 'calculator/basic.dart';
import 'characters/character.dart';
import 'characters/character_manager.dart';
import 'characters/character_stats.dart';
import 'lightcones/lightcone_manager.dart';
import 'relics/relic.dart';
import 'relics/relic_manager.dart';
import 'utils/helper.dart';

class ShowcaseDetailPage extends StatefulWidget {
  
  final CharacterStats characterStats;

  const ShowcaseDetailPage({
    super.key,
    required this.characterStats,
  });

  @override
  State<ShowcaseDetailPage> createState() => _ShowcaseDetailPageState();
}

class _ShowcaseDetailPageState extends State<ShowcaseDetailPage> {
  bool _loading = true;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await CharacterManager.loadFromRemoteById(widget.characterStats.id);
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveGridBreakpoints.value = ResponsiveGridBreakpoints(
      xs: 600,
      sm: 905,
      md: 1440,
      lg: 1440,
    );

    final cs = widget.characterStats;
    final List<int> eidolons = cs.eidolons.entries.where((e) => e.value > 0).map((e) => num.parse(e.key).toInt()).toList();
    eidolons.sort();
    final int rank = eidolons.isEmpty ? 0 : eidolons[eidolons.length - 1];
    List<String> relicSets = cs.getRelicSets();
    Map<FightProp, double> propValue = cs.importStats;
    Character c = CharacterManager.getCharacter(cs.id);

    final List<FightProp> mainProps = [
      FightProp.maxHP,
      FightProp.attack,
      FightProp.defence,
      FightProp.speed,
      FightProp.criticalChance,
      FightProp.criticalDamage
    ];
    final Map<FightProp, double> mainPropValues = {};
    for (var p in mainProps) {
      mainPropValues[p] = propValue[p] ?? 0;
    }
    if (mainPropValues[FightProp.speed] == 0) {
      mainPropValues[FightProp.speed] = c.entity.dspeed.toDouble();
    }

    FightProp elementAddProp;
    if (c.pathType == PathType.abundance) {
      elementAddProp = FightProp.healRatio;
    } else {
      elementAddProp = FightProp.fromEffectKey(c.elementType.key + 'dmg');
    }
    final List<FightProp> additionProps = [
      FightProp.breakDamageAddedRatio,
      FightProp.statusProbability,
      FightProp.statusResistance,
      elementAddProp,
      FightProp.sPRatio,
      FightProp.aggro,
    ];
    final Map<FightProp, double> additionPropValues = {};
    for (var p in additionProps) {
      additionPropValues[p] = propValue[p] ?? 0;
    }
    additionPropValues[FightProp.aggro] = c.entity.dtaunt.toDouble();

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
              child: _loading
                  ? Center(
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                    )
                  : Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Column(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: SingleChildScrollView(
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      FittedBox(
                                        child: Screenshot(
                                          controller: screenshotController,
                                          child: Container(
                                            width: 700,
                                            height: 720,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.background,
                                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  left: 0,
                                                  top: 50,
                                                  child: Hero(
                                                    tag: cs.id,
                                                    child: getImageComponent(
                                                      imagestring(cs.id),
                                                      imageWrap: true,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                //ANCHOR - Characterlightcones and relic sets
                                                Positioned(
                                                  left: 0,
                                                  bottom: 20,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
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
                                                                    child: cs.lightconeId != '' ? getImageComponent(
                                                                      LightconeManager.getLightcone(cs.lightconeId).entity.imageurl,
                                                                      imageWrap: true,
                                                                      placeholder: kTransparentImage,
                                                                      height: 160,
                                                                    ) : SizedBox.fromSize(size: Size.fromHeight(160)),
                                                                  ),
                                                                ),
                                                                if (cs.lightconeId != '')
                                                                  Positioned(
                                                                    right: 0,
                                                                    bottom: 0,
                                                                    child: Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.all(10.0),
                                                                          child: Text(
                                                                            "S${cs.lightconeRank}",
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
                                                                if (cs.lightconeId != '')
                                                                  Positioned(
                                                                    left: 0,
                                                                    top: 0,
                                                                    child: Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.all(10.0),
                                                                          child: Text(
                                                                            "LV${cs.lightconeLevel}",
                                                                            style: const TextStyle(
                                                                              //fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                              fontSize: 18,
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
                                                            if (relicSets[0] != '')
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
                                                                      colors: [Colors.white.withOpacity(0.01), Colors.white.withOpacity(0.1)],
                                                                    )),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: getImageComponent(RelicManager.getRelic(relicSets[0]).entity.imageurl,
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
                                                                          colors: [Colors.white.withOpacity(0.01), Colors.white.withOpacity(0.1)],
                                                                        )),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: getImageComponent(RelicManager.getRelic(relicSets[2]).entity.imageurl,
                                                                          placeholder: kTransparentImage),
                                                                    ),
                                                                  ),
                                                                if (relicSets[1] != '')
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
                                                                          colors: [Colors.white.withOpacity(0.01), Colors.white.withOpacity(0.1)],
                                                                        )),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: getImageComponent(RelicManager.getRelic(relicSets[1]).entity.imageurl,
                                                                          placeholder: kTransparentImage),
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
                                                        padding: const EdgeInsets.all(10.0),
                                                        child: Hero(
                                                          tag: "$rank${cs.id}",
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
                                                      for (int x = 0; x <= 5; x++) ...[
                                                        Opacity(
                                                          opacity: rank > x ? 1 : 0.5,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(2.0),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: const BorderRadius.all(Radius.circular(16)),
                                                                border: Border.all(color: Colors.white.withOpacity(1)),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(1.0),
                                                                child: getImageComponent(c.entity.eidolon[x].imageurl,
                                                                    imageWrap: true, placeholder: kTransparentImage, width: 30),
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
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      for (int x = 0; x <= 3; x++) ...[
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: const BorderRadius.all(Radius.circular(21)),
                                                                  border: Border.all(color: Colors.white.withOpacity(1)),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(1.0),
                                                                  child: getImageComponent(
                                                                    c.entity.skilldata[x].imageurl,
                                                                    imageWrap: true,
                                                                    placeholder: kTransparentImage,
                                                                    width: 40,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              "LV${cs.skillLevels[c.entity.skilldata[x].id]}",
                                                              style: const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.bold,
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
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(2.0),
                                                            child: Container(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(1.0),
                                                                child: getImageComponent(c.elementType.icon,
                                                                    imageWrap: true, width: 50, placeholder: kTransparentImage),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(2.0),
                                                            child: Container(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(1.0),
                                                                child: getImageComponent(c.pathType.icon,
                                                                    imageWrap: true, width: 50, placeholder: kTransparentImage),
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
                                                          padding: const EdgeInsets.all(2.0),
                                                          child: Container(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  "LV${cs.level} ${c.getName(getLanguageCode(context))}",
                                                                  style: const TextStyle(
                                                                    //fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                    fontSize: 40,
                                                                    fontWeight: FontWeight.bold,
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
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.search,
                                                                    size: 15,
                                                                    color: Colors.white70,
                                                                  ),
                                                                  Text(
                                                                    !kIsWeb && Platform.isWindows ? "title_windows".tr() : "title".tr(),
                                                                    style: const TextStyle(
                                                                      //fontWeight: FontWeight.bold,
                                                                      color: Colors.white70,
                                                                      fontSize: 12,
                                                                      height: 1,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    "${"url".tr()}",
                                                                    style: const TextStyle(
                                                                      //fontWeight: FontWeight.bold,
                                                                      color: Colors.white70,
                                                                      fontSize: 12,
                                                                      height: 1,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Text(
                                                                "${"API Support".tr()}: api.mohomo.me",
                                                                style: const TextStyle(
                                                                  //fontWeight: FontWeight.bold,
                                                                  color: Colors.white70,
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
                                                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                                          ),
                                                          Container(
                                                            color: Theme.of(context).colorScheme.background,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(3.0),
                                                              child: Text(
                                                                "Main Stats".tr(),
                                                                style: const TextStyle(
                                                                  //fontWeight: FontWeight.bold,
                                                                  color: Colors.white,
                                                                  fontSize: 10,
                                                                  fontWeight: FontWeight.bold,
                                                                  height: 1,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: Container(
                                                          width: 310,
                                                          child: Wrap(
                                                            alignment: WrapAlignment.start,
                                                            direction: Axis.horizontal,
                                                            children: mainProps.map((p) {
                                                              String text = p.getPropText(mainPropValues[p]!);
                                                              return SizedBox(
                                                                width: 100,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(1.0),
                                                                      child: getImageComponent(p.icon, width: 35, placeholder: kTransparentImage),
                                                                    ),
                                                                    Text(
                                                                      text,
                                                                      style: const TextStyle(
                                                                        //fontWeight: FontWeight.bold,
                                                                        color: Colors.white,
                                                                        fontSize: 20,
                                                                        fontWeight: FontWeight.bold,
                                                                        height: 1,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                      ),
                                                      Stack(
                                                        children: [
                                                          Divider(
                                                            thickness: 1,
                                                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                                          ),
                                                          Container(
                                                            color: Theme.of(context).colorScheme.background,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(3.0),
                                                              child: Text(
                                                                "Additional Stats".tr(),
                                                                style: const TextStyle(
                                                                  //fontWeight: FontWeight.bold,
                                                                  color: Colors.white,
                                                                  fontSize: 10,
                                                                  fontWeight: FontWeight.bold,
                                                                  height: 1,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: Container(
                                                          child: Wrap(
                                                            alignment: WrapAlignment.start,
                                                            direction: Axis.horizontal,
                                                            children: additionProps.map((p) {
                                                              String text = p.getPropText(additionPropValues[p]!);
                                                              return SizedBox(
                                                                width: 100,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(1.0),
                                                                      child: getImageComponent(p.icon, width: 35, placeholder: kTransparentImage),
                                                                    ),
                                                                    Text(
                                                                      text,
                                                                      style: const TextStyle(
                                                                        //fontWeight: FontWeight.bold,
                                                                        color: Colors.white,
                                                                        fontSize: 20,
                                                                        fontWeight: FontWeight.bold,
                                                                        height: 1,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }).toList(),
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
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      children: RelicPart.values.where((rp) => rp != RelicPart.unknown).map((rp) {
                                                        RelicStats rs = cs.relics.containsKey(rp) ? cs.relics[rp]! : RelicStats();
                                                        String mainText = '';
                                                        if (cs.relics.containsKey(rp)) {
                                                          double mv = rs.getMainAttrValue();
                                                          mainText = rs.mainAttr.getPropText(mv);
                                                        }
                                                        return Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 2),
                                                          child: Container(
                                                            width: 350,
                                                            height: 70,
                                                            decoration: BoxDecoration(
                                                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                              //border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                              gradient: LinearGradient(
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                                colors: [
                                                                  getRarityColor(rs.rarity).withOpacity(0.01),
                                                                  getRarityColor(rs.rarity).withOpacity(0.1)
                                                                ],
                                                              )
                                                            ),
                                                            child: Row(
                                                              children: rs.setId != '' ? [
                                                                Container(
                                                                  width: 30,
                                                                  child: OverflowBox(
                                                                    alignment: Alignment.centerLeft,
                                                                    maxWidth: 60,
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                                                                      child: getImageComponent(
                                                                        RelicManager.getRelic(rs.setId).getPartImageUrl(rp),
                                                                        placeholder: kTransparentImage),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 80,
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    children: [
                                                                      if (rs.mainAttr.icon != '')
                                                                        getImageComponent(
                                                                          rs.mainAttr.icon,
                                                                          width: 25,
                                                                          placeholder: kTransparentImage),
                                                                      Text(
                                                                        mainText,
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
                                                                            "${rs.level > 0 ? '+' + rs.level.toString() : ''}",
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
                                                                SizedBox(
                                                                  width: 90,
                                                                  height: 70,
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: rs.subAttrValues.entries.take(2).map((sub) {
                                                                      String subText = sub.key.getPropText(sub.value);
                                                                      return Row(
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(1.0),
                                                                            child: getImageComponent(
                                                                              sub.key.icon,
                                                                              width: 28,
                                                                              placeholder: kTransparentImage),
                                                                          ),
                                                                          Text(
                                                                            subText,
                                                                            style: const TextStyle(
                                                                              //fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                              fontSize: 20,
                                                                              height: 1,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 90,
                                                                  height: 70,
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: rs.subAttrValues.entries.skip(2).take(2).map((sub) {
                                                                      String subText = sub.key.getPropText(sub.value);
                                                                      return Row(
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(1.0),
                                                                            child: getImageComponent(
                                                                              sub.key.icon,
                                                                              width: 28,
                                                                              placeholder: kTransparentImage),
                                                                          ),
                                                                          Text(
                                                                            subText,
                                                                            style: const TextStyle(
                                                                              //fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                              fontSize: 20,
                                                                              height: 1,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                ),
                                                              ] : [],
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
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
                                            await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List? image) async {
                                              var now = DateTime.now();
                                              var dateFormat = DateFormat('yyyyMMddHHmmss');
                                              String timeNow = dateFormat.format(now);
                                              String fileName = c.getName(getLanguageCode(context)) + timeNow;
                                              if (kIsWeb || Platform.isWindows) {
                                                await FileSaver.instance.saveFile(name: fileName, bytes: image!, ext: 'png', mimeType: MimeType.png);
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  duration: Duration(seconds: 3),
                                                  content: Text("Saved".tr() + ((!kIsWeb && Platform.isWindows) ? " to Donwnload folder" : "")),
                                                  action: SnackBarAction(
                                                    label: '×',
                                                    onPressed: () {
                                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                      // Some code to undo the change.
                                                    },
                                                  ),
                                                ));
                                              } else if (Platform.isAndroid || Platform.isIOS) {
                                                XFile shareFile =
                                                    XFile.fromData(image!, mimeType: MimeType.png.name, name: fileName, length: image.lengthInBytes);
                                                ShareResult shareResult = await Share.shareXFiles([shareFile], subject: fileName, text: 'Share Text'.tr());
                                                print("shareStatus: ${shareResult.status.name}, raw: ${shareResult.raw}");
                                                if (shareResult.status == ShareResultStatus.success) {
                                                  String toastText = "";
                                                  if (shareResult.raw.contains('com.apple.UIKit.activity.SaveToCameraRoll')) {
                                                    toastText = 'Saved'.tr();
                                                  } else if (shareResult.raw.contains("com.apple.UIKit.activity.CopyToPasteboard")) {
                                                    toastText = 'Copied'.tr();
                                                  }
                                                  if (toastText.isNotEmpty) {
                                                    Fluttertoast.showToast(
                                                        msg: toastText.tr(),
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.grey,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  }
                                                }
                                              }
                                            });
                                            setState(() {});
                                          },
                                          child: const Text('Save and Share').tr(),
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
}
