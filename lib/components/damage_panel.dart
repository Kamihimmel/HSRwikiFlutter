import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hsrwikiproject/calculator/basic.dart';
import 'package:hsrwikiproject/calculator/effect_entity.dart';
import 'package:provider/provider.dart';

import '../calculator/calculator.dart';
import '../characters/character.dart';
import '../characters/character_entity.dart';
import '../characters/character_manager.dart';
import '../utils/helper.dart';
import 'global_state.dart';
import '../platformad_stub.dart' if (dart.library.io) '../platformad_stub.dart' if (dart.library.html) '../platformad.dart';

/// 技能伤害面板
class DamagePanelState extends State<DamagePanel> {
  final GlobalState _gs = GlobalState();

  @override
  void initState() {
    super.initState();
  }

  FractionallySizedBox _buildDamageBar(String title, ElementType elementType, DamageResult? damageResult) {
    return FractionallySizedBox(
      widthFactor: 1.0,
      child: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                SelectableText(
                  title,
                  style: TextStyle(
                    fontSize: damageResult != null ? 15 : 17,
                    height: 1.1,
                    fontWeight: damageResult != null ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
              ]),
              if (damageResult != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SelectableText(
                      'Non-Crit'.tr() + ':',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.1,
                      ),
                    ),
                    SelectableText(
                      double.parse(damageResult.nonCrit.toStringAsFixed(1)).toString(),
                      style: TextStyle(
                        color: elementType.color[300],
                        fontSize: 15,
                      ),
                    ),
                    if (damageResult.expectation > 0)
                      SelectableText(
                        'Expectation'.tr() + ':',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.1,
                        ),
                      ),
                    if (damageResult.expectation > 0)
                      SelectableText(
                        double.parse(damageResult.expectation.toStringAsFixed(1)).toString(),
                        style: TextStyle(
                          color: elementType.color[500],
                          fontSize: 15,
                        ),
                      ),
                    if (damageResult.crit > 0)
                      SelectableText(
                        'Crit'.tr() + ':',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.1,
                        ),
                      ),
                    if (damageResult.crit > 0)
                      SelectableText(
                        double.parse(damageResult.crit.toStringAsFixed(1)).toString(),
                        style: TextStyle(
                          color: elementType.color[700],
                          fontSize: 15,
                          height: 1.1,
                        ),
                      ),
                  ],
                ),
              if (damageResult != null)
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
                    children: [
                      Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          AnimatedContainer(
                            curve: Curves.easeIn,
                            duration: Duration(milliseconds: 500),
                            width: damageResult.crit / 50 * _gs.dmgScale / 10,
                            height: 20,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 0.5),
                              color: elementType.color[700],
                            ),
                          ),
                          AnimatedContainer(
                            curve: Curves.easeIn,
                            duration: Duration(milliseconds: 500),
                            width: damageResult.expectation / 50 * _gs.dmgScale / 10,
                            height: 20,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 0.5),
                              color: elementType.color[500],
                            ),
                          ),
                          AnimatedContainer(
                            curve: Curves.easeIn,
                            duration: Duration(milliseconds: 500),
                            width: damageResult.nonCrit / 50 * _gs.dmgScale / 10,
                            height: 20,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 0.5),
                              color: elementType.color[300],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getDamageHealPanels(Character character, String type) {
    return character.entity.skilldata.where((skill) => skill.effect.any((e) => e.type == type && e.multiplier > 0)).map((skill) {
      CharacterSkilldata skillData = character.entity.skilldata.firstWhere((s) => s.id == skill.id, orElse: () => CharacterSkilldata());
      int skillLevel = _gs.stats.skillLevels[skill.id] ?? 1;
      String skillName = character.getSkillNameById(skill.id, getLanguageCode(context));
      String title = "${skillName} (Lv${skillLevel})";
      return ExpansionTile(
        tilePadding: EdgeInsets.only(left: 5, right: 5),
        childrenPadding: EdgeInsets.all(5),
        initiallyExpanded: true,
        title: _buildDamageBar(title, character.elementType, null),
        children: skillData.effect.where((e) => e.type == type).map((e) {
          double multiplierValue = getSkillEffectMultiplierValue(e, skillData, skillLevel);
          String title;
          if (e.multipliertarget == '') {
            title = "${e.tag.map((e) => e.tr()).join(" | ")} (${multiplierValue.toString()})";
          } else {
            title = "${e.tag.map((e) => e.tr()).join(" | ")} (${multiplierValue.toStringAsFixed(1)}%)";
          }
          DamageResult dr;
          if (type == 'dmg') {
            dr = calculateDamage(_gs.stats, _gs.enemyStats, multiplierValue,
                e.multipliertarget == '' ? null : FightProp.fromEffectMultiplier(e.multipliertarget),
                skillData.stype, DamageType.fromEffectTags(e.tag), character.elementType);
          } else if (type == 'heal') {
            dr = calculateHeal(_gs.stats, multiplierValue,
                e.multipliertarget == '' ? null : FightProp.fromEffectMultiplier(e.multipliertarget));
          } else if (type == 'shield') {
            dr = calculateShield(_gs.stats, multiplierValue,
                e.multipliertarget == '' ? null : FightProp.fromEffectMultiplier(e.multipliertarget));
          } else {
            dr = DamageResult.zero();
          }
          return _buildDamageBar(title, character.elementType, dr);
        }).toList(),
      );
    }).toList() + character.entity.tracedata.where((trace) => (_gs.stats.traceLevels[trace.id] ?? 0) > 0 && trace.effect.any((e) => e.type == type && e.multiplier > 0)).map((trace) {
      CharacterTracedata traceData = character.entity.tracedata.firstWhere((s) => s.id == trace.id, orElse: () => CharacterTracedata());
      String traceName = character.getTraceNameById(trace.id, getLanguageCode(context));
      String title = "${traceName}";
      return ExpansionTile(
        tilePadding: EdgeInsets.only(left: 5, right: 5),
        childrenPadding: EdgeInsets.all(5),
        initiallyExpanded: true,
        title: _buildDamageBar(title, character.elementType, null),
        children: traceData.effect.where((e) => e.type == type).map((e) {
          double multiplierValue = e.multiplier;
          String title;
          if (e.multipliertarget == '') {
            title = "${e.tag.map((e) => e.tr()).join(" | ")} (${multiplierValue.toString()})";
          } else {
            title = "${e.tag.map((e) => e.tr()).join(" | ")} (${multiplierValue.toStringAsFixed(1)}%)";
          }
          DamageResult dr;
          if (type == 'dmg') {
            dr = calculateDamage(_gs.stats, _gs.enemyStats, multiplierValue,
                e.multipliertarget == '' ? null : FightProp.fromEffectMultiplier(e.multipliertarget),
                traceData.stype, DamageType.fromEffectTags(e.tag), character.elementType);
          } else if (type == 'heal') {
            dr = calculateHeal(_gs.stats, multiplierValue,
                e.multipliertarget == '' ? null : FightProp.fromEffectMultiplier(e.multipliertarget));
          } else {
            dr = DamageResult.zero();
          }
          return _buildDamageBar(title, character.elementType, dr);
        }).toList(),
      );
    }).toList();
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
          List<Widget> damagePanels = _getDamageHealPanels(_cData, 'dmg');
          List<Widget> healPanels = _cData.pathType == PathType.abundance ? _getDamageHealPanels(_cData, 'heal') : [];
          List<Widget> shieldPanels = _cData.pathType == PathType.preservation ? _getDamageHealPanels(_cData, 'shield') : [];
          return Container(
            height: screenWidth > 905 ? screenHeight - 100 : null,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (damagePanels.isNotEmpty)
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
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [_cData.elementType.color.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SelectableText(
                                    'Damage Panel'.tr(),
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Column(
                                  children: damagePanels,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (healPanels.isNotEmpty)
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
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [_cData.elementType.color.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SelectableText(
                                    'Heal Panel'.tr(),
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Column(
                                  children: healPanels,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (shieldPanels.isNotEmpty)
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
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [_cData.elementType.color.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SelectableText(
                                    'Shield Panel'.tr(),
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Column(
                                  children: shieldPanels,
                                ),
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

class DamagePanel extends StatefulWidget {
  final isBannerAdReady;
  final bannerAd;

  const DamagePanel({
    Key? key,
    required this.isBannerAdReady,
    required this.bannerAd,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DamagePanelState();
  }
}
