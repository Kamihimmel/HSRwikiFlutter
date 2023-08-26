import 'dart:ui';

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
  }

  Row _getSubAttrRow(FightProp prop, double value) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: getImageComponent(prop.icon, placeholder: kTransparentImage, width: 28),
        ),
        Text(
          "${prop.isPercent() ? (value * 100).toStringAsFixed(1) + '%' : value.toStringAsFixed(0)}",
          style: const TextStyle(
            //fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
            height: 1,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Character _cData = CharacterManager.getCharacter(_gs.stats.id);
    final Lightcone _lData = LightconeManager.getLightcone(_gs.stats.lightconeId);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final columnwidth = screenWidth > 1440
        ? screenWidth / 4
        : screenWidth > 905
            ? screenWidth / 2
            : screenWidth;
    return ChangeNotifierProvider.value(
        value: _gs.getCharacterStats(),
        child: Consumer<CharacterStatsNotify>(
            builder: (context, model, child) => Container(
                  height: screenWidth > 905 ? screenHeight - 100 : null,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 200,
                          height: 200,
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
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
                              child: getImageComponent(_lData.entity.imageurl, placeholder: kTransparentImage, fit: BoxFit.cover),
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
                                                setState(() {
                                                  _gs.stats.lightconeLevel = _lData.entity.leveldata[value.toInt()].level;
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
                          ),
                        ),
                        Column(
                          children: List.generate(_lData.entity.skilldata.length, (index) {
                            final LightconeSkilldata skill = _lData.entity.skilldata[index];
                            String fixedText = "";
                            String detailText = _lData.getSkillDescription(index, getLanguageCode(context));
                            if (skill.maxlevel > 0) {
                              List<Map<String, dynamic>> multiplierData = skill.levelmultiplier;
                              int multiCount = multiplierData.length;
                              fixedText = detailText;
                              for (var i = multiCount; i >= 1; i--) {
                                Map<String, dynamic> currentleveldata = multiplierData[i - 1];
                                String levelnum = _gs.stats.lightconeRank.toString();
                                if (currentleveldata['default'] == null) {
                                  fixedText = fixedText.replaceAll("[$i]", (currentleveldata[levelnum]).toString());
                                } else {
                                  fixedText = fixedText.replaceAll("[$i]", (currentleveldata['default']).toString());
                                }
                              }
                            } else {
                              fixedText = detailText;
                            }

                            return Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                                                  setState(() {
                                                                    _gs.stats.lightconeRank = value.toInt();
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
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                        ),
                        //ANCHOR - relicselect
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(3, (index) {
                            List<String> sets = _gs.stats.getRelicSets();
                            List<String> defaultSets = CharacterManager.getDefaultRelicSets(_gs.stats.id);
                            String imageUrl;
                            if (sets.length > index && sets[index] != '0') {
                              imageUrl = RelicManager.getRelic(sets[index]).entity.imageurl;
                            } else {
                              imageUrl = RelicManager.getRelic(defaultSets[index]).entity.imageurl;
                            }
                            return Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
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
                            );
                          }),
                        ),
                        //ANCHOR - relics
                        Column(
                          children: RelicPart.values.where((e) => e != RelicPart.unknown).map((e) {
                            RelicStats rs = _gs.stats.relics[e] ?? RelicStats.empty(e);
                            logger.i(rs.mainAttr.name);
                            double mainAttrValue = getRelicMainAttrValue(rs.mainAttr, rs.rarity, rs.level);
                            return Padding(
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
                                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                                      border: Border.all(color: Colors.white.withOpacity(0.13)),
                                      gradient:
                                          LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_cData.elementType.color.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
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
                                                  width: 30,
                                                  child: OverflowBox(
                                                    alignment: Alignment.centerLeft,
                                                    maxWidth: 60,
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                                                      child: getImageComponent(rs.setId == '' ? '' : RelicManager.getRelic(rs.setId).entity.imageurl, placeholder: kTransparentImage, width: 60),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 120,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      getImageComponent(rs.mainAttr.icon, placeholder: kTransparentImage, width: 25),
                                                      Text(
                                                        "${rs.mainAttr.isPercent() ? (mainAttrValue * 100).toStringAsFixed(1) + '%' : mainAttrValue.toStringAsFixed(0)}",
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
                                                      children: rs.subAttrValues.entries.take(2).map((sub) {
                                                        return _getSubAttrRow(sub.key, sub.value);
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
                                                      children: rs.subAttrValues.entries.skip(2).take(2).map((sub) {
                                                        return _getSubAttrRow(sub.key, sub.value);
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
                )));
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
