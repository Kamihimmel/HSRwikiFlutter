import 'dart:math';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../calculator/basic.dart';
import '../characters/character.dart';
import '../characters/character_manager.dart';
import '../enemies/enemy.dart';
import '../enemies/enemy_manager.dart';
import '../utils/helper.dart';
import 'global_state.dart';

/// 敌人面板
class EnemyPanelState extends State<EnemyPanel> {
  final GlobalState _gs = GlobalState();

  @override
  void initState() {
    super.initState();
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
          Enemy enemy = EnemyManager.getEnemy(_gs.enemyStats.id);
          double defenceReduce = _gs.stats.getPropValue(FightProp.defenceReduceRatio).values.fold(0, (pre, v) => pre + v);
          double reduceFinal = min(100, defenceReduce * 100 + _gs.enemyStats.defenceReduce);

          Map<FightProp, Map<PropSource, double>> stats = _gs.stats.calculateStats();
          Map<String, List<dynamic>> debuffAttrs = {};
          if (_gs.debug) {
            debuffAttrs[FightProp.defenceReduceRatio.desc] = widget.getBaseAttr(stats, FightProp.defenceReduceRatio);
            debuffAttrs[FightProp.allDamageReceiveRatio.desc] = widget.getBaseAttr(stats, FightProp.allDamageReceiveRatio);
            debuffAttrs[FightProp.dotDamageReceiveRatio.desc] = widget.getBaseAttr(stats, FightProp.dotDamageReceiveRatio);
            debuffAttrs[FightProp.additionalDamageReceiveRatio.desc] = widget.getBaseAttr(stats, FightProp.additionalDamageReceiveRatio);
            for (FightProp p in ElementType.getElementDamageReceiveRatioProps()) {
              debuffAttrs[p.desc] = widget.getBaseAttr(stats, p);
            }
            debuffAttrs[FightProp.speedReduceRatio.desc] = widget.getBaseAttr(stats, FightProp.speedReduceRatio);
          }

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
                        'Enemy Panel'.tr(),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
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
                                                  children: <Widget>[
                                                    for (var e in EnemyManager.getEnemies().entries)
                                                      ListTile(
                                                        leading: getImageComponent(e.value.entity.imageurl, imageWrap: true),
                                                        title: Text(e.value.getName(getLanguageCode(context))),
                                                        trailing: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            for (var weak in e.value.weakness) getImageComponent(weak.icon, imageWrap: true, width: 30),
                                                          ],
                                                        ),
                                                        onTap: () async {
                                                          _gs.enemyStats.id = e.key;
                                                          _gs.changeStats();
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Card(
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: Colors.transparent,
                                elevation: 10,
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                                      border: Border.all(color: Colors.white.withOpacity(0.13)),
                                      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                                        Colors.black12.withOpacity(0.35),
                                        Colors.black.withOpacity(0.35),
                                      ]),
                                    ),
                                    child: getImageComponent(enemy.entity.imageurl, placeholder: kTransparentImage, fit: BoxFit.cover, height: 80, imageWrap: true),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(ElementType.values.where((e) => e != ElementType.diy).length, (index) {
                                ElementType et = ElementType.values.where((e) => e != ElementType.diy).toList()[index];
                                return Column(
                                  children: [
                                    if (index != 0) SizedBox(width: 15),
                                    Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                                            gradient: (enemy.weakness.contains(et))
                                                ? LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.black.withOpacity(0.35), Colors.black.withOpacity(0.5)])
                                                : null,
                                          ),
                                          child: getImageComponent(et.icon, imageWrap: true, width: 30),
                                        ),
                                        SelectableText(
                                          '${enemy.resistence[et] ?? 0}',
                                          style: TextStyle(
                                            fontSize: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
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
                              inactiveColor: _cData.elementType.color.withOpacity(0.35),
                              activeColor: _cData.elementType.color,
                              label: _gs.enemyStats.level.toString(),
                              value: _gs.enemyStats.level.toDouble(),
                              onChanged: (value) {
                                _gs.enemyStats.level = value.toInt();
                                _gs.changeStats();
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
                              '${"EnemyDefenceDebuff".tr()}: ${reduceFinal.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.1,
                              ),
                            ),
                            Slider(
                              min: defenceReduce,
                              max: 100,
                              inactiveColor: _cData.elementType.color.withOpacity(0.35),
                              activeColor: _cData.elementType.color,
                              label: reduceFinal.toStringAsFixed(1),
                              value: reduceFinal.toDouble(),
                              onChanged: (value) {
                                _gs.enemyStats.defenceReduce = value.toInt();
                                _gs.changeStats();
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
                              '${"EnemyMaxHP".tr()}: ${_gs.enemyStats.maxhp}',
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.1,
                              ),
                            ),
                            Slider(
                              min: 100000,
                              max: 1000000,
                              divisions: 50000,
                              inactiveColor: _cData.elementType.color.withOpacity(0.35),
                              activeColor: _cData.elementType.color,
                              label: _gs.enemyStats.maxhp.toString(),
                              value: _gs.enemyStats.maxhp.toDouble(),
                              onChanged: (value) {
                                _gs.enemyStats.maxhp = value.toInt();
                                _gs.changeStats();
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
                              '${"EnemyToughness".tr()}: ${_gs.enemyStats.toughness}',
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.1,
                              ),
                            ),
                            Slider(
                              min: 1,
                              max: 16,
                              inactiveColor: _cData.elementType.color.withOpacity(0.35),
                              activeColor: _cData.elementType.color,
                              label: _gs.enemyStats.toughness.toString(),
                              value: _gs.enemyStats.toughness.toDouble(),
                              onChanged: (value) {
                                _gs.enemyStats.toughness = value.toInt();
                                _gs.changeStats();
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
                              '${"WeaknessBreak".tr()}:',
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.1,
                              ),
                            ),
                            Checkbox(
                              activeColor: _cData.elementType.color,
                              value: _gs.enemyStats.weaknessBreak,
                              onChanged: (bool? value) {
                                _gs.enemyStats.weaknessBreak = value!;
                                _gs.changeStats();
                              },
                            ),
                          ],
                        ),
                      ),
                      if (debuffAttrs.values.where((e) => e[2] > 0).isNotEmpty)
                        ...[
                          SizedBox(height: 10),
                          Column(
                            children: widget.getAttrPanel('', debuffAttrs),
                          ),
                        ],
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }
}

class EnemyPanel extends StatefulWidget {
  final getBaseAttr;
  final getAttrPanel;
  
  const EnemyPanel({
    Key? key,
    required this.getBaseAttr,
    required this.getAttrPanel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EnemyPanelState();
  }
}
