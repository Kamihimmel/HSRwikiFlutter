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
import 'global_state.dart';

/// buff面板
class BuffPanelState extends State<BuffPanel> {
  final GlobalState _gs = GlobalState();

  @override
  void initState() {
    super.initState();
  }

  Widget _getEffectChip(Map<String, EffectConfig> effectConfig, Effect effect, {defaultOn = true}) {
    EffectEntity ee = effect.entity;
    String effectKey = effect.getKey();
    FightProp prop = FightProp.fromEffectKey(ee.addtarget);
    String propText = prop != FightProp.unknown ? prop.desc.tr() : '';
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
    bool alwaysOn = ee.type != 'buff' && ee.type != 'debuff';
    double multiplierValue = effect.getEffectMultiplierValue(effect.skillData, skillLevel, effectConfig[effectKey]) / 100;
    String propValue = prop != FightProp.unknown ? prop.getPropText(multiplierValue) : '';
    String text = [effect.getSkillName(getLanguageCode(context)), propText, propValue].join(' ');
    EffectConfig ec = effectConfig[effectKey] ?? (defaultOn ? EffectConfig.defaultOn() : EffectConfig.defaultOff());
    int stack = ec.stack == 0 ? ee.maxStack : ec.stack;
    FilterChip chip = FilterChip(
      label: Tooltip(
        message: '',
        child: Text(text),
        preferBelow: false,
      ),
      selected: alwaysOn || ec.on,
      onSelected: (bool value) {
        ec.on = value;
        effectConfig[effectKey] = ec;
        _gs.changeStats();
      },
    );
    if (effect.hasBuffConfig()) {
      List<Widget> widgets = [];
      if (effect.type == Effect.manualType) {
        widgets = [
          Flexible(
            child: TextFormField(
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
                  return text.isEmpty
                      ? newValue
                      : double.tryParse(text) == null
                      ? oldValue
                      : newValue;
                }),
              ],
            ),
          ),
        ];
      } else {
        if (ee.maxStack >= 5) {
          widgets = [
            Text("${'Stacks'.tr()}:$stack"),
            Slider(
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
        } else {
          widgets = [
            Text("${'Stacks'.tr()}:$stack"),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (var i = 1; i <= ee.maxStack; i++)
                  ChoiceChip(
                    label: Text(i.toString()),
                    selected: stack == i,
                    onSelected: (value) {
                      ec.stack = i;
                      effectConfig[effectKey] = ec;
                      _gs.changeStats();
                    },
                  ),
              ],
            ),
          ];
        }
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          chip,
          Row(
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
                    ExpansionTile(
                        tilePadding: EdgeInsets.only(left: 10, right: 5),
                        childrenPadding: EdgeInsets.all(5),
                        initiallyExpanded: true,
                        title: Text(
                          "Character Buff",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Character Skill Buff",
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
                            children: _cData.entity.skilldata.expand((skill) => skill.effect.map((e) => Effect.fromEntity(e, _cData.entity.id, skill.id))
                                .where((e) => e.validDamageHealEffect('dmg') && e.hasBuffConfig())).map((effect) {
                              effect.skillData = CharacterManager.getCharacter(effect.majorId).getSkillById(effect.minorId);
                              return _getEffectChip(_gs.stats.damageEffect, effect);
                            }).toList(),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _cData.entity.skilldata.expand((skill) => skill.effect.map((e) => Effect.fromEntity(e, _cData.entity.id, skill.id))
                                .where((e) => e.validSelfBuffEffect(null))).map((effect) {
                              effect.skillData = CharacterManager.getCharacter(effect.majorId).getSkillById(effect.minorId);
                              return _getEffectChip(_gs.stats.selfSkillEffect, effect);
                            }).toList(),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Character Trace Buff",
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
                            children: _cData.entity.tracedata.expand((trace) => trace.effect.map((e) => Effect.fromEntity(e, _cData.entity.id, trace.id))
                                .where((e) => !trace.tiny && e.validSelfBuffEffect(null))).map((effect) {
                              effect.skillData = CharacterManager.getCharacter(effect.majorId).getTraceById(effect.minorId);
                              return _getEffectChip(_gs.stats.selfTraceEffect, effect);
                            }).toList(),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Character Eidolon Buff",
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
                            children: _cData.entity.eidolon.expand((eidolon) => eidolon.effect.map((e) => Effect.fromEntity(e, _cData.entity.id, eidolon.eidolonnum.toString()))
                                .where((e) => (_gs.stats.eidolons[eidolon.eidolonnum.toString().toString()] ?? 0) > 0 && e.validSelfBuffEffect(null))).map((effect) {
                              effect.skillData = CharacterManager.getCharacter(effect.majorId).getEidolonById(int.tryParse(effect.minorId) ?? 0);
                              return _getEffectChip(_gs.stats.selfEidolonEffect, effect);
                            }).toList(),
                          )
                        ]),
                    ExpansionTile(
                      tilePadding: EdgeInsets.only(left: 10, right: 5),
                      childrenPadding: EdgeInsets.all(5),
                      initiallyExpanded: true,
                      title: Text(
                        "Lightcone Skill Buff",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _lData.entity.skilldata.expand((skill) => skill.effect.map((e) => Effect.fromEntity(e, _lData.entity.id, '', type: Effect.lightconeType))
                              .where((e) => e.validSelfBuffEffect(null))).map((effect) {
                            effect.skillData = LightconeManager.getLightcone(effect.majorId).getSkill();
                            return _getEffectChip(_gs.stats.lightconeEffect, effect);
                          }).toList(),
                        )
                      ],
                    ),
                    ExpansionTile(
                      tilePadding: EdgeInsets.only(left: 10, right: 5),
                      childrenPadding: EdgeInsets.all(5),
                      initiallyExpanded: true,
                      title: Text(
                        "Relic Skill Buff",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(3, (index) {
                            String setId = _rList[index].entity.id;
                            SkillData skillData = SkillData();
                            String xSet = '';
                            if (setId != '') {
                              if ((index == 0 || index == 2) && _rList[index].entity.skilldata.length > 0) {
                                skillData = _rList[index].getSkill(0);
                                xSet = '2';
                              } else if (_rList[index].entity.skilldata.length > 1) {
                                skillData = _rList[index].getSkill(1);
                                xSet = '4';
                              }
                            }
                            return Record.of(skillData, Record.of(setId, xSet));
                          }).expand((record) => record.key.effect.map((e) => Effect.fromEntity(e, record.value.key, record.value.value, type: Effect.relicType)))
                              .where((e) => e.validSelfBuffEffect(null)).map((effect) {
                            effect.skillData = RelicManager.getRelic(effect.majorId).getSkill(effect.minorId == '2' ? 0 : 1);
                            return _getEffectChip(_gs.stats.relicEffect, effect);
                          }).toList(),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      tilePadding: EdgeInsets.only(left: 10, right: 5),
                      childrenPadding: EdgeInsets.all(5),
                      initiallyExpanded: false,
                      title: Text(
                        "Other Buff",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: EffectManager.getEffects().values.where((e) => _cData.entity.id != e.majorId && e.validAllyBuffEffect(null)).map((effect) {
                              return _getEffectChip(_gs.stats.otherEffect, effect, defaultOn: false);
                            }).toList())
                      ],
                    ),
                    ExpansionTile(
                      tilePadding: EdgeInsets.only(left: 10, right: 5),
                      childrenPadding: EdgeInsets.all(5),
                      initiallyExpanded: false,
                      title: Text(
                        "Manual Buff",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: EffectManager.getManualEffects().map((effect) {
                              return _getEffectChip(_gs.stats.manualEffect, effect, defaultOn: false);
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
