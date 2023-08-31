import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

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
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [_cData.elementType.color.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
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
                          InkWell(
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
                                                          for (var weak in e.value.weakness)
                                                            getImageComponent(weak.icon, imageWrap: true, width: 30),
                                                        ],
                                                      ),
                                                      onTap: () async {
                                                        _gs.enemyStats.id = e.key;
                                                        _gs.enemyStats = _gs.enemyStats;
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
                            child: Container(
                              width: 80,
                              height: 80,
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
                                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                                      Colors.black12.withOpacity(0.35),
                                      Colors.black.withOpacity(0.35),
                                    ]),
                                  ),
                                  child: getImageComponent(enemy.entity.imageurl, placeholder: kTransparentImage, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
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
          );
        }));
  }
}

class EnemyPanel extends StatefulWidget {
  const EnemyPanel({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EnemyPanelState();
  }
}
