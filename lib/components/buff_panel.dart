import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../calculator/basic.dart';
import '../calculator/effect.dart';
import '../calculator/effect_entity.dart';
import '../calculator/effect_manager.dart';
import '../characters/character.dart';
import '../characters/character_entity.dart';
import '../characters/character_manager.dart';
import '../lightcones/lightcone.dart';
import '../lightcones/lightcone_entity.dart';
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
        child: Consumer<GlobalState>(
          builder: (context, model, child) {
            final Character _cData = CharacterManager.getCharacter(_gs.stats.id);
            final Lightcone _lData = LightconeManager.getLightcone(_gs.stats.lightconeId);
            final List<Relic> _rList = _gs.stats.getRelicSets().where((r) => r != '').map((r) => RelicManager.getRelic(r)).toList();
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
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(color: Colors.white.withOpacity(0.13)),
                      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_cData.elementType.color.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        SelectableText(
                          'Buff Panel'.tr(),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return ChangeNotifierProvider.value(
                                    value: _gs,
                                    child: Consumer<GlobalState>(builder: (context, model, child) {
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
                                                    children: [
                                                      Wrap(
                                                        spacing: 10,
                                                        runSpacing: 10,
                                                        children: _cData.entity.skilldata.expand((skill) => skill.effect.map((e) => Effect.fromEntity(e, _cData.entity.id, skill.id))
                                                            .where((e) => e.validSelfBuffEffect(null)).map((e) => [skill, e])).map((pair) {
                                                          CharacterSkilldata skillData = pair[0] as CharacterSkilldata;
                                                          Effect effect = pair[1] as Effect;
                                                          EffectEntity ee = effect.entity;
                                                          String effectKey = effect.getKey();
                                                          FightProp prop = FightProp.fromEffectKey(ee.addtarget);
                                                          String propText = prop.desc.tr();
                                                          double multiplierValue = effect.getEffectMultiplierValue(skillData, _gs.stats.skillLevels[skillData.id]) / 100;
                                                          String text = "${_cData.getSkillNameById(skillData.id, getLanguageCode(context))} $propText ${prop.getPropText(multiplierValue)}";
                                                          return FilterChip(
                                                            label: Tooltip(
                                                              message: text,
                                                              child: Text(text),
                                                              preferBelow: false,
                                                            ),
                                                            selected: !_gs.stats.selfSkillEffect.containsKey(effectKey) || _gs.stats.selfSkillEffect[effectKey]!.on,
                                                            onSelected: (bool value) {
                                                              if (_gs.stats.selfSkillEffect.containsKey(effectKey)) {
                                                                _gs.stats.selfSkillEffect[effectKey]!.on = value;
                                                              } else {
                                                                EffectConfig ec = EffectConfig();
                                                                ec.on = value;
                                                                _gs.stats.selfSkillEffect[effectKey] = ec;
                                                              }
                                                              _gs.changeStats();
                                                            },
                                                          );
                                                        }).toList(),
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
                          child: Text("Character Skill Buff"),
                        ),
                        SizedBox(height: 30),
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return ChangeNotifierProvider.value(
                                    value: _gs,
                                    child: Consumer<GlobalState>(builder: (context, model, child) {
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
                                                    children: [
                                                      Wrap(
                                                        spacing: 10,
                                                        runSpacing: 10,
                                                        children: _cData.entity.tracedata.expand((trace) => trace.effect.map((e) => Effect.fromEntity(e, _cData.entity.id, trace.id))
                                                            .where((e) => !trace.tiny && e.validSelfBuffEffect(null)).map((e) => [trace, e])).map((pair) {
                                                          CharacterTracedata traceData = pair[0] as CharacterTracedata;
                                                          Effect effect = pair[1] as Effect;
                                                          EffectEntity ee = effect.entity;
                                                          String effectKey = effect.getKey();
                                                          FightProp prop = FightProp.fromEffectKey(ee.addtarget);
                                                          String propText = prop.desc.tr();
                                                          double multiplierValue = effect.getEffectMultiplierValue(null, null) / 100;
                                                          String text = "${_cData.getTraceNameById(traceData.id, getLanguageCode(context))} $propText ${prop.getPropText(multiplierValue)}";
                                                          return FilterChip(
                                                            label: Tooltip(
                                                              message: text,
                                                              child: Text(text),
                                                              preferBelow: false,
                                                            ),
                                                            selected: !_gs.stats.selfTraceEffect.containsKey(effectKey) || _gs.stats.selfTraceEffect[effectKey]!.on,
                                                            onSelected: (bool value) {
                                                              if (_gs.stats.selfTraceEffect.containsKey(effectKey)) {
                                                                _gs.stats.selfTraceEffect[effectKey]!.on = value;
                                                              } else {
                                                                EffectConfig ec = EffectConfig();
                                                                ec.on = value;
                                                                _gs.stats.selfTraceEffect[effectKey] = ec;
                                                              }
                                                              _gs.changeStats();
                                                            },
                                                          );
                                                        }).toList(),
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
                          child: Text("Character Trace Buff"),
                        ),
                        SizedBox(height: 30),
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return ChangeNotifierProvider.value(
                                    value: _gs,
                                    child: Consumer<GlobalState>(builder: (context, model, child) {
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
                                                    children: [
                                                      Wrap(
                                                        spacing: 10,
                                                        runSpacing: 10,
                                                        children: _cData.entity.eidolon.expand((eidolon) => eidolon.effect.map((e) => Effect.fromEntity(e, _cData.entity.id, eidolon.eidolonnum.toString()))
                                                            .where((e) => (_gs.stats.eidolons[eidolon.eidolonnum.toString().toString()] ?? 0) > 0 && e.validSelfBuffEffect(null)).map((e) => [eidolon, e])).map((pair) {
                                                          CharacterEidolon eidolon = pair[0] as CharacterEidolon;
                                                          Effect effect = pair[1] as Effect;
                                                          EffectEntity ee = effect.entity;
                                                          String effectKey = effect.getKey();
                                                          FightProp prop = FightProp.fromEffectKey(ee.addtarget);
                                                          String propText = prop.desc.tr();
                                                          double multiplierValue = effect.getEffectMultiplierValue(null, null) / 100;
                                                          String text = "${_cData.getEidolonName(eidolon.eidolonnum - 1, getLanguageCode(context))} $propText ${prop.getPropText(multiplierValue)}";
                                                          return FilterChip(
                                                            label: Tooltip(
                                                              message: text,
                                                              child: Text(text),
                                                              preferBelow: false,
                                                            ),
                                                            selected: !_gs.stats.selfEidolonEffect.containsKey(effectKey) || _gs.stats.selfEidolonEffect[effectKey]!.on,
                                                            onSelected: (bool value) {
                                                              if (_gs.stats.selfEidolonEffect.containsKey(effectKey)) {
                                                                _gs.stats.selfEidolonEffect[effectKey]!.on = value;
                                                              } else {
                                                                EffectConfig ec = EffectConfig();
                                                                ec.on = value;
                                                                _gs.stats.selfEidolonEffect[effectKey] = ec;
                                                              }
                                                              _gs.changeStats();
                                                            },
                                                          );
                                                        }).toList(),
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
                          child: Text("Character Eidolon Buff"),
                        ),
                        SizedBox(height: 30),
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return ChangeNotifierProvider.value(
                                    value: _gs,
                                    child: Consumer<GlobalState>(builder: (context, model, child) {
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
                                                    children: [
                                                      Wrap(
                                                        spacing: 10,
                                                        runSpacing: 10,
                                                        children: _lData.entity.skilldata.expand((skill) => skill.effect.map((e) => Effect.fromEntity(e, _lData.entity.id, ''))
                                                            .where((e) => e.validSelfBuffEffect(null)).map((e) => [skill, e])).map((pair) {
                                                          LightconeSkilldata skillData = pair[0] as LightconeSkilldata;
                                                          Effect effect = pair[1] as Effect;
                                                          EffectEntity ee = effect.entity;
                                                          String effectKey = effect.getKey();
                                                          FightProp prop = FightProp.fromEffectKey(ee.addtarget);
                                                          String propText = prop.desc.tr();
                                                          double multiplierValue = effect.getEffectMultiplierValue(skillData, _gs.stats.lightconeRank) / 100;
                                                          String text = "${_lData.getSkillName(0, getLanguageCode(context))} $propText ${prop.getPropText(multiplierValue)}";
                                                          return FilterChip(
                                                            label: Tooltip(
                                                              message: text,
                                                              child: Text(text),
                                                              preferBelow: false,
                                                            ),
                                                            selected: !_gs.stats.lightconeEffect.containsKey(effectKey) || _gs.stats.lightconeEffect[effectKey]!.on,
                                                            onSelected: (bool value) {
                                                              if (_gs.stats.lightconeEffect.containsKey(effectKey)) {
                                                                _gs.stats.lightconeEffect[effectKey]!.on = value;
                                                              } else {
                                                                EffectConfig ec = EffectConfig();
                                                                ec.on = value;
                                                                _gs.stats.lightconeEffect[effectKey] = ec;
                                                              }
                                                              _gs.changeStats();
                                                            },
                                                          );
                                                        }).toList(),
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
                          child: Text("Lightcone Skill Buff"),
                        ),
                        SizedBox(height: 30),
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return ChangeNotifierProvider.value(
                                    value: _gs,
                                    child: Consumer<GlobalState>(builder: (context, model, child) {
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
                                                    children: [
                                                      Wrap(
                                                        spacing: 10,
                                                        runSpacing: 10,
                                                        children: [],
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
                          child: Text("Relic Skill Buff"),
                        ),
                        SizedBox(height: 30),
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return ChangeNotifierProvider.value(
                                    value: _gs,
                                    child: Consumer<GlobalState>(builder: (context, model, child) {
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
                                                    children: [
                                                      Wrap(
                                                        spacing: 10,
                                                        runSpacing: 10,
                                                        children: EffectManager.getEffects().values.where((e) => _cData.entity.id != e.majorId && e.validAllyBuffEffect(null)).map((effect) {
                                                          EffectEntity ee = effect.entity;
                                                          String effectKey = effect.getKey();
                                                          FightProp prop = FightProp.fromEffectKey(ee.addtarget);
                                                          String propText = prop.desc.tr();
                                                          double multiplierValue = effect.getEffectMultiplierValue(effect.skillData, effect.skillData.maxlevel) / 100;
                                                          String text = "${effect.getSkillName(getLanguageCode(context))} $propText ${prop.getPropText(multiplierValue)}";
                                                          return FilterChip(
                                                            label: Tooltip(
                                                              message: text,
                                                              child: Text(text),
                                                              preferBelow: false,
                                                            ),
                                                            selected: _gs.stats.otherEffect.containsKey(effectKey) && _gs.stats.otherEffect[effectKey]!.on,
                                                            onSelected: (bool value) {
                                                              if (_gs.stats.otherEffect.containsKey(effectKey)) {
                                                                _gs.stats.otherEffect[effectKey]!.on = value;
                                                              } else {
                                                                EffectConfig ec = EffectConfig();
                                                                ec.on = value;
                                                                _gs.stats.otherEffect[effectKey] = ec;
                                                              }
                                                              _gs.changeStats();
                                                            },
                                                          );
                                                        }).toList(),
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
                          child: Text("Other Buff"),
                        ),
                      ]
                    ),
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
