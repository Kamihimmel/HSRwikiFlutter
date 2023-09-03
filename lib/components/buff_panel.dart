import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../calculator/basic.dart';
import '../calculator/effect.dart';
import '../calculator/effect_entity.dart';
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
    EffectEntity ee = effect.entity;
    String effectKey = effect.getKey();
    FightProp prop = FightProp.fromEffectKey(ee.addtarget);
    int skillLevel = effect.skillData.maxlevel;
    if (effect.type == Effect.characterType) {
      if (effect.majorId == _gs.stats.id && _gs.stats.skillLevels.containsKey(effect.minorId)) {
        skillLevel = _gs.stats.skillLevels[effect.minorId]!;
      } else if (effect.majorId != _gs.stats.id) {
        if (effect.skillData.maxlevel > 10) {
          skillLevel = 10;
        } else if (effect.skillData.maxlevel > 1) {
          skillLevel = 6;
        }
      }
    }
    String propText = '';
    List<String> propValue = [];
    bool isDmg = effect.isDamageHealShield();
    if (!isDmg) {
      propText = prop.desc.tr();
      effects.forEach((element) {
        double multiplierValue = element.getEffectMultiplierValue(effect.skillData, skillLevel, effectConfig[element.getKey()]) / 100;
        propValue.add(prop.getPropText(multiplierValue, percent: prop == FightProp.lostHP ? true : null));
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

    int stack = ec.stack == 0 ? ee.maxStack : ec.stack;
    FightProp multiplierProp = FightProp.fromEffectKey(ee.multipliertarget);
    String labelText = '';
    if (multiplierProp != FightProp.unknown && effect.type == Effect.characterType) {
      labelText = "${CharacterManager.getCharacter(effect.majorId).getName('lang'.tr())} ${multiplierProp.desc.tr()}${multiplierProp.isPercent() ? '(%)' : ''}";
    }
    if (effect.hasBuffConfig()) {
      List<Widget> widgets = [];
      if (effect.hasValueFieldConfig()) {
        widgets = [
          Container(
            width: 150,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: labelText,
              ),
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
        if (effect.hasStackConfig()) {
          widgets = [
            Text("${'Stacks'.tr()}:$stack"),
            Slider(
              inactiveColor: _cData.elementType.color.withOpacity(0.35),
              activeColor: _cData.elementType.color,
              min: 1,
              max: ee.maxStack.toDouble(),
              divisions: ee.maxStack,
              value: stack.toDouble(),
              onChanged: (value) {
                ec.stack = value.toInt();
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
                for (var i = 1; i <= ee.maxStack; i++)
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
        children: [
          chip,
          Wrap(
            spacing: 10,
            runSpacing: 10,
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
          List<Effect> characterSkillDmg = _cData.entity.skilldata
              .expand((skill) => skill.effect.map((e) => Effect.fromEntity(e, _cData.entity.id, skill.id)).where((e) => e.validDamageHealEffect('dmg') && e.hasBuffConfig())).toList();
          List<Effect> characterSkillBuff = _cData.entity.skilldata
              .expand((skill) => skill.effect.map((e) => Effect.fromEntity(e, _cData.entity.id, skill.id)).where((e) => e.validSelfBuffEffect(null))).toList();
          List<Effect> characterTraceBuff = _cData.entity.tracedata
              .expand((trace) => trace.effect.map((e) => Effect.fromEntity(e, _cData.entity.id, trace.id)).where((e) => !trace.tiny && e.validSelfBuffEffect(null))).toList();
          List<Effect> characterEidolonBuff = _cData.entity.eidolon
              .expand((eidolon) => eidolon.effect
              .map((e) => Effect.fromEntity(e, _cData.entity.id, eidolon.eidolonnum.toString()))
              .where((e) => (_gs.stats.eidolons[eidolon.eidolonnum.toString().toString()] ?? 0) > 0 && e.validSelfBuffEffect(null))).toList();
          List<Effect> lightconeSkillBuff = _lData.entity.skilldata
              .expand((skill) => skill.effect.map((e) => Effect.fromEntity(e, _lData.entity.id, '', type: Effect.lightconeType)).where((e) => e.validSelfBuffEffect(null))).toList();
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
          })
              .expand((record) => record.key.effect.map((e) => Effect.fromEntity(e, record.value.key, record.value.value, type: Effect.relicType)))
              .where((e) => e.validSelfBuffEffect(null))
              .toList();
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
                          if (characterSkillDmg.isNotEmpty || characterSkillBuff.isNotEmpty)
                            ...[
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
                                children: Effect.groupEffect(characterSkillDmg).values.map((effects) {
                                  Effect effect = effects.first;
                                  effect.skillData = CharacterManager.getCharacter(effect.majorId).getSkillById(effect.minorId);
                                  return _getEffectChip(_gs.stats.damageEffect, effects);
                                }).toList(),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: Effect.groupEffect(characterSkillBuff).values.map((effects) {
                                  Effect effect = effects.first;
                                  effect.skillData = CharacterManager.getCharacter(effect.majorId).getSkillById(effect.minorId);
                                  return _getEffectChip(_gs.stats.selfSkillEffect, effects);
                                }).toList(),
                              ),
                            ],
                          if (characterTraceBuff.isNotEmpty)
                            ...[
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
                                children: Effect.groupEffect(characterTraceBuff).values.map((effects) {
                                  Effect effect = effects.first;
                                  effect.skillData = CharacterManager.getCharacter(effect.majorId).getTraceById(effect.minorId);
                                  return _getEffectChip(_gs.stats.selfTraceEffect, effects);
                                }).toList(),
                              ),
                            ],
                          if (characterEidolonBuff.isNotEmpty)
                            ...[
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
                                children: Effect.groupEffect(characterEidolonBuff).values.map((effects) {
                                  Effect effect = effects.first;
                                  effect.skillData = CharacterManager.getCharacter(effect.majorId).getEidolonById(int.tryParse(effect.minorId) ?? 0);
                                  return _getEffectChip(_gs.stats.selfEidolonEffect, effects);
                                }).toList(),
                              )
                            ],
                        ]
                      ),
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
                      children: [
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: Effect.groupEffect(EffectManager.getEffects().values.where((e) => _cData.entity.id != e.majorId && e.validAllyBuffEffect(null)).toList()).values.map((effects) {
                            return _getEffectChip(_gs.stats.otherEffect, effects, defaultOn: false);
                          }).toList())
                      ],
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
