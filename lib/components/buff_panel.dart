import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hsrwikiproject/calculator/basic.dart';
import 'package:hsrwikiproject/calculator/effect_entity.dart';
import 'package:hsrwikiproject/characters/character_entity.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../calculator/effect.dart';
import '../characters/character.dart';
import '../characters/character_manager.dart';
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
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _cData.entity.skilldata.expand((skill) => skill.effect.map((e) => Effect.fromEntity(e, _cData.entity.id, skill.id))
                              .where((e) => e.validSelfBuffEffect(null)).map((e) => [skill, e])).map((pair) {
                            CharacterSkilldata skillData = pair[0] as CharacterSkilldata;
                            Effect effect = pair[1] as Effect;
                            EffectEntity ee = effect.entity;
                            String effectKey = _cData.getEffectKey(skillData.id, ee.iid);
                            String propText = FightProp.fromEffectKey(ee.addtarget).desc.tr();
                            double multiplierValue = effect.getEffectMultiplierValue(skillData, _gs.stats.skillLevels[skillData.id]);
                            String text = "${_cData.getSkillNameById(skillData.id, getLanguageCode(context))} $propText ${multiplierValue.toStringAsFixed(1)}%";
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
