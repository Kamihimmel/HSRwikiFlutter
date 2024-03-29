import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../calculator/basic.dart';
import '../calculator/effect.dart';
import '../calculator/effect_manager.dart';
import '../calculator/skill_data.dart';
import '../characters/character.dart';
import '../characters/character_manager.dart';
import '../lightcones/lightcone.dart';
import '../lightcones/lightcone_manager.dart';
import '../relics/relic.dart';
import '../relics/relic_manager.dart';
import '../utils/helper.dart';
import '../utils/logging.dart';
import 'global_state.dart';

/// buff面板
class BuffPanelState extends State<BuffPanel> {
  final GlobalState _gs = GlobalState();

  @override
  void initState() {
    super.initState();
  }

  Widget _getEffectChip(Map<String, EffectConfig> effectConfig, List<Effect> effects, {defaultOn = true}) {
    final Character _cData = CharacterManager.getCharacter(_gs.stats.id);
    final Effect effect = effects.first;
    String effectKey = effect.getKey();
    FightProp prop = FightProp.fromEffectKey(effect.entity.addtarget);
    int skillLevel = effect.skillData.maxlevel;
    if (effect.isCharacterType()) {
      if (effect.majorId == _gs.stats.id) {
        // 当前角色自己
        if (_gs.stats.skillLevels.containsKey(effect.minorId)) {
          skillLevel = _gs.stats.skillLevels[effect.minorId]!;
        }
        if (effect.skillData.referencelevel != '') {
          // 如果是引用其他技能的等级
          skillLevel = _gs.stats.skillLevels[_cData.getSkillById(effect.skillData.referencelevel).id] ?? 1;
        }
      } else {
        // 他人buff
        if (effect.skillData.maxlevel > 10) {
          skillLevel = 10;
        } else if (effect.skillData.maxlevel > 1) {
          skillLevel = 6;
        }
      }
    } else if (effect.isLightconeType()) {
      skillLevel = _gs.stats.lightconeRank;
    }
    String propText = '';
    List<String> propValue = [];
    bool isDmg = effect.isDamageHealShield();
    if (!isDmg) {
      propText = prop.desc.tr();
      effects.forEach((e) {
        EffectConfig? effectConf = effectConfig[e.getKey()];
        // 如果有依赖的属性但是又不需要填写，那么说明是依赖自身已计算的属性
        if (e.hasDependProp() && !e.showDependPropValueConfig(_gs.stats.id)) {
          bool on = effectConf?.on ?? defaultOn;
          effectConf = EffectConfig.defaultOn();
          effectConf.on = on;
          FightProp dependProp = FightProp.fromEffectKey(e.entity.multipliertarget);
          Map<PropSource, double> statsResult = _gs.stats.getPropValue(dependProp);
          // 排除所有依赖此属性的值
          double ecValue = statsResult.entries.where((entry) => !entry.key.effect.hasDependProp() || entry.key.effect.showDependPropValueConfig(_gs.stats.id)).map((entry) => entry.value).fold(0, (pre, v) => pre + v);
          effectConf.value = dependProp.isPercent() ? ecValue * 100 : ecValue;
        }
        double multiplierValue = e.getEffectMultiplierValue(effect.skillData, skillLevel, effectConf);
        propValue.add(prop.getPropText(multiplierValue));
      });
    }
    String text = [effect.getSkillName(getLanguageCode(context)), propText, propValue.join(' + ')].join(' ');
    EffectConfig ec = effectConfig[effectKey] ?? (defaultOn ? EffectConfig.defaultOn() : EffectConfig.defaultOff());
    FilterChip chip = FilterChip(
      backgroundColor: _cData.elementType.color.withOpacity(0.3),
      selectedColor: _cData.elementType.color.withOpacity(0.5),
      label: Tooltip(
        message: '',
        child: Text(text),
        preferBelow: false,
      ),
      selected: isDmg || ec.on,
      onSelected: (bool value) {
        ec.on = value;
        effectConfig[effectKey] = ec;
        _gs.changeStats();
      },
    );

    FightProp multiplierProp = FightProp.fromEffectKey(effect.entity.multipliertarget);
    String labelText = '';
    if (multiplierProp != FightProp.unknown && effect.isCharacterType()) {
      List<String> label = [];
      if (effect.isCharacterType()) {
        if (_gs.stats.id != effect.majorId) {
          label.add(CharacterManager.getCharacter(effect.majorId).getName('lang'.tr()));
        }
        label.add("${multiplierProp.desc.tr()}${multiplierProp.isPercent() ? '(%)' : ''}");
      }
      labelText = label.join(' ');
    }
    if (effect.hasBuffConfig(_gs.stats.id)) {
      List<Widget> widgets = [];
      if (effect.hasValueFieldConfig(_gs.stats.id)) {
        widgets = [
          Container(
            width: 150,
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: labelText,
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.outline)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2))),
              initialValue: ec.value.toStringAsFixed(1),
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
                signed: false,
              ),
              onChanged: (value) {
                ec.value = double.tryParse(value) ?? 0;
                effectConfig[effectKey] = ec;
                _gs.changeStats();
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final text = newValue.text;
                  double? tryDouble = double.tryParse(text);
                  return text.isEmpty
                      ? newValue
                      : tryDouble == null
                          ? oldValue
                          : newValue;
                }),
              ],
            ),
          ),
        ];
      } else {
        int stack = ec.stack == 0 ? effect.entity.maxStack : ec.stack;
        if (effect.hasStackConfig()) {
          widgets = [
            DropdownMenu(
              label: Text("${'Stacks'.tr()}:$stack"),
              initialSelection: effect.entity.maxStack,
              dropdownMenuEntries: [
                for (int i = 1; i < effect.entity.maxStack + 1; i++)
                  DropdownMenuEntry(
                    value: i,
                    label: i.toString(),
                  ),
              ],
              onSelected: (value) {
                ec.stack = value!;
                effectConfig[effectKey] = ec;
                _gs.changeStats();
              },
            ),
          ];
        } else if (effect.hasChoiceConfig()) {
          widgets = [
            Text("${'Stacks'.tr()}:$stack"),
            Wrap(
              children: [
                for (var i = 1; i <= effect.entity.maxStack; i++)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: ChoiceChip(
                      backgroundColor: _cData.elementType.color.withOpacity(0.3),
                      selectedColor: _cData.elementType.color.withOpacity(0.5),
                      label: Text(i.toString()),
                      selected: stack == i,
                      onSelected: (value) {
                        ec.stack = i;
                        effectConfig[effectKey] = ec;
                        _gs.changeStats();
                      },
                    ),
                  ),
              ],
            ),
          ];
        }
      }
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          chip,
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: widgets,
          ),
        ],
      );
    } else {
      return chip;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600
        ? 4
        : screenWidth < 1000
            ? 6
            : 8;
    return ChangeNotifierProvider.value(
        value: _gs,
        child: Consumer<GlobalState>(builder: (context, model, child) {
          final Character _cData = CharacterManager.getCharacter(_gs.stats.id);
          final Lightcone _lData = LightconeManager.getLightcone(_gs.stats.lightconeId);
          final List<Relic> _rList = _gs.stats.getRelicSets().map((r) => r != '' ? RelicManager.getRelic(r) : Relic()).toList();
          List<Effect> breakEffects = EffectManager.getBreakDamageEffects(_gs.stats, _gs.enemyStats);
          List<Effect> skillEffects = _cData.entity.skilldata.expand((skill) => skill.effect.map((e) => Effect.fromEntity(e, _cData.entity.id, skill.id))).toList();
          List<Effect> characterSkillDmg = (breakEffects + skillEffects).where((e) => (e.validDamageHealEffect('break') || e.validDamageHealEffect('dmg')) && e.hasBuffConfig(_cData.entity.id)).toList();
          List<Effect> characterSkillBuff =
              _cData.entity.skilldata.expand((skill) => skill.effect.map((e) => Effect.fromEntity(e, _cData.entity.id, skill.id))).where((e) => e.validSelfBuffEffect(null)).toList();
          List<Effect> characterTraceBuff = _cData.entity.tracedata
              .expand((trace) => trace.effect.map((e) => Effect.fromEntity(e, _cData.entity.id, trace.id)).where((e) => !trace.tiny))
              .where((e) => e.validSelfBuffEffect(null))
              .toList();
          List<Effect> characterEidolonBuff = _cData.entity.eidolon
              .expand((eidolon) => eidolon.effect
                  .map((e) => Effect.fromEntity(e, _cData.entity.id, eidolon.id))
                  .where((e) => (_gs.stats.eidolons[eidolon.eidolonnum.toString()] ?? 0) > 0))
              .where((e) => e.validSelfBuffEffect(null))
              .toList();
          List<Effect> lightconeSkillBuff = _lData.entity.skilldata
              .expand((skill) => skill.effect.map((e) => Effect.fromEntity(e, _lData.entity.id, '', type: Effect.lightconeType)).where((e) => e.validSelfBuffEffect(null)))
              .toList();
          List<Effect> relicSkillBuff = List.generate(3, (index) {
            Relic relic = _rList[index];
            String setId = relic.entity.id;
            SkillData skillData = SkillData();
            int skillIndex = 0; // 0: set2; 1: set4
            String setNum = '2';
            if (index == 1 && setId == _rList[0].entity.id) {
              skillIndex = 1;
              setNum = '4';
            }
            if (relic.entity.skilldata.length > skillIndex) {
              skillData = relic.getSkill(skillIndex);
            }
            return Record.of(skillData, Record.of(setId, setNum));
          }).expand((record) => record.key.effect.map((e) => Effect.fromEntity(e, record.value.key, record.value.value, type: Effect.relicType))).where((e) => e.validSelfBuffEffect(null)).toList();
          Map<FightProp, List<Effect>> unsortedGroupOther = {};
          EffectManager.getEffects().values.where((e) => _cData.entity.id != e.majorId && e.validAllyBuffEffect(null)).forEach((e) {
            FightProp fp = FightProp.fromEffectKey(e.entity.addtarget);
            List<Effect> list = unsortedGroupOther[fp] ?? [];
            list.add(e);
            unsortedGroupOther[fp] = list;
          });
          List<FightProp> sortedProps = FightProp.sortByBuffOrder(unsortedGroupOther.keys.toList());
          Map<FightProp, List<List<Effect>>> sortedGroupOther = {};
          sortedProps.forEach((prop) {
            sortedGroupOther[prop] = Effect.groupEffect(unsortedGroupOther[prop]!).values.toList();
          });
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(color: Colors.white.withOpacity(0.13)),
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_cData.elementType.color.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
                  ),
                  child: Column(children: [
                    SizedBox(height: 10),
                    SelectableText(
                      'Buff Panel'.tr(),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    if (characterSkillDmg.isNotEmpty || characterSkillBuff.isNotEmpty || characterTraceBuff.isNotEmpty || characterEidolonBuff.isNotEmpty)
                      ExpansionTile(
                          tilePadding: EdgeInsets.only(left: 10, right: 5),
                          childrenPadding: EdgeInsets.all(5),
                          initiallyExpanded: true,
                          title: Text(
                            "Character Buff".tr(),
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            if (characterSkillDmg.isNotEmpty || characterSkillBuff.isNotEmpty) ...[
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Character Skill Buff".tr(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: Effect.groupEffect(characterSkillDmg).values.map((effects) {
                                  Effect effect = effects.first;
                                  if (effect.isCharacterType()) {
                                    effect.skillData = CharacterManager.getCharacter(effect.majorId).getSkillById(effect.minorId);
                                  }
                                  return _getEffectChip(_gs.stats.damageEffect, effects);
                                }).toList(),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: Effect.groupEffect(characterSkillBuff).values.map((effects) {
                                  Effect effect = effects.first;
                                  effect.skillData = CharacterManager.getCharacter(effect.majorId).getSkillById(effect.minorId);
                                  return _getEffectChip(_gs.stats.selfSkillEffect, effects);
                                }).toList(),
                              ),
                            ],
                            if (characterTraceBuff.isNotEmpty) ...[
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Character Trace Buff".tr(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: Effect.groupEffect(characterTraceBuff).values.map((effects) {
                                  Effect effect = effects.first;
                                  effect.skillData = CharacterManager.getCharacter(effect.majorId).getTraceById(effect.minorId);
                                  return _getEffectChip(_gs.stats.selfTraceEffect, effects);
                                }).toList(),
                              ),
                            ],
                            if (characterEidolonBuff.isNotEmpty) ...[
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Character Eidolon Buff".tr(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: Effect.groupEffect(characterEidolonBuff).values.map((effects) {
                                  Effect effect = effects.first;
                                  effect.skillData = CharacterManager.getCharacter(effect.majorId).getEidolonById(effect.minorId);
                                  return _getEffectChip(_gs.stats.selfEidolonEffect, effects);
                                }).toList(),
                              )
                            ],
                          ]),
                    if (lightconeSkillBuff.isNotEmpty)
                      ExpansionTile(
                        tilePadding: EdgeInsets.only(left: 10, right: 5),
                        childrenPadding: EdgeInsets.all(5),
                        initiallyExpanded: true,
                        title: Text(
                          "Lightcone Skill Buff".tr(),
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: Effect.groupEffect(lightconeSkillBuff).values.map((effects) {
                              Effect effect = effects.first;
                              effect.skillData = LightconeManager.getLightcone(effect.majorId).getSkill();
                              return _getEffectChip(_gs.stats.lightconeEffect, effects);
                            }).toList(),
                          )
                        ],
                      ),
                    if (relicSkillBuff.isNotEmpty)
                      ExpansionTile(
                        tilePadding: EdgeInsets.only(left: 10, right: 5),
                        childrenPadding: EdgeInsets.all(5),
                        initiallyExpanded: true,
                        title: Text(
                          "Relic Skill Buff".tr(),
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: Effect.groupEffect(relicSkillBuff).values.map((effects) {
                              Effect effect = effects.first;
                              effect.skillData = RelicManager.getRelic(effect.majorId).getSkill(effect.minorId == '2' ? 0 : 1);
                              return _getEffectChip(_gs.stats.relicEffect, effects);
                            }).toList(),
                          ),
                        ],
                      ),
                    ExpansionTile(
                      tilePadding: EdgeInsets.only(left: 10, right: 5),
                      childrenPadding: EdgeInsets.all(5),
                      initiallyExpanded: false,
                      title: Text(
                        "Other Buff".tr(),
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      children: sortedGroupOther.entries.map((entry) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${entry.key.desc.tr()}${entry.key.isPercent() ? '(%)' : ''}",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: entry.value.map((effects) {
                                return _getEffectChip(_gs.stats.otherEffect, effects, defaultOn: false);
                              }).toList()
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    ExpansionTile(
                      tilePadding: EdgeInsets.only(left: 10, right: 5),
                      childrenPadding: EdgeInsets.all(5),
                      initiallyExpanded: false,
                      title: Text(
                        "Manual Buff".tr(),
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: EffectManager.getManualEffects().map((effect) {
                              return _getEffectChip(_gs.stats.manualEffect, [effect], defaultOn: false);
                            }).toList())
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          );
        }));
  }
}

class BuffPanel extends StatefulWidget {
  const BuffPanel({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BuffPanelState();
  }
}
