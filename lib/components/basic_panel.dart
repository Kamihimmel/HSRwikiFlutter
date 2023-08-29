import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../calculator/basic.dart';
import '../characters/character.dart';
import '../characters/character_manager.dart';
import '../utils/helper.dart';
import '../utils/logging.dart';
import 'character_detail.dart';
import 'global_state.dart';
import '../platformad_stub.dart' if (dart.library.io) '../platformad_stub.dart' if (dart.library.html) '../platformad.dart';

/// 角色基础面板
class BasicPanelState extends State<BasicPanel> {
  final GlobalState _gs = GlobalState();

  @override
  void initState() {
    super.initState();
  }

  //ANCHOR method:statbuilder
  Row _buildStatRow(Color color, String source, String valueStr) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.white, width: 0.5),
            color: color,
          ),
          width: 10,
          height: 10,
        ),
        Column(
          children: [
            SelectableText(
              source,
              style: TextStyle(
                fontSize: 10,
                height: 1.1,
              ),
            ),
            SelectableText(
              valueStr,
              style: TextStyle(
                fontSize: 10,
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  //ANCHOR method:statbarbuilder
  Column _buildstatbar(Color color, double value, bool percent, double? scale) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 500),
          width: (value / (scale ?? (percent ? 0.4 : 12))) * _gs.statScale / 10,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 0.5),
            color: color,
          ),
        ),
      ],
    );
  }

  Map<PropSourceDisplay, double> _mergePropValueForDisplay(FightProp prop, Map<PropSource, double> propValues) {
    Map<PropSourceDisplay, double> display = {};
    propValues.forEach((key, value) {
      PropSourceDisplay displayKey = key.getDisplay();
      if (display.containsKey(displayKey)) {
        display[displayKey] = display[displayKey]! + value;
      } else {
        display[displayKey] = value;
      }
    });
    if (prop == FightProp.speed) {
      display.keys.forEach((k) {
        k.scale = 0.5;
      });
    }
    return display;
  }

  List<dynamic> _getBaseAttr(Map<FightProp, Map<PropSource, double>> stats, FightProp prop) {
    double base = stats[prop]?.entries.where((e) => e.key.base).map((e) => e.value).fold(0, (pre, e) => pre! + e) ?? 0;
    double add = stats[prop]?.entries.where((e) => !e.key.base).map((e) => e.value).fold(0, (pre, e) => pre! + e) ?? 0;
    double all = base + add;
    Map<PropSourceDisplay, double> display = _mergePropValueForDisplay(prop, stats[prop] ?? {});
    return [base, add, all, display, prop.isPercent()];
  }

  String _displayText(double value, bool percent) {
    if (percent) {
      return "${(value * 100).toStringAsFixed(1)}%";
    } else {
      return value.toStringAsFixed(1);
    }
  }

  List<Widget> _getAttrPanel(String title, Map<String, List<dynamic>> attrValues) {
    List<Widget> list = [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: SelectableText(
          title.tr(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    ];
    attrValues.forEach((key, value) {
      double base = value[0];
      double add = value[1];
      double all = value[2];
      if (base == 0 && (add == 0 || all == 0)) {
        return;
      }
      Map<PropSourceDisplay, double> display = value[3];
      bool percent = value[4];
      String title = _displayText(all, percent);
      if (base > 0) {
        title = "${_displayText(base, percent)} + ${_displayText(add, percent)} = ${_displayText(all, percent)}";
      }
      list.add(SelectableText(
        "${key.tr()}: $title",
        style: TextStyle(fontSize: 15),
      ));
      list.add(Padding(
        padding: const EdgeInsets.all(10.0),
        child: FractionallySizedBox(
          widthFactor: 1.0,
          child: Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //ANCHOR statATK:stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: display.entries.where((e) => e.value > 0).map((e) {
                      return _buildStatRow(e.key.color, e.key.source, _displayText(e.value, percent));
                    }).toList(),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  //ANCHOR statATK:bar
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    foregroundDecoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.all(0.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: display.entries.where((e) => e.value > 0).map((e) {
                        return _buildstatbar(e.key.color, e.value * (percent ? 100 : 1), percent, e.key.scale);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    });
    return list;
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
          Map<FightProp, Map<PropSource, double>> stats = _gs.stats.calculateStats();

          Map<String, List<dynamic>> baseAttrs = {};
          baseAttrs[FightProp.attack.desc] = _getBaseAttr(stats, FightProp.attack);
          baseAttrs[FightProp.maxHP.desc] = _getBaseAttr(stats, FightProp.maxHP);
          baseAttrs[FightProp.defence.desc] = _getBaseAttr(stats, FightProp.defence);
          baseAttrs[FightProp.speed.desc] = _getBaseAttr(stats, FightProp.speed);
          baseAttrs[FightProp.sPRatio.desc] = _getBaseAttr(stats, FightProp.sPRatio);

          Map<String, List<dynamic>> critAttrs = {};
          critAttrs[FightProp.criticalChance.desc] = _getBaseAttr(stats, FightProp.criticalChance);
          critAttrs[FightProp.criticalDamage.desc] = _getBaseAttr(stats, FightProp.criticalDamage);

          Map<String, List<dynamic>> otherAttrs = {};
          otherAttrs[FightProp.statusResistance.desc] = _getBaseAttr(stats, FightProp.statusResistance);
          otherAttrs[FightProp.statusProbability.desc] = _getBaseAttr(stats, FightProp.statusProbability);
          otherAttrs[FightProp.breakDamageAddedRatio.desc] = _getBaseAttr(stats, FightProp.breakDamageAddedRatio);

          Map<String, List<dynamic>> damageAttrs = {};
          damageAttrs[FightProp.allDamageAddRatio.desc] = _getBaseAttr(stats, FightProp.allDamageAddRatio);
          for (FightProp p in elementDamage.values) {
            damageAttrs[p.desc] = _getBaseAttr(stats, p);
          }

          Map<String, List<dynamic>> healAttrs = {};
          healAttrs[FightProp.healRatio.desc] = _getBaseAttr(stats, FightProp.healRatio);

          return Container(
            height: screenWidth > 905 ? screenHeight - 100 : null,
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                            children: _getAttrPanel('Basic Panel', baseAttrs),
                          ),
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
                            children: _getAttrPanel('Critical Panel', critAttrs),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (damageAttrs.values.where((e) => e[2] > 0).isNotEmpty)
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
                              children: _getAttrPanel('Damage Bonus Panel', damageAttrs),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (healAttrs.values.where((e) => e[2] > 0).isNotEmpty)
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
                              children: _getAttrPanel('Heal Bonus Panel', healAttrs),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (otherAttrs.values.where((e) => e[2] > 0).isNotEmpty)
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
                              children: _getAttrPanel('Other Panel', otherAttrs),
                            ),
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
                              SizedBox(height: 10),
                              SelectableText(
                                'Enemy Panel'.tr(),
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SelectableText(
                                    '${"Enemytype".tr()}: ',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  Container(
                                    height: 50.0,
                                    child: DropdownButton(
                                        value: _gs.enemyStats.type,
                                        items: [
                                          for (var k in enemyData.keys)
                                            DropdownMenuItem(
                                              child: Text(
                                                (enemyData[k]?['name'] as String).tr(),
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              value: k,
                                            ),
                                        ],
                                        onChanged: (value) {
                                          _gs.enemyStats.type = value!;
                                          _gs.enemyStats = _gs.enemyStats;
                                        }),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: List.generate(ElementType.values.where((e) => e != ElementType.diy).length, (index) {
                                  ElementType et = ElementType.values.where((e) => e != ElementType.diy).toList()[index];
                                  return Column(
                                    children: [
                                      if (index != 0) SizedBox(width: 15),
                                      Column(
                                        children: [
                                          getImageComponent(et.icon, imageWrap: true, width: 30),
                                          SelectableText(
                                            '${(enemyData[_gs.enemyStats.type]!['resistence'] as Map<ElementType, int>)[et] ?? 0}',
                                            style: TextStyle(
                                              fontSize: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SelectableText(
                                      '${"EnemyLv".tr()}: ${_gs.enemyStats.level}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        height: 1.1,
                                      ),
                                    ),
                                    Slider(
                                      min: 1,
                                      max: 90,
                                      inactiveColor: Theme.of(context).colorScheme.secondary,
                                      label: _gs.enemyStats.level.toString(),
                                      value: _gs.enemyStats.level.toDouble(),
                                      onChanged: (value) {
                                        _gs.enemyStats.level = value.toInt();
                                        _gs.enemyStats = _gs.enemyStats;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SelectableText(
                                      '${"EnemyDefenceDebuff".tr()}%: ${_gs.enemyStats.defenceReduce}%',
                                      style: TextStyle(
                                        fontSize: 15,
                                        height: 1.1,
                                      ),
                                    ),
                                    Slider(
                                      min: 0,
                                      max: 100,
                                      inactiveColor: Theme.of(context).colorScheme.secondary,
                                      label: _gs.enemyStats.defenceReduce.toString(),
                                      value: _gs.enemyStats.defenceReduce.toDouble(),
                                      onChanged: (value) {
                                        _gs.enemyStats.defenceReduce = value.toInt();
                                        _gs.enemyStats = _gs.enemyStats;
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
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

class BasicPanel extends StatefulWidget {
  final isBannerAdReady;
  final bannerAd;

  const BasicPanel({
    Key? key,
    required this.isBannerAdReady,
    required this.bannerAd,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BasicPanelState();
  }
}
