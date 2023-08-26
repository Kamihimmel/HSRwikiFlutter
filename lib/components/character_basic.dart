import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../characters/character.dart';
import '../characters/character_entity.dart';
import '../characters/character_manager.dart';
import '../info.dart';
import '../platformad_stub.dart' if (dart.library.io) '../platformad_stub.dart' if (dart.library.html) '../platformad.dart';
import '../utils/helper.dart';
import 'global_state.dart';

/// 角色基本属性
class CharacterBasicState extends State<CharacterBasic> {
  final GlobalState _gs = GlobalState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Character _cData = CharacterManager.getCharacter(_gs.stats.id);
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
                  const SizedBox(
                    height: 110,
                  ),
                  Container(
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
                          gradient:
                              LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_cData.elementType.color.withOpacity(0.35), _cData.elementType.color.withOpacity(0.5)]),
                        ),
                        child: getImageComponent(_cData.getImageUrl(_gs), placeholder: kTransparentImage, fit: BoxFit.cover),
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
                                        "LV:${_gs.stats.level}",
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
                                        value: _cData.entity.leveldata.map((e) => e.level).toList().indexOf(_gs.stats.level).toDouble(),
                                        min: 0,
                                        max: _cData.entity.leveldata.length - 1,
                                        divisions: _cData.entity.leveldata.length,
                                        activeColor: _cData.elementType.color,
                                        inactiveColor: _cData.elementType.color.withOpacity(0.5),
                                        onChanged: (double value) {
                                          setState(() {
                                            _gs.stats.level = _cData.entity.leveldata[value.toInt()].level;
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
                    children: List.generate(_cData.entity.skilldata.length, (index) {
                      final CharacterSkilldata skill = _cData.entity.skilldata[index];
                      String fixedText = "";
                      String detailText = _cData.getSkillDescription(index, getLanguageCode(context));
                      if (skill.maxlevel > 0) {
                        List<Map<String, dynamic>> multiplierData = skill.levelmultiplier;
                        int multiCount = multiplierData.length;
                        fixedText = detailText;
                        for (var i = multiCount; i >= 1; i--) {
                          Map<String, dynamic> currentLeveldata = multiplierData[i - 1];
                          String levelnum = _gs.stats.skillLevels[skill.id]?.toStringAsFixed(0) ?? '0';
                          if (currentLeveldata['default'] == null) {
                            fixedText = fixedText.replaceAll("[$i]", (currentLeveldata[levelnum]).toString());
                          } else {
                            fixedText = fixedText.replaceAll("[$i]", (currentLeveldata['default']).toString());
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
                                      gradient:
                                          LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_cData.elementType.color.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(5, 25, 0, 5),
                                          child: getImageComponent(skill.imageurl, imageWrap: true, width: 60),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                                            child: Column(
                                              children: [
                                                Text(
                                                  _cData.getSkillName(index, getLanguageCode(context)),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                if (skill.maxlevel > 0)
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          child: Text(
                                                            "LV:${_gs.stats.skillLevels[skill.id]}",
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
                                                            value: _gs.stats.skillLevels[skill.id]!.toDouble(),
                                                            min: 1,
                                                            max: skill.maxlevel.toDouble(),
                                                            divisions: skill.maxlevel - 1,
                                                            activeColor: _cData.elementType.color,
                                                            inactiveColor: _cData.elementType.color.withOpacity(0.5),
                                                            onChanged: (double value) {
                                                              setState(() {
                                                                _gs.stats.skillLevels[skill.id] = value.toInt();
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
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              width: 110,
                              decoration: BoxDecoration(
                                color: _cData.elementType.color.withOpacity(0.3),
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(skill.stype,
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
                        ],
                      );
                    }),
                  ),
                  Column(
                    children: List.generate(_cData.entity.tracedata.length, (index) {
                      final CharacterTracedata trace = _cData.entity.tracedata[index];
                      String detailText = _cData.getTraceDescription(index, getLanguageCode(context));

                      if (trace.tiny == false) {
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
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        border: Border.all(color: Colors.white.withOpacity(0.13)),
                                        gradient:
                                            LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_cData.elementType.color.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(5, 25, 0, 5),
                                            child: getImageComponent(trace.imageurl, imageWrap: true, width: 60),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    _cData.getTraceName(index, getLanguageCode(context)),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
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
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                width: 110,
                                decoration: BoxDecoration(
                                  color: _cData.elementType.color.withOpacity(0.3),
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(trace.stype,
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
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            child: SwitchListTile(
                                                activeColor: _cData.elementType.color,
                                                secondary: ImageIcon(
                                                  stattoimage[trace.ttype]!,
                                                  size: 30,
                                                ),
                                                title: Text(
                                                  _cData.getTraceName(index, getLanguageCode(context)),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                subtitle: Text(detailText),
                                                value: (_gs.stats.traceLevels[trace.id] ?? 0) > 0,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    _gs.stats.traceLevels[trace.id] = value ? 1 : 0;
                                                  });
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      }
                    }),
                  ),
                  Column(
                    children: List.generate(_cData.entity.eidolon.length, (index) {
                      final eidolon = _cData.entity.eidolon[index];
                      return Stack(
                        children: [
                          Column(
                            children: [
                              if (eidolon.eidolonnum != 3 && eidolon.eidolonnum != 5)
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        border: Border.all(color: Colors.white.withOpacity(0.13)),
                                        gradient:
                                            LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_cData.elementType.color.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  SwitchListTile(
                                                      activeColor: _cData.elementType.color,
                                                      secondary: getImageComponent(eidolon.imageurl, imageWrap: true, width: 70, fit: BoxFit.contain),
                                                      title: Text(
                                                        _cData.getEidolonName(index, getLanguageCode(context)),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      subtitle: Text(_cData.getEidolonDescription(index, getLanguageCode(context))),
                                                      value: (_gs.stats.eidolons[eidolon.eidolonnum.toString()] ?? 0) > 0,
                                                      onChanged: (bool value) async {
                                                        setState(() {
                                                          _gs.stats.eidolons[eidolon.eidolonnum.toString()] = value ? 1 : 0;
                                                        });
                                                      }),
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
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              width: 110,
                              decoration: BoxDecoration(
                                color: _cData.elementType.color.withOpacity(0.3),
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(eidolon.stype.tr() + eidolon.eidolonnum.toString(),
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
                        ],
                      );
                    }),
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
          ),
        ));
  }
}

class CharacterBasic extends StatefulWidget {
  final isBannerAdReady;
  final bannerAd;

  const CharacterBasic({
    Key? key,
    required this.isBannerAdReady,
    required this.bannerAd,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CharacterBasicState();
  }
}