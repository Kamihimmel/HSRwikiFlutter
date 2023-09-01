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

  /// 将group相同的effect放到一组，展示为一个伤害/治疗/护盾
  Map<String, List<EffectEntity>> _groupEffect(List<EffectEntity> effects, String type) {
    Map<String, List<EffectEntity>> effectGroup = {};
    effects.where((e) => e.type == type).forEach((e) {
      if (e.group != '') {
        List<EffectEntity> list = effectGroup[e.group] ?? [];
        list.add(e);
        effectGroup[e.group] = list;
      } else {
        // key不重复就行，随便构造的
        effectGroup["${DateTime.now().millisecondsSinceEpoch}-${e.hashCode}"] = [e];
      }
    });
    return effectGroup;
  }

  void _appendDamageAndTitle(List<EffectEntity> effects, List<String> multiplierTitle, String type, List<DamageResult> drList, String stype, Character character, CharacterSkilldata? skilldata, int? skillLevel) {
    effects.forEach((e) {
      double multiplierValue = getEffectMultiplierValue(e, skilldata, skillLevel);
      if (e.multipliertarget == '') {
        multiplierTitle.add(multiplierValue.toString());
      } else {
        multiplierTitle.add("${multiplierValue.toStringAsFixed(1)}%");
      }
      FightProp multiplierProp = FightProp.fromEffectMultiplier(e.multipliertarget);
      if (type == 'dmg') {
        drList.add(calculateDamage(_gs.stats, _gs.enemyStats, multiplierValue, multiplierProp,
            stype, DamageType.fromEffectTags(e.tag), character.elementType));
      } else if (type == 'heal') {
        drList.add(calculateHeal(_gs.stats, multiplierValue, multiplierProp));
      } else if (type == 'shield') {
        drList.add(calculateShield(_gs.stats, multiplierValue, multiplierProp));
      } else {
        drList.add(DamageResult.zero());
      }
    });
  }

  List<Widget> _getDamageHealPanels(Character character, String type) {
    return character.entity.skilldata.where((skill) => skill.effect.any((e) => e.type == type && e.multiplier > 0)).map((skill) {
      CharacterSkilldata skillData = character.entity.skilldata.firstWhere((s) => s.id == skill.id, orElse: () => CharacterSkilldata());
      int skillLevel = _gs.stats.skillLevels[skill.id] ?? 1;
      String skillName = character.getSkillNameById(skill.id, getLanguageCode(context));
      String title = "${skillName} (Lv${skillLevel})";
      Map<String, List<EffectEntity>> skillEffectGroup = _groupEffect(skillData.effect, type);
      return ExpansionTile(
        tilePadding: EdgeInsets.only(left: 5, right: 5),
        childrenPadding: EdgeInsets.all(5),
        initiallyExpanded: true,
        title: _buildDamageBar(title, character.elementType, null),
        children: skillEffectGroup.values.map((effects) {
          EffectEntity effect = effects.first;
          String title = "${effect.tag.map((e) => e.tr()).join(" | ")}";
          List<DamageResult> drList = [];
          List<String> multiplierTitle = [];
          _appendDamageAndTitle(effects, multiplierTitle, type, drList, skillData.stype, character, skillData, skillLevel);
          title += " (${multiplierTitle.join(' + ')})";
          DamageResult dr = drList.fold(DamageResult.zero(), (pre, damage) =>
              DamageResult(pre.nonCrit + damage.nonCrit, pre.expectation + damage.expectation, pre.crit + damage.crit));
          return _buildDamageBar(title, character.elementType, dr);
        }).toList(),
      );
    }).toList() + character.entity.tracedata.where((trace) => (_gs.stats.traceLevels[trace.id] ?? 0) > 0 && trace.effect.any((e) => e.type == type && e.multiplier > 0)).map((trace) {
      CharacterTracedata traceData = character.entity.tracedata.firstWhere((s) => s.id == trace.id, orElse: () => CharacterTracedata());
      String traceName = character.getTraceNameById(trace.id, getLanguageCode(context));
      String title = "${traceName}";
      Map<String, List<EffectEntity>> traceEffectGroup = _groupEffect(traceData.effect, type);
      return ExpansionTile(
        tilePadding: EdgeInsets.only(left: 5, right: 5),
        childrenPadding: EdgeInsets.all(5),
        initiallyExpanded: true,
        title: _buildDamageBar(title, character.elementType, null),
        children: traceEffectGroup.values.map((effects) {
          EffectEntity effect = effects.first;
          String title = "${effect.tag.map((e) => e.tr()).join(" | ")}";
          List<DamageResult> drList = [];
          List<String> multiplierTitle = [];
          _appendDamageAndTitle(effects, multiplierTitle, type, drList, traceData.stype, character, null, null);
          title += " (${multiplierTitle.join(' + ')})";
          DamageResult dr = drList.fold(DamageResult.zero(), (pre, damage) =>
              DamageResult(pre.nonCrit + damage.nonCrit, pre.expectation + damage.expectation, pre.crit + damage.crit));
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
          List<Widget> healPanels = _getDamageHealPanels(_cData, 'heal');
          List<Widget> shieldPanels = _getDamageHealPanels(_cData, 'shield');
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
